import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionPromptScreen extends StatelessWidget {
  const SubscriptionPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribe to Get Listed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome, ${user?.email ?? 'lawyer'}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              const Text(
                'Subscribe to appear in the MyRightToKnow app and reach new clients. '
                'Your profile will be searchable by location, language, and specialty.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                '\$200 / month',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Placeholder for Stripe payment');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stripe payment not yet implemented')),
                  );
                },
                child: const Text('Subscribe Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}