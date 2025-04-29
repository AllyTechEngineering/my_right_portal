# Stripe Billing Portal Access Solutions for Flutter Web App

## Purpose
This document outlines two professional solutions to prevent browser pop-up blockers when launching an external Stripe Billing Portal from a Flutter web app button.

---

# 🛠 Solution 1: Loading Screen Approach (Intermediate Screen)

## Flow:
- User taps "Manage Billing" button.
- Immediately navigates to a "LoadingBillingPortalScreen".
- Inside `initState`, make the HTTP POST call to Firebase Functions to retrieve the Stripe URL.
- Then `launchUrl` to open the Stripe billing portal.

## Advantages:
- Solves pop-up blocker problem cleanly.
- Professional, app-like user experience.

## `loading_billing_portal_screen.dart` Example:

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoadingBillingPortalScreen extends StatefulWidget {
  const LoadingBillingPortalScreen({Key? key}) : super(key: key);

  @override
  State<LoadingBillingPortalScreen> createState() => _LoadingBillingPortalScreenState();
}

class _LoadingBillingPortalScreenState extends State<LoadingBillingPortalScreen> {
  @override
  void initState() {
    super.initState();
    _launchBillingPortal();
  }

  Future<void> _launchBillingPortal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-my-right-portal.cloudfunctions.net/createBillingPortalSession'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "${user.uid}"}',
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final url = Uri.parse(jsonDecode(response.body)['url']);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

## Update Your Button:
Instead of calling `_launchBillingPortal(context)`, do:

```dart
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoadingBillingPortalScreen()),
  );
},
```

---

# 🛠 Solution 2: AlertDialog Confirmation Approach

## Flow:
- User taps "Manage Billing" button.
- An `AlertDialog` appears asking "Are you sure you want to leave the app and go to Stripe?"
- If the user taps "Continue," then the app proceeds to POST and redirect.

## Advantages:
- No need for a second screen.
- Very lightweight.
- Feels very professional (similar to PayPal, Google confirmation dialogs).

## `_showBillingPortalConfirmation` Method Example:

```dart
void _showBillingPortalConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final localizations = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(localizations.dashboard_billing_portal_title),
        content: Text(localizations.dashboard_billing_portal_message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(localizations.dashboard_billing_portal_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchBillingPortal(context);
            },
            child: Text(localizations.dashboard_billing_portal_continue),
          ),
        ],
      );
    },
  );
}
```

## Update Your Button:
Instead of calling `_launchBillingPortal(context)`, do:

```dart
onPressed: () => _showBillingPortalConfirmation(context),
```

---

# 📋 Localizations Needed (`app_en.arb` and `app_es.arb`)

### English (`app_en.arb`):
```json
{
  "dashboard_billing_portal_title": "Manage Billing",
  "dashboard_billing_portal_message": "You are about to leave the app and visit the secure Stripe billing portal. Do you want to continue?",
  "dashboard_billing_portal_cancel": "Cancel",
  "dashboard_billing_portal_continue": "Continue"
}
```

### Spanish (`app_es.arb`):
```json
{
  "dashboard_billing_portal_title": "Administrar Facturación",
  "dashboard_billing_portal_message": "Estás a punto de salir de la aplicación y visitar el portal de facturación seguro de Stripe. ¿Deseas continuar?",
  "dashboard_billing_portal_cancel": "Cancelar",
  "dashboard_billing_portal_continue": "Continuar"
}
```

---

# ✅ Final Notes

| Option | Best For |
|:--|:--|
| Loading Screen | Full redirect experiences, fancier UX |
| AlertDialog Confirmation | Quick confirmations, lightweight apps |

Both solutions **solve** the browser pop-up blocking issue correctly.

---

# 📦 Recommendation
- If you want fast lightweight fix: **AlertDialog**.
- If you want Stripe/PayPal-level full polish: **Loading Screen**.