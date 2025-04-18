import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          debugPrint('Login successful');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful')));
          Navigator.pushReplacementNamed(context, '/auth-gate');
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Login', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (value) => _email = value.trim(),
                    validator:
                        (value) => value!.isEmpty ? 'Email required' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      helperStyle: TextStyle(fontSize: 12, color: Colors.grey),
                      labelText: 'Password',
                      hintText:
                          'Min 6 chars, 1 upper, 1 lower, 1 number, 1 special char',
                    ),
                    obscureText: true,
                    onChanged: (value) => _password = value,
                    validator:
                        (value) => value!.isEmpty ? 'Password required' : null,
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Log In'),
                      ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed:
                        () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/signup',
                          (route) => false,
                        ),
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
