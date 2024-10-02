import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/customer/customer_home_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //text-editing controllers
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign user in method
  void signUserUp() async {
    //show loading icon
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //try creating the user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // store user info in a separate doc
        _firestore.collection("chats").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': emailController.text.trim(),
            'role': 'customer',
          },
        );

        //Get user id
        String uid = userCredential.user!.uid;

        //Pop loading icon + save customers role in Firestore
        Navigator.pop(context);
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'role': 'customer',
          'firstName': nameController.text.trim(),
          'Surname': surnameController.text.trim(),
        });

        // Navigate to Homepage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerHomeNav()),
        );
      } else {
        //pop loading icon + show error message, passwords don't match
        Navigator.pop(context);
        showErrorMessage("Passwords do not match!");
      }
    } on FirebaseAuthException catch (e) {
      //pop loading + show error message
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  //show error to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('lib/assets/home_bg.jpeg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            // show background
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),

                          //logo
                          Icon(Icons.shopping_bag,
                              size: 100,
                              color: Theme.of(context).colorScheme.tertiary),

                          const SizedBox(height: 15),

                          Text(
                            "Let's create you an account!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),

                          //name text field
                          MyTextField(
                            controller: nameController,
                            label: 'First Name',
                            obscureText: false,
                            myIcon: Icons.person_outline,
                          ),

                          //surname text field
                          MyTextField(
                            controller: surnameController,
                            label: 'Surname',
                            obscureText: false,
                            myIcon: Icons.person_outline,
                          ),

                          //email text field
                          MyTextField(
                            controller: emailController,
                            label: 'Email',
                            obscureText: false,
                            myIcon: Icons.email_outlined,
                          ),

                          //password text field
                          MyTextField(
                            controller: passwordController,
                            label: 'Password',
                            obscureText: true,
                            myIcon: Icons.lock_outline,
                            showPasswordToggle: true,
                          ),

                          //confirm password text field
                          MyTextField(
                            controller: confirmPasswordController,
                            label: 'Confirm Password',
                            obscureText: true,
                            myIcon: Icons.lock_outline,
                            showPasswordToggle: true,
                          ),

                          //signIn button
                          MyButton(
                            color: Theme.of(context).colorScheme.tertiary,
                            onTap: signUserUp,
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          //already a member? Login here
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  'Login here',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
