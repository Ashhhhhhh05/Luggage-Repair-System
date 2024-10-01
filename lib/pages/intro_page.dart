import 'package:flutter/material.dart';
import 'package:final_app/components/my_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/assets/home_bg.jpeg'),
              fit: BoxFit.cover,
            )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  const Icon(
                    Icons.shopping_bag,
                    size: 95,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  //title
                  const Text(
                    "Welcome to Matrix!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  //button
                  MyButton(
                    color: Colors.black,
                    onTap: () => Navigator.pushNamed(context, '/auth_page'),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )));
  }
}
