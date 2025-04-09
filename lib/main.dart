import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_right_portal/features/auth/auth_gate.dart';
import 'package:my_right_portal/features/auth/login_screen.dart';
import 'package:my_right_portal/features/auth/signup_screen.dart';
import 'package:my_right_portal/features/auth/verify_email_screen.dart';
import 'package:my_right_portal/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Right Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0441B2)),
      ),
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/verify-email': (context) => const VerifyEmailScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
