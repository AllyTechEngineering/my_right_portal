# Firebase & Stripe Function Versions and Release Notes

This file documents the current versions, status, and changelog links for the major packages used in your Firebase Functions + Stripe integration as of April 2025.

---

## ✅ Installed SDKs and CLI Tools

| Package | Installed Version | Latest Version | Notes |
|---------|-------------------|----------------|-------|
| Firebase CLI | `14.2.0` | – | Fully supports Functions V2, `defineSecret`, etc. |
| `firebase-admin` | `13.2.0` | See GitHub | Supports Firestore, Auth, and Secret Manager |
| `firebase-functions` | `6.3.2` | See GitHub | Full support for Functions V2 |
| `firebase-functions-test` | `3.4.1` | See GitHub | Used for testing functions |
| `stripe` (Node.js SDK) | `18.0.0` | See GitHub | Used for Checkout Sessions, Subscriptions |
| `eslint` | `8.57.1` | `9.25.0` | No need to upgrade unless you want ESLint 9 features |

---

## 🔗 Release Notes and Changelogs

### Stripe Node.js SDK
- GitHub Releases: https://github.com/stripe/stripe-node/releases
- Stripe API Versions: https://stripe.com/docs/upgrades

### Firebase Functions
- GitHub Releases: https://github.com/firebase/firebase-functions/releases

### Firebase Admin SDK
- GitHub Releases: https://github.com/firebase/firebase-admin-node/releases

### Firebase Functions Test SDK
- GitHub Releases: https://github.com/firebase/firebase-functions-test/releases

### ESLint
- GitHub Releases: https://github.com/eslint/eslint/releases

---

## 🛠️ Recommended Version Management

- Use `npm outdated` to track what's behind
- Use `npm update` for patch/minor updates
- Use `npm install <package>@latest` to upgrade to the newest version (even if it breaks semver range)
- Use `package.json` semver pins for better control (e.g., `~6.3.2` vs `^6.3.2`)

---

## 🧪 Stripe Metadata Reminder

You're now passing `metadata.userId` in `stripe.checkout.sessions.create()`, which is:
- ✅ Required for `customer.subscription.updated`, `invoice.payment_succeeded`, etc.
- ✅ Attached like:
```js
metadata: {
  userId: req.body.client_reference_id
}
```

Always verify it appears in the Stripe Dashboard under Webhook Events → Metadata.

---

Generated on: April 2025
