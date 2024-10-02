import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/components/my_textfield.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //text-editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async {
    //show loading icon
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //try sign in
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // store user info in a separate doc
      _firestore.collection("chats").doc(userCredential.user!.uid).update(
        {
          'uid': userCredential.user!.uid, 'email': emailController.text.trim(),
        },
      );
      //pop the loading icon
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading icon
      Navigator.pop(context);
      //show error message
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                decoration:  BoxDecoration(
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
                          Icon(
                            Icons.shopping_bag,
                            size: 100,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),

                          //welcome back
                          Text(
                            "Welcome back, you've been missed!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                          ),

                          const SizedBox(height: 25),

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

                          //forgot password
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const ForgotPasswordPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Color(0xFF416FDF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          //signIn button
                          MyButton(
                            color: Theme.of(context).colorScheme.tertiary,
                            onTap: signUserIn,
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          //not a member? signUp here
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Not a member?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  'Register here',
                                  style: TextStyle(
                                    color: Color(0xFF416FDF),
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
