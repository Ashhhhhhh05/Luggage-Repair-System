import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/home_page.dart';
import 'package:final_app/pages/login_or_register_page.dart';
import 'package:final_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          //user is logged in
          if (authSnapshot.hasData) {
            final User? user = authSnapshot.data;

            //check user role in firestore
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.hasError) {
                  return Text('Error: ${roleSnapshot.error}');
                }

                //wait for Firestore data
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                //check the users role
                if (roleSnapshot.data != null && roleSnapshot.data!.exists) {
                  final role = roleSnapshot.data!.get('role');
                  if (role == 'admin') {
                    return AdminPage();
                  } else {
                    return HomePage();
                  }
                } else {
                  //if user not found
                  return const LoginOrRegisterPage();
                }
              },
            );
          } else {
            //user not logged in/failed
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
