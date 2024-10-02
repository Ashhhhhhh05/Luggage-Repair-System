import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/login_or_register_page.dart';
import 'package:final_app/pages/admin/unauthorized_access.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../pages/admin/admin_page.dart';
import '../../pages/customer/customer_home_nav.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthPage extends StatelessWidget {
  // get current user
  User? getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }

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
                if (roleSnapshot.hasData && roleSnapshot.data != null) {
                  final data = roleSnapshot.data;
                  if (data != null && data.exists) {
                    final role = roleSnapshot.data!.get('role');

                    if (kIsWeb) {
                      if (role == 'admin') {
                        return AdminPage();
                      } else {
                        return const CustomerHomeNav();
                      }
                    } else {
                      if (role == 'admin') {
                        FirebaseAuth.instance.signOut().then((_) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const UnauthorizedAccess()),
                          );
                          });
                      } else {
                        return const CustomerHomeNav();
                      }
                    }
                  }
                }
                //if user not found
                return const LoginOrRegisterPage();
              },
            );
          } else {
            //user not logged in
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
