import 'package:final_app/firebase_options.dart';
import 'package:final_app/services/auth/auth_page.dart';
import 'package:final_app/pages/customer/customer_home_nav.dart';
import 'package:final_app/pages/customer/customer_settings_page.dart';
import 'package:final_app/pages/register_page.dart';
import 'package:final_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_app/pages/intro_page.dart';
import 'package:final_app/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/register_page': (context) => const RegisterPage(onTap: null),
        '/auth_page': (context) => const AuthPage(),
        '/login_page': (context) => const LoginPage(onTap: null),
        '/customer_settings_page': (context) => const CustomerSettingsPage(),
        '/customer_home_nav': (context) => const CustomerHomeNav(),
      },
    );
  }
}
