import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomerAccountPage extends StatefulWidget {
  const CustomerAccountPage({super.key});

  @override
  State<CustomerAccountPage> createState() => _CustomerAccountPageState();
}

class _CustomerAccountPageState extends State<CustomerAccountPage> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String firstName = "";
  String surname = "";
  String _phoneNumber = "+27631634734";
  String _email = "";

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

  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final RegExp phoneRegex = RegExp(r'^\+?\d{10,15}$');
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  bool isPhoneNumberValid(String phoneNumber) {
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
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
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => buildBottomSheet());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[900],
                      radius: 25,
                      child:
                          const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
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
          _buildCustomTile(
            title: "Name",
            subtitle: "$firstName" + " " + "$surname",
            icon: Icons.person,
            onTap: () {
              _showUpdateDialog(
                title: "Update your name",
                controller: _nameController,
                onSave: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    setState(() {
                      firstName = _nameController.text.trim();
                    });
                    Navigator.of(context).pop();
                    _showSnackBar(
                        "Name successfully updated.", Colors.green[900]!);
                  } else {
                    _showSnackBar("Name cannot be empty.", Colors.red[900]!);
                  }
                },
              );
            },
          ),
          _buildCustomTile(
            title: "Phone Number",
            subtitle: _phoneNumber,
            icon: Icons.phone,
            onTap: () {
              _showUpdateDialog(
                title: "Update your Phone Number",
                isPhoneField: true,
                controller: _phoneController,
                onSave: () {
                  if (isPhoneNumberValid(_phoneController.text)) {
                    setState(() {
                      _phoneNumber = "+27${_phoneController.text}";
                    });
                    Navigator.pop(context);
                    _showSnackBar("Phone number successfully updated.",
                        Colors.green[900]!);
                  } else {
                    _showSnackBar(
                        "Please enter a valid phone number.", Colors.red[900]!);
                  }
                },
              );
            },
          ),
          _buildCustomTile(
            title: "Email",
            subtitle: user.email!,
            icon: Icons.email,
            onTap: () {
              _showUpdateDialog(
                title: "Update your email address",
                controller: _emailController,
                onSave: () {
                  if (isEmailValid(_emailController.text)) {
                    setState(() {
                      _email = _emailController.text;
                    });
                    Navigator.pop(context);
                    _showSnackBar(
                        "Email successfully updated.", Colors.green[900]!);
                  } else {
                    _showSnackBar("Please enter a valid email address.",
                        Colors.red[900]!);
                  }
                },
              );
            },
          ),
        ]),
      ),
    ));
  }

  Widget buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 200,
      child: Column(
        children: [
          Text(
            "Profile photo",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: Colors.blue[900]),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[900],
                      child: Icon(Icons.photo_library_outlined,
                          size: 28, color: Colors.white),
                    ),
                    onTap: () async {
                      await _pickImage();
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Gallery",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "nunito",
                        color: Colors.blue[900]),
                  ),
                ],
              ),
              SizedBox(
                width: 28,
              ),
              Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[900],
                      child: Icon(Icons.camera_alt_outlined,
                          size: 28, color: Colors.white),
                    ),
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();

                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Camera",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "nunito",
                        color: Colors.blue[900]),
                  ),
                ],
              ),
              SizedBox(
                width: 28,
              ),
              Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[900],
                      child: Icon(Icons.delete_outline,
                          size: 28, color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedImage = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Remove",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "nunito",
                        color: Colors.blue[900]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTile(
      {required String title,
      required String subtitle,
      required IconData icon,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[900]),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
            fontFamily: "Mont",
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: "Mont",
            color: Colors.blue,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_outlined, size: 30),
        onTap: onTap,
      ),
    );
  }

  void _showUpdateDialog(
      {required String title,
      required TextEditingController controller,
      required VoidCallback onSave,
      bool isPhoneField = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            title,
            style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontFamily: "Mont",
                fontSize: 18),
          ),
          content: isPhoneField
              ? IntlPhoneField(
                  controller: controller,
                  initialCountryCode: 'ZA',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontFamily: "nunito"),
              ),
            ),
            TextButton(
              onPressed: onSave,
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontFamily: "nunito"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'nunito'),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }
}
