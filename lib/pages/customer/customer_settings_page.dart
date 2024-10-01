import 'package:final_app/components/my_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_app/themes/theme_provider.dart';

class CustomerSettingsPage extends StatelessWidget {
  const CustomerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: [
          // update account details
          const MyContainer(
              string: 'Update Account Details',
              widget: Icon(Icons.arrow_forward_ios_outlined)),

          // dark mode
          MyContainer(
            string: 'Dark Mode',
            widget: CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
              activeColor: const Color(0xFF416FDF),
            ),
          ),

          // Leave Feedback
          const MyContainer(
            string: 'Leave Feedback',
            widget: Icon(Icons.arrow_forward_ios_outlined),
          ),

          // Contact Us
          const MyContainer(
            string: 'Contact Us',
            widget: Icon(Icons.arrow_forward_ios_outlined),
          ),

          // Terms and Conditions
          const MyContainer(
            string: 'Terms and Conditions',
            widget: Icon(Icons.arrow_forward_ios_outlined),
          ),

          // Privacy Policy
          const MyContainer(
            string: 'Privacy Policy',
            widget: Icon(Icons.arrow_forward_ios_outlined),
          ),
        ],
      ),
    );
  }
}
