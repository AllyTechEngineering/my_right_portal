import 'package:flutter/material.dart';

class LawyerDashboardScreen extends StatelessWidget {
  const LawyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1024;
    final isTablet = width >= 600 && width < 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Right Portal Dashboard'),
        centerTitle: true,
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
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () {
                  // TODO: Navigate to edit profile screen
                },
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed:
                    () => Navigator.pushNamed(context, '/lawyer-profile-form'),
                child: const Text('Manage Your Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(Icons.credit_card),
                label: const Text('Manage Billing'),
                onPressed: () {
                  // TODO: Navigate to billing screen or Stripe Checkout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
