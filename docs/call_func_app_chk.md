
# Firebase Callable Function with App Check in Flutter

## Overview

This guide provides step-by-step instructions to implement a secure Firebase Callable Function in a Flutter application using Firebase App Check. This setup ensures that only verified instances of your app can access backend resources without requiring user registration or authentication.

---

## Prerequisites

- Flutter SDK installed
- Firebase project set up
- FlutterFire CLI installed
- Firebase CLI installed

---

## Step 1: Set Up Firebase in Your Flutter App

1. **Initialize Firebase in your Flutter project:**

   ```bash
   flutterfire configure
   ```

2. **Add required dependencies to your `pubspec.yaml`:**

   ```yaml
   dependencies:
     firebase_core: ^2.0.0
     firebase_functions: ^4.0.0
     firebase_app_check: ^0.2.1+8
   ```

3. **Initialize Firebase and App Check in `main.dart`:**

   ```dart
   import 'package:flutter/material.dart';
   import 'package:firebase_core/firebase_core.dart';
   import 'package:firebase_app_check/firebase_app_check.dart';
   import 'firebase_options.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     await FirebaseAppCheck.instance.activate(
       androidProvider: AndroidProvider.playIntegrity,
       appleProvider: AppleProvider.deviceCheck,
     );
     runApp(MyApp());
   }
   ```

---

## Step 2: Create a Firebase Callable Function

1. **Set up Firebase Functions in your project directory:**

   ```bash
   firebase init functions
   ```

2. **Implement the Callable Function in `functions/index.js`:**

   ```javascript
   const { onCall } = require("firebase-functions/v2/https");
   const { getFirestore } = require("firebase-admin/firestore");
   const { initializeApp } = require("firebase-admin/app");

   initializeApp();

   exports.getLawyerList = onCall({ enforceAppCheck: true }, async (request) => {
     const db = getFirestore();
     const snapshot = await db.collection("lawyers").get();

     const lawyers = snapshot.docs.map(doc => ({
       id: doc.id,
       ...doc.data()
     }));

     return { lawyers };
   });
   ```

3. **Deploy the function:**

   ```bash
   firebase deploy --only functions
   ```

---

## Step 3: Call the Function from Flutter

1. **Import the necessary package:**

   ```dart
   import 'package:cloud_functions/cloud_functions.dart';
   ```

2. **Invoke the Callable Function:**

   ```dart
   Future<List<Map<String, dynamic>>> fetchLawyerList() async {
     final HttpsCallable callable =
         FirebaseFunctions.instance.httpsCallable('getLawyerList');

     final result = await callable();
     final List lawyers = result.data['lawyers'];

     return lawyers.cast<Map<String, dynamic>>();
   }
   ```

---

## Step 4: Enable App Check in Firebase Console

1. Navigate to the App Check section in your Firebase project.

2. Register your app for App Check:
   - For Android, select **Play Integrity**
   - For iOS, select **Device Check**

3. Enable App Check enforcement for Cloud Functions.

---

## Notes

- **Debugging:** During development, you can use the **Debug Provider** for App Check to test your app without real attestation. Remember to add the debug token to the Firebase Console.
- **Security:** By enforcing App Check, you protect your backend from unauthorized access, ensuring that only your app can invoke the Callable Functions.

---

For more detailed information, refer to the official Firebase documentation:

- [Firebase App Check for Flutter](https://firebase.google.com/docs/app-check/flutter/default-providers)
- [Calling Functions from Your App](https://firebase.google.com/docs/functions/callable)
