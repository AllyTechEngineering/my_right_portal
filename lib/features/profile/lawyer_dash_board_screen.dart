import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
// import 'package:my_right_portal/widgets/custom_bottom_nav_bar.dart';
// import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:my_right_portal/widgets/custom_text_widget.dart';

class LawyerDashboardScreen extends StatelessWidget {
  const LawyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1024;
    final isTablet = width >= 600 && width < 1024;
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBarWidget(
        title: localizations.legal_help_title,
        getToolBarHeight: getToolBarHeight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child:
                isDesktop
                    ? _buildDesktopLayout(context)
                    : _buildMobileOrTabletLayout(context, isTablet),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _ProfileSummaryCard()),
        const SizedBox(width: 16),
        Expanded(child: _BillingSummaryCard()),
      ],
    );
  }

  Widget _buildMobileOrTabletLayout(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileSummaryCard(),
        const SizedBox(height: 16),
        _BillingSummaryCard(),
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👤 Profile Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Name: Jane Doe, Esq.'),
            const Text('Law Firm: Justice Partners LLC'),
            const Text('Status: Published'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed:
                    () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/data-form',
                      (Route<dynamic> route) =>
                          false, // removes everything before
                    ),
                style: ElevatedButton.styleFrom(
                  elevation: 3.0,
                  shadowColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryFixedVariant,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide.none,
                  ),
                ),
                child: Text(
                  localizations.dashboard_manage_data,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 3.0,
                  shadowColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryFixedVariant,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide.none,
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: Text(
                  localizations.dashboard_log_out,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (Route<dynamic> route) =>
                        false, // removes everything before
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingSummaryCard extends StatefulWidget {
  @override
  State<_BillingSummaryCard> createState() => _BillingSummaryCardState();
}

class _BillingSummaryCardState extends State<_BillingSummaryCard> {
  void _launchBillingPortal(String userId) async {
    debugPrint("Launching billing portal for user: $userId");
    try {
      final response = await http.post(
        Uri.parse(
          'https://us-central1-my-right-portal.cloudfunctions.net/createBillingPortalSession',
        ),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "$userId"}',
      );

      if (!mounted) return; // ✅ Important safety check

      if (response.statusCode == 200) {
        final url = Uri.parse(jsonDecode(response.body)['url']);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (!mounted) return; // ✅ Important safety check
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not open Stripe portal")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating billing portal session")),
        );
      }
    } catch (e) {
      debugPrint("Error launching billing portal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💳 Billing Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Status: Active'),
            const Text('Next Payment: May 10, 2025'),
            const Text('Plan: Monthly Subscription'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 3.0,
                  shadowColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryFixedVariant,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide.none,
                  ),
                ),
                icon: Icon(Icons.credit_card),
                label: Text(
                  'Manage Billing',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  debugPrint("Current User: $currentUser");
                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You must be signed in.")),
                    );
                    return;
                  }

                  final userId = currentUser.uid;
                  debugPrint("User ID: $userId");
                  try {
                    final userDoc =
                        await FirebaseFirestore.instance
                            .collection('lawyers')
                            .doc(userId)
                            .get();
                    debugPrint("User Document: ${userDoc.data()}");
                    if (!userDoc.exists ||
                        !userDoc.data()!.containsKey('stripeCustomerId')) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Stripe customer ID not found."),
                        ),
                      );
                      return;
                    }

                    // Launch the portal
                    _launchBillingPortal(
                      userId,
                    ); // userId is still used in your backend function
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
