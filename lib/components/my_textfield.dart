import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData myIcon;

  const MyTextField(
      {super.key,
        required this.controller,
        required this.hintText,
        required this.obscureText,
        required this.myIcon,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            myIcon,
            color: Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(22),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(30.0),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
