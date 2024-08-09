import 'package:flutter/material.dart';
import 'package:final_app/components/my_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.shopping_bag,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),

            //title
            const Text(
              "Welcome to Gopals Repairs!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 35),

            //button
            MyButton(
              onTap: () => Navigator.pushNamed(context, '/auth_page'),
              child: const Icon(Icons.arrow_forward, color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
