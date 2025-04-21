# Storing Firebase Auth UID in Firestore

## 🔍 What Is the Firebase Auth UID?

The Firebase Auth UID is a unique identifier automatically assigned to each user when they register with Firebase Authentication. You can access it in your app with:

```dart
FirebaseAuth.instance.currentUser!.uid
```

---

## ✅ Is the Firebase UID Automatically Stored in Firestore?

**No** — Firebase does not store the UID inside the document by default.

When you create a Firestore document like:

```dart
FirebaseFirestore.instance.collection('lawyers').doc(userId).set({...});
```

The UID is used as the **document ID**, but it’s not stored as a field unless you explicitly add it.

---

## ✅ Why Store the UID Inside the Document?

| Use Case                                 | Store UID in Field? |
|------------------------------------------|----------------------|
| Firestore document lookup via `doc(id)`  | ❌ No need           |
| Querying multiple users and filtering    | ✅ Yes               |
| Displaying user ID in UI or logs         | ✅ Yes               |
| Exporting/migrating user data            | ✅ Yes               |

---

## 🛠 How to Store the UID in Registration Logic

After a user signs up, store the UID inside the Firestore document like this:

```dart
UserCredential credential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(email: ..., password: ...);

String userId = credential.user!.uid;

await FirebaseFirestore.instance
    .collection('lawyers')
    .doc(userId)
    .set({
      'id': userId, // ✅ stores the UID as a field
      'email': email,
      'name': name,
      // ... other fields
    });
```

### Optional: Prevent Overwrites

If you're updating an existing document:

```dart
.set({ 'id': userId }, SetOptions(merge: true));
```

---

## 🧠 Summary

- The UID is **not stored automatically**
- You can and should store it during registration
- It's helpful for searching, filtering, and admin tools
- Use `SetOptions(merge: true)` to safely update existing records
