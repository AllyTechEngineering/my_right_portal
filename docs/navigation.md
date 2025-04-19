# Flutter Web App Navigation: Named Routes & Stack Management

This guide focuses **only on Flutter web apps** and explains how to navigate between screens while managing the navigation stack using **named routes**.

---

## ✅ Goal: Navigate to a new screen and destroy (remove) the previous one

Flutter provides several navigation methods to remove or replace routes in the navigation stack. Below are your best options:

---

### 🟡 1. `Navigator.pushReplacementNamed`

Replaces the **current route** with a new one.  
✅ This **destroys the previous screen** (removes it from stack).

```dart
Navigator.pushReplacementNamed(context, '/data-form');
```

**Use case**: After login or Stripe checkout — you don’t want users going “back” to those screens.

---

### 🔴 2. `Navigator.pushNamedAndRemoveUntil`

Replaces current route and **removes ALL previous screens** from the stack.  
✅ This **destroys ALL previous routes** except for a condition you define.

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/data-form',
  (Route<dynamic> route) => false, // removes everything before
);
```

Or keep `/home` as the base route:

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/data-form',
  ModalRoute.withName('/home'),
);
```

---

### 🟢 3. `Navigator.popAndPushNamed`

✅ This pops the **top route** and replaces it with a new one.

```dart
Navigator.popAndPushNamed(context, '/data-form');
```

It’s like calling `pop()` and then `pushNamed()`.

---

## 🔧 Choosing the Right One

| Method                          | Clears Stack | Destroys Previous | Prevents Going Back |
|---------------------------------|--------------|--------------------|----------------------|
| `pushNamed`                     | ❌ No         | ❌ No               | ❌ No                |
| `pushReplacementNamed`          | ⚠️ One        | ✅ Yes              | ✅ Yes               |
| `pushNamedAndRemoveUntil(false)`| ✅ All        | ✅ Yes              | ✅ Yes               |
| `popAndPushNamed`               | ⚠️ One        | ✅ Yes              | ✅ Yes               |

---

## 🧠 Best Practice in Flutter Web

In **Flutter Web**, `pushReplacementNamed` and `pushNamedAndRemoveUntil` also update the **browser’s history**, meaning the back button in the browser will behave correctly.

---

### ✅ Example for a Stripe Success Flow:

After the user completes Stripe checkout and lands on the `/success-subscription` screen, you want to transition to `/data-form` and prevent back navigation:

```dart
Navigator.pushReplacementNamed(context, '/data-form');
```

Or if you want to remove all prior navigation history (e.g., login → checkout → success → data-form):

```dart
Navigator.pushNamedAndRemoveUntil(context, '/data-form', (route) => false);
```

---

## 🧩 Summary

Use these methods to simplify route transitions in your **Flutter web app** while maintaining stack and history behavior:

- ✅ Use `pushReplacementNamed` for most transitions
- ✅ Use `pushNamedAndRemoveUntil` to clear full stack (great for login/checkout flows)
