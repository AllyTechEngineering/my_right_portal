
# Stripe Test Mode: Tying the Keys Together in Firebase Functions V2

This guide documents how to set up and link Stripe keys (secret + webhook secret) for test mode usage with Firebase Cloud Functions V2 and your Flutter web app.

---

## ✅ 1. Get Your Stripe Keys (Test Mode)

Log into your Stripe dashboard at [https://dashboard.stripe.com/test/apikeys](https://dashboard.stripe.com/test/apikeys)

### Required keys:
- **Stripe Secret Key (Test):**
  Example: `sk_test_51Hc...`

- **Stripe Webhook Signing Secret (Test):**
  You get this when running `stripe listen` or in your endpoint settings

---

## ✅ 2. Set Secrets in Firebase (CLI)

### Run these commands:

```bash
firebase functions:secrets:set STRIPE_SECRET_KEY
firebase functions:secrets:set STRIPE_WEBHOOK_SECRET
```

You will be prompted to paste in each secret key (test mode).

These secrets are now securely stored in Firebase and available in your local and deployed Functions V2 runtime.

---

## ✅ 3. Use `defineSecret()` in Your Function Code

In your `handle_stripe_webhook.js` (or any other function):

```js
const { defineSecret } = require("firebase-functions/params");

const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
const STRIPE_WEBHOOK_SECRET = defineSecret("STRIPE_WEBHOOK_SECRET");
```

Then declare the secrets in the function config:

```js
exports.handleStripeWebhook = onRequest({
  secrets: [STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET],
  ...
}, async (req, res) => {
  ...
});
```

Use them like so:

```js
const stripe = require("stripe")(STRIPE_SECRET_KEY.value());
const sig = req.headers["stripe-signature"];
const event = stripe.webhooks.constructEvent(req.rawBody, sig, STRIPE_WEBHOOK_SECRET.value());
```

---

## ✅ 4. Stripe Listen (Local Dev)

In a second terminal:

```bash
stripe listen --forward-to localhost:8081/my-right-portal/us-central1/handleStripeWebhook
```

This forwards webhook events to your local function. The CLI will show the signing secret — you only need to copy it once if not already set.

---

## ✅ 5. Verify That It Works

- Trigger a test checkout in your app
- Use a Stripe test card: `4242 4242 4242 4242`
- Look for webhook events in your terminal
- Check Firestore (via emulator or Firebase Console) for subscription updates

---

## 🧠 Tips

| Best Practice | Reason |
|---------------|--------|
| Use CLI to set secrets | Keeps them out of source control |
| Only use test keys in development | Never mix prod/test environments |
| Always verify webhook signature | Prevent spoofed requests |
| Separate deployed vs local testing | Maintain clean debugMode behavior |

---

## ✅ Summary

With your keys securely set and functions properly referencing them, your app can safely simulate full Stripe payment flows in test mode while running locally.
