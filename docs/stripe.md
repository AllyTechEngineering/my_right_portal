# Stripe Checkout Integration – Flutter Web App (Right2StayNow)

## ✅ Overview
This guide helps you integrate **Stripe Checkout** into your Flutter web app using Firebase Functions and Stripe.js. It assumes:
- You already have a Stripe account and admin access
- You’re using Firebase for hosting and backend
- You’re targeting a subscription-based model

---

## 🛠️ Step-by-Step: Stripe Checkout Integration

### 🔹 Step 1: Enable Stripe Checkout
1. Go to your [Stripe Dashboard → Products](https://dashboard.stripe.com/products)
2. Create a **Product** (e.g., Monthly Subscription)
3. Create a **Price** and note the **Price ID** (e.g., `price_1NvHXXXX`)

---

### 🔹 Step 2: Stripe API Keys
From [Stripe Dashboard → Developers → API Keys](https://dashboard.stripe.com/apikeys):
- Copy your **Publishable key** (`pk_live_...`)
- Copy your **Secret key** (`sk_live_...`) — used only in backend

---

### 🔹 Step 3: Firebase Cloud Functions (Create Session)
1. Run `firebase init functions` (if not yet initialized)
2. Install Stripe:
   ```bash
   cd functions
   npm install stripe
   ```

3. Add this to `functions/index.js`:

```js
const functions = require('firebase-functions');
const stripe = require('stripe')('sk_test_YOUR_SECRET_KEY'); // Use env variable in production
const cors = require('cors')({ origin: true });

exports.createCheckoutSession = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ['card'],
        mode: 'subscription',
        line_items: [
          {
            price: 'price_YOUR_PRICE_ID',
            quantity: 1,
          },
        ],
        success_url: 'https://right2staynow.com/success',
        cancel_url: 'https://right2staynow.com/cancel',
      });

      res.status(200).json({ id: session.id });
    } catch (e) {
      res.status(500).send(e.message);
    }
  });
});
```

4. Deploy:
```bash
firebase deploy --only functions
```

---

### 🔹 Step 4: Add Stripe JS to Flutter Web

In `pubspec.yaml`:
```yaml
dependencies:
  stripe_js: ^1.0.0
```

In your Dart file (e.g., `subscription_prompt_screen.dart`):

```dart
import 'package:stripe_js/stripe_js.dart' as stripe;
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> redirectToCheckout() async {
  final response = await http.post(
    Uri.parse('https://us-central1-YOUR_PROJECT.cloudfunctions.net/createCheckoutSession'),
  );

  final data = jsonDecode(response.body);
  final stripeInstance = stripe.Stripe('pk_test_YOUR_PUBLIC_KEY');
  await stripeInstance.redirectToCheckout(sessionId: data['id']);
}
```

Call `redirectToCheckout()` on button tap.

---

### 🔹 Step 5: Success and Cancel Screens
In your Flutter web app:
- `/success` → confirmation screen
- `/cancel` → user canceled, show info or retry

---

## ✅ Summary

| Task | Tool |
|------|------|
| Create secure session | Firebase Functions |
| Redirect to Stripe-hosted UI | stripe_js |
| Manage Stripe logic | Stripe Dashboard |
| Keep payment info secure | Stripe Checkout (PCI-compliant)

---

Let me know if you want to add webhooks, Stripe customer portal, or real-time subscription tracking in Firestore.