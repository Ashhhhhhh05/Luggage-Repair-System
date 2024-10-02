import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerAccountPage extends StatefulWidget {
  const CustomerAccountPage({super.key});

  @override
  State<CustomerAccountPage> createState() => _CustomerAccountPageState();
}

class _CustomerAccountPageState extends State<CustomerAccountPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String firstName = "";
  String surname = "";

  @override
  void initState() {
    super.initState();
    // Fetch user data when the page initializes
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          firstName =
              userDoc['firstName'] ?? ''; // Get first name from Firestore
          surname = userDoc['Surname'] ?? ''; // Get surname from Firestore
        });
      }
    } catch (e) {
      // Handle error (optional)
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(Icons.edit, size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "User Info",
            style: TextStyle(
              color: Colors.blue[900]!,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: "nunito",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              "Name",
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontFamily: "Mont",
                //fontSize: 18,
              ),
            ),
            subtitle: Text(
              "$firstName" + " " +"$surname",
              style: const TextStyle(
                fontFamily: "Mont",
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 30,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              "Phone Number",
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontFamily: "Mont",
                //fontSize: 18,
              ),
            ),
            subtitle: const Row(
              children: [
                Text(
                  "+27631634734",
                  style: TextStyle(
                    fontFamily: "Mont",
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 30,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              "Email",
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontFamily: "Mont",
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontFamily: "Mont",
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 30,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Location',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontFamily: "Mont",
              ),
            ),
            subtitle: const Row(
              children: [
                Text(
                  'Durban, KwaZulu-Natal · 4091',
                  style: TextStyle(
                    fontFamily: "Mont",
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            trailing: TextButton(
              onPressed: () {},
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontFamily: "Mont",
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}
