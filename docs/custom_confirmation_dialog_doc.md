# Custom Confirmation Dialog for Flutter Web App

## Purpose
Provides a reusable confirmation dialog for user actions that may trigger external navigation or critical events, such as:
- Launching the Stripe Billing Portal
- Redirecting to Stripe Checkout for subscription
- Confirming irreversible actions

This dialog ensures:
- Professional UX
- Browser pop-up blockers are avoided
- User stays informed and in control
- Consistent design across the entire app

---

## File Location
`lib/widgets/custom_confirmation_dialog.dart`

---

## Full Code

```dart
import 'package:flutter/material.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String cancelLabel,
  required String continueLabel,
  required VoidCallback onConfirmed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog first
              onConfirmed(); // Then call the confirm callback
            },
            child: Text(continueLabel),
          ),
        ],
      );
    },
  );
}
```

---

## Usage Example: Billing Portal Button

```dart
showConfirmationDialog(
  context: context,
  title: localizations.dashboard_billing_portal_title,
  message: localizations.dashboard_billing_portal_message,
  cancelLabel: localizations.dashboard_billing_portal_cancel,
  continueLabel: localizations.dashboard_billing_portal_continue,
  onConfirmed: () => _launchBillingPortal(context),
);
```

---

## Usage Example: Stripe Subscription Button

```dart
showConfirmationDialog(
  context: context,
  title: localizations.checkout_confirmation_title,
  message: localizations.checkout_confirmation_message,
  cancelLabel: localizations.checkout_confirmation_cancel,
  continueLabel: localizations.checkout_confirmation_continue,
  onConfirmed: () => _startStripeCheckout(context),
);
```

---

## Required Localization Strings

### English (`app_en.arb`)
```json
{
  "dashboard_billing_portal_title": "Manage Billing",
  "dashboard_billing_portal_message": "You are about to leave the app and visit the secure Stripe billing portal. Do you want to continue?",
  "dashboard_billing_portal_cancel": "Cancel",
  "dashboard_billing_portal_continue": "Continue",
  "checkout_confirmation_title": "Continue to Checkout",
  "checkout_confirmation_message": "You are about to leave the app and complete your subscription on Stripe.",
  "checkout_confirmation_cancel": "Cancel",
  "checkout_confirmation_continue": "Continue"
}
```

### Spanish (`app_es.arb`)
```json
{
  "dashboard_billing_portal_title": "Administrar Facturación",
  "dashboard_billing_portal_message": "Estás a punto de salir de la aplicación y visitar el portal de facturación seguro de Stripe. ¿Deseas continuar?",
  "dashboard_billing_portal_cancel": "Cancelar",
  "dashboard_billing_portal_continue": "Continuar",
  "checkout_confirmation_title": "Continuar al Pago",
  "checkout_confirmation_message": "Estás a punto de salir de la aplicación y completar tu suscripción en Stripe.",
  "checkout_confirmation_cancel": "Cancelar",
  "checkout_confirmation_continue": "Continuar"
}
```

---

## Benefits
- Centralizes all confirmation dialogs
- Localized (English and Spanish)
- Consistent button layout (Cancel on left, Continue on right)
- Solves browser pop-up blocker behavior for web apps
- Clean and scalable design for future confirmations

---

## Recommendation
Always use `showConfirmationDialog()` whenever you:
- Redirect users to an external site (e.g., Stripe, PayPal)
- Perform critical or irreversible actions
- Need users to intentionally approve an action

This builds **trust**, **transparency**, and **professionalism** into your app.