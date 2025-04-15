import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/url_launcher_helpers.dart';

class SubscriptionPromptScreen extends StatelessWidget {
  const SubscriptionPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe to Get Listed')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome, ${user?.email ?? 'lawyer'}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Subscribe to be listed in the My Right To Stay mobile app and get discovered by clients seeking immigration legal help.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  '\$200 / month',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your subscription includes:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Listed in the My Right To Stay smartphone app'),
                      Text('• Reach non-citizens seeking immigration help'),
                      Text('• Clients can message you via the panic button'),
                      Text('• Supports English & Spanish localization'),
                      Text('• Searchable by location, language, and specialty'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final currentContext = context;
                    try {
                      final response = await http.post(
                        Uri.parse('https://createcheckoutsession-nzgeau3iuq-uc.a.run.app'),
                      );

                      if (!currentContext.mounted) return;

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        final checkoutUrl = data['url'];
                         UrlLauncherHelper.launchWebAppWebsite(checkoutUrl, currentContext);
                      } else {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          SnackBar(
                            content: Text('Failed to create Stripe session: ${response.body}'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!currentContext.mounted) return;
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text('Stripe error: $e')),
                      );
                    }
                  },
                  child: const Text('Subscribe Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}