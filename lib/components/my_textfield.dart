import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData myIcon;
  final bool showPasswordToggle;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.myIcon,
    this.showPasswordToggle = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText;
  }

  void toggleVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.myIcon,
            color: Colors.black,
          ),
          suffixIcon: widget.showPasswordToggle ? GestureDetector(
            onTap: toggleVisibility,
            child: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
          )
          : null,
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
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
