import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // ignore: unused_field
  final bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (!user.emailVerified) {
      debugPrint('User is not verified');
      Navigator.pushReplacementNamed(context, '/verify-email');
    } else {
      final doc =
          await FirebaseFirestore.instance
              .collection('lawyers')
              .doc(user.uid)
              .get();

      final isSubscribed = doc.data()?['subscriptionActive'] == true;
      debugPrint('User ${user.uid}  subscription status: $isSubscribed');
      if (!mounted) return; //
      if (isSubscribed) {
        debugPrint('User is subscribed');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/lawyer-dashboard',
          (Route<dynamic> route) => false, // removes everything before
        );
      } else {
        debugPrint('User is not subscribed');
        Navigator.pushReplacementNamed(context, '/subscription-prompt');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              CustomTextWidget(
                localizations.auth_gate_msg,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
