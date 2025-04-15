# Firebase Functions CLI Reference Guide

This guide covers the most common Firebase CLI commands for managing Cloud Functions, including configuration, deployment, testing, and logs.

---

## 🔧 1. Set Environment Config Values

Used to store sensitive or dynamic values like API keys, Stripe secrets, etc.

### Syntax:
```bash
firebase functions:config:set namespace.key="value"
```

### Example:
```bash
firebase functions:config:set stripe.secret="sk_test_123" stripe.price_id="price_456"
```

---

## 📥 2. Get Current Config Values

### Syntax:
```bash
firebase functions:config:get
```

### Example Output:
```json
{
  "stripe": {
    "secret": "sk_test_123",
    "price_id": "price_456",
    "success_url": "https://example.com/#/success",
    "cancel_url": "https://example.com/#/cancel"
  }
}
```

---

## ❌ 3. Unset/Delete Config Values

### Syntax:
```bash
firebase functions:config:unset namespace.key
```

### Example:
```bash
firebase functions:config:unset stripe.success_url stripe.cancel_url
```

---

## 🚀 4. Deploy Functions

Deploy all functions:
```bash
firebase deploy --only functions
```

Deploy a specific function:
```bash
firebase deploy --only functions:functionName
```

---

## 🧪 5. Emulate Functions Locally

Run locally with local `.env` and HTTPS:
```bash
firebase emulators:start
```

---

## 📜 6. View Logs

### Syntax:
```bash
firebase functions:log
```

### Options:
```bash
firebase functions:log --only functionName
```

---

## ✅ 7. Test HTTP Function with curl

```bash
curl -X POST https://us-central1-YOUR_PROJECT.cloudfunctions.net/yourFunction
```

---

## 🔍 8. Check Function URLs After Deploy

After deployment, the CLI will return:

```
Function URL (createCheckoutSession): https://us-central1-your_project.cloudfunctions.net/createCheckoutSession
```

Or for Cloud Run-style endpoints:

```
Function URL (createCheckoutSession(us-central1)): https://createcheckoutsession-xxxx-uc.a.run.app
```

---

## 🧼 9. Clean Up Functions Config (Optional)

Reset all config:
```bash
firebase functions:config:unset stripe
```

⚠️ This removes **all keys** under `stripe`.

---

## 🧠 Notes

- Config values set with `functions:config:set` are only available in **production deployments**.
- For local development, use `.env` + `dotenv` and check `process.env.FUNCTIONS_EMULATOR === "true"` in your code.

---

Created for: RightToStayNow.com – Firebase Function Operations