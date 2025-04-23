
# How to Test Stripe Transactions Locally with Firebase Emulators

This guide walks you through simulating Stripe Checkout and webhook flows using local Firebase Functions and Stripe CLI in debug mode.

---

## ✅ Prerequisites

- Firebase Emulators running (`firebase emulators:start`)
- Stripe CLI installed (`brew install stripe` or from https://stripe.com/docs/stripe-cli)
- Your Stripe secret key is stored in `.env` or set as a Firebase secret
- Your Flutter app is set up to call local `createCheckoutSession` function in `kDebugMode`

---

## 🧪 Step 1: Create Checkout Session Locally

Ensure your Flutter app hits this URL in debug mode:

```
http://localhost:8081/my-right-portal/us-central1/createCheckoutSession
```

Switch between local and production:

```dart
final checkoutUrl = kDebugMode
  ? 'http://localhost:8081/my-right-portal/us-central1/createCheckoutSession'
  : 'https://us-central1-my-right-portal.cloudfunctions.net/createCheckoutSession';
```

---

## 💳 Step 2: Use a Stripe Test Card

In the Stripe-hosted Checkout page, use:

```
Card: 4242 4242 4242 4242
Exp: Any future date
CVC: 123
ZIP: 12345
```

This simulates a successful payment in test mode.

---

## 📡 Step 3: Simulate Webhook Events

Run the Stripe CLI in a separate terminal:

```bash
stripe listen --forward-to localhost:8081/my-right-portal/us-central1/handleStripeWebhook
stripe listen --forward-to http://127.0.0.1:8081/my-right-portal/us-central1/handleStripeWebhook
```

You’ll get a webhook signing secret like:

```
whsec_123abc...
```

Put this in your `.env` file or set it with:

```bash
firebase functions:secrets:set STRIPE_WEBHOOK_SECRET
```

---

## 🔁 Step 4: Trigger Test Webhook

To manually test your webhook logic:

```bash
stripe trigger checkout.session.completed
```

This sends a fake `checkout.session.completed` event to your local `handleStripeWebhook`.

---

## 🧠 What the Pros Usually Do

| Technique                      | Purpose                          |
|-------------------------------|----------------------------------|
| ✅ Use `stripe listen`         | Emulate webhook traffic locally  |
| ✅ Use test card numbers       | No real payment made             |
| ✅ Toggle function URLs        | Avoid hitting production by accident |
| ✅ Log data in webhooks        | Debug locally with print/logs    |
| ✅ Use `.env` or secrets       | Secure the webhook secret        |

---

## ✅ Summary

You now have a complete Stripe test setup using:

- Firebase Functions V2 (local)
- Flutter app in debug mode
- Stripe test mode
- Stripe CLI for webhook simulation

Perfect for safe and fast development!
