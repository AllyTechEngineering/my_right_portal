
# Firebase Emulator Suite: Debugging Walkthrough for Flutter Web

This guide explains how to use the Firebase Emulator Suite alongside Flutter Web in debug mode, mirroring the development experience of a mobile simulator.

---

## ✅ Emulator Services Started

When running:

```bash
firebase emulators:start
```

You launched the following local emulators:

| Service         | Port      | Description                          |
|-----------------|-----------|--------------------------------------|
| **Auth**        | `9099`    | Local Firebase Authentication        |
| **Firestore**   | `8082`    | Firestore NoSQL DB                   |
| **Functions**   | `8081`    | Cloud Functions V2 (via Cloud Run)   |
| **Hosting**     | `8080`    | Serves the built Flutter web app     |
| **Storage**     | `9199`    | Firebase Storage emulator            |
| **Emulator UI** | `4000`    | All-in-one dashboard                 |

---

## 🌐 Your App Is Running At

- Local URL: [http://127.0.0.1:8080](http://127.0.0.1:8080)
- This is where your Flutter web app is served from the emulator.

---

## 🔗 Access Emulator UI Dashboard

Open this in a browser to view and manage emulators:

👉 [http://localhost:4000](http://localhost:4000)

---

## 🔥 Firestore Emulator
- Logging to `firestore-debug.log`
- WebSocket used for internal UI updates

---

## ⚙️ Functions Emulator (V2 over HTTP)

These endpoints are running locally:

- `http://127.0.0.1:8081/my-right-portal/us-central1/createCheckoutSession`
- `http://127.0.0.1:8081/my-right-portal/us-central1/createBillingPortalSession`
- `http://127.0.0.1:8081/my-right-portal/us-central1/handleStripeWebhook`

Functions are running via Cloud Run emulator — suitable for Stripe integration.

---

## 🧪 Local Environment Variables

`.env` values are loaded into the Functions emulator for safe, local testing (e.g., Stripe keys).

---

## 🧠 What the Pros Usually Do

### ✅ Debug Workflow

1. Start emulators: `firebase emulators:start`
2. In VS Code: `flutter run -d chrome`
3. Access app at `http://localhost:8080`
4. Use:
   - VS Code Debug Console
   - Chrome DevTools Network tab
   - Firebase Emulator UI
   - Cloud Function logs via `console.log()` or `logger.info()`

### ✅ Create Local Auth Users

You can create test users from:
- Emulator UI: [http://localhost:4000/auth](http://localhost:4000/auth)
- Or in code:

```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: "test@example.com",
  password: "Password123!",
);
```

---

## 📌 Tip

To avoid calls hitting production services, make sure `.useFirestoreEmulator()` and `.useAuthEmulator()` are set in `main.dart` when `kDebugMode` is active.

---

## ✅ Summary

You now have:
- A fully local Firebase backend
- Real-time logging and hot reload
- Full visibility into database, auth, functions, and more

Perfect for developing and testing your Flutter web app securely and privately.
