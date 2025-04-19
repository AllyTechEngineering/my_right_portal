
# 🌍 ARB (Application Resource Bundle) Usage in Flutter

This document summarizes everything related to `.arb` files in Flutter for localization, based on your recent questions and updates.

---

## ✅ What is an `.arb` File?

`.arb` stands for **Application Resource Bundle**, and it's a JSON-based file format used to define localizable strings and metadata in Flutter apps that use `flutter_localizations` and `intl`.

---

## 🔤 Basic Structure

```json
{
  "app_title": "My App",
  "@app_title": {
    "description": "Title displayed in the app bar"
  }
}
```

Each key-value pair defines a string. The `"@"` entry describes it for translators and tooling.

---

## 🧩 Features of ARB Files

### 1. **Parameterized Strings**

```json
"share_app_msg": "Download it here: {url}",
"@share_app_msg": {
  "description": "Share message with a link to the app store",
  "placeholders": {
    "url": {
      "type": "String"
    }
  }
}
```

Called in Dart:
```dart
localizations.share_app_msg(Constants.kAppStoreUrlEn)
```

---

### 2. **Plurals**

```json
"message_count": "{count, plural, =0{No messages} =1{1 message} other{{count} messages}}",
"@message_count": {
  "placeholders": {
    "count": {
      "type": "int"
    }
  }
}
```

Dart:
```dart
localizations.message_count(3);
```

---

### 3. **Select Statements (e.g. gender, roles)**

```json
"user_greeting": "{gender, select, male{Welcome, sir} female{Welcome, ma’am} other{Welcome}}",
"@user_greeting": {
  "placeholders": {
    "gender": {
      "type": "String"
    }
  }
}
```

---

### 4. **Metadata for Translators**

Each entry can include:
- `description`
- `type` (String, int, double, num)
- `example` (optional)

---

### 5. **Organized Naming Convention**

```json
"login_title": "Sign In",
"login_username_label": "Username",
"login_password_label": "Password"
```

Helps keep strings grouped logically.

---

### 6. **Support for Right-to-Left Languages**

You can add localized Arabic, Hebrew, etc., and Flutter automatically applies RTL layout when those locales are active.

---

### 7. **Localization in Action**

**English (`app_en.arb`)**
```json
"share_app_msg": "Check out the MyRightToStay app. Download it here: {url}",
"@share_app_msg": {
  "description": "Share message with a link to the app store",
  "placeholders": {
    "url": {
      "type": "String"
    }
  }
}
```

**Spanish (`app_es.arb`)**
```json
"share_app_msg": "Consulta la aplicación MyRightToStay. Descárgala aquí: {url}",
"@share_app_msg": {
  "description": "Mensaje para compartir con un enlace a la tienda de aplicaciones",
  "placeholders": {
    "url": {
      "type": "String"
    }
  }
}
```

---

## 🛠 Common Errors & Fixes

- **Mismatch in placeholder types**: All locales must define the same placeholders with matching `"type"` values.
- **Use of invalid types**: Only `String`, `int`, `double`, or `num` are allowed — not `Object`.

---

## 📦 Tools

Use [`intl_utils`](https://pub.dev/packages/intl_utils) for:
- Extracting messages
- Generating Dart localization classes
- Validating placeholder consistency

---

Let me know if you'd like to automate ARB exports or batch-validate multiple files.
