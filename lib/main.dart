import 'package:final_app/firebase_options.dart';
import 'package:final_app/pages/auth_page.dart';
import 'package:final_app/themes/dark_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_app/pages/intro_page.dart';
import 'package:final_app/pages/login_page.dart';
import 'package:final_app/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/auth_page': (context) =>  const AuthPage(),
        '/login_page': (context) => const LoginPage(onTap: null,),
      },
    );
  }
}
