# 🎨 Flutter ColorScheme Guide

This guide explains how to use `ColorScheme` in Flutter and how it helps you reduce inline colors and improve maintainability — especially in larger commercial apps.

---

## ✅ What is `ColorScheme`?

`ColorScheme` defines a centralized set of **12 core colors** used throughout your UI, aligned with **Material Design 3** principles.

---

## 📚 The 12 `ColorScheme` Roles

| Property         | Usage                                  |
|------------------|----------------------------------------|
| `primary`        | Main brand color (buttons, tabs, etc.) |
| `onPrimary`      | Text/icon on `primary`                 |
| `secondary`      | Accents or support UI elements         |
| `onSecondary`    | Text/icon on `secondary`               |
| `tertiary`       | Optional third branding color          |
| `onTertiary`     | Text/icon on `tertiary`                |
| `background`     | App background                         |
| `onBackground`   | Text/icon on `background`              |
| `surface`        | Cards, sheets, dialogs                 |
| `onSurface`      | Text/icon on `surface`                 |
| `error`          | Errors, alerts                         |
| `onError`        | Text/icon on `error`                   |

---

## 🎯 Why Use `ColorScheme`?

- Centralizes your app’s color logic
- Reduces inline color definitions like `Color(0xFF000000)`
- Supports light/dark mode transitions easily
- Keeps widgets consistent
- Works great with `Theme.of(context).colorScheme`

---

## 🛠 Example Usage

### ✏ Text Styling

**Old way:**
```dart
Text(
  'Hello',
  style: TextStyle(color: Colors.black),
)
```

**Using ColorScheme:**
```dart
Text(
  'Hello',
  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
)
```

---

### 🔘 Button Styling

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  onPressed: () {},
  child: Text('Continue'),
)
```

---

## 🧱 How Commercial Flutter Apps Use `ColorScheme`

1. **Create the color scheme from your brand seed color:**

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Color(0xFF9AA6B2),
  brightness: Brightness.light,
),
```

2. **Customize further with `copyWith`:**

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Color(0xFF9AA6B2),
  brightness: Brightness.light,
).copyWith(
  background: Color(0xFFF8FAFC),
  onBackground: Color(0xFF000000),
),
```

3. **Replace inline color usage throughout your app:**

- `Colors.black` → `colorScheme.onSurface`
- `Colors.white` → `colorScheme.background` or `onPrimary`
- `Custom greys` → `colorScheme.secondary` or `surface`

---

## 💡 Tip

Keep your branding consistent by defining your color scheme once in your `ThemeData`, and reuse it everywhere via `Theme.of(context).colorScheme`.

---

## ✅ Ready to Refactor?

Start replacing inline colors with semantic `colorScheme` values to reduce duplication, support theming, and scale your design system effortlessly.
