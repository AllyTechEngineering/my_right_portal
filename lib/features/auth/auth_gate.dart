import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    await user?.reload(); // Make sure user info is fresh

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (!user.emailVerified) {
      Navigator.pushReplacementNamed(context, '/verify-email');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard'); // or home screen
      //       Navigator.pushNamed(context, '/lawyer-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: Center(child: CircularProgressIndicator()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Checking authentication status...'),
          ],
        ),
      ),
    );
  }
}
