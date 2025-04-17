# Firebase Functions V2 – Secret Management Guide

This guide explains how to **securely store and use secrets** (like Stripe keys, URLs, etc.) using **Firebase Functions V2**.

---

## 🔐 Step 1: Set Secrets Using the Firebase CLI

Run these commands in your terminal to store secrets in Firebase:

```
firebase functions:secrets:set STRIPE_SECRET_KEY
firebase functions:secrets:set PRICE_ID
firebase functions:secrets:set SUCCESS_URL
firebase functions:secrets:set CANCEL_URL
```

You'll be prompted to **enter the value** for each secret securely.

---

## 🔎 Step 2: Define Secrets in Your Code

In your `index.js` or relevant Firebase Function file:

```js
const { defineSecret } = require("firebase-functions/params");

const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
const PRICE_ID = defineSecret("PRICE_ID");
const SUCCESS_URL = defineSecret("SUCCESS_URL");
const CANCEL_URL = defineSecret("CANCEL_URL");
```

---

## ⚙️ Step 3: Use Secrets in a Firebase V2 Function

Wrap your function definition like this:

```js
const { onRequest } = require("firebase-functions/v2/https");

exports.createCheckoutSession = onRequest(
  {
    secrets: [STRIPE_SECRET_KEY, PRICE_ID, SUCCESS_URL, CANCEL_URL],
  },
  async (req, res) => {
    const stripe = require("stripe")(STRIPE_SECRET_KEY.value());

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      mode: "subscription",
      line_items: [{ price: PRICE_ID.value(), quantity: 1 }],
      success_url: SUCCESS_URL.value(),
      cancel_url: CANCEL_URL.value(),
    });

    res.status(200).json({ sessionId: session.id, url: session.url });
  }
);
```

---

## 🚀 Step 4: Deploy

Deploy with:

```
firebase deploy --only functions
```

Secrets are injected securely at runtime and not exposed in your source code.

---

## 📌 Notes

- Secrets are stored in **Google Secret Manager** under your Firebase project.
- They are encrypted, versioned, and managed per deployment.
- You must explicitly define and include them in `secrets: [ ... ]` for each function that needs access.

