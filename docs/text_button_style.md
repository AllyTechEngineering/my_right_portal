# TextButton Style Cheat Sheet (Flutter)

This cheat sheet shows common customizations for `TextButton.styleFrom` in Flutter.

---

## 🎨 Color Styling

```dart
TextButton.styleFrom(
  foregroundColor: Colors.white,      // Text/icon color
  backgroundColor: Colors.blue,       // Button fill color
  disabledForegroundColor: Colors.grey,
  disabledBackgroundColor: Colors.black12,
  overlayColor: Colors.blue.shade100, // Ripple color
  shadowColor: Colors.black54,
)
```

---

## 📐 Size and Padding

```dart
TextButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  minimumSize: Size(88, 48),    // Material default
  fixedSize: Size(120, 50),
  maximumSize: Size.infinite,
)
```

---

## 📦 Shape and Border

```dart
TextButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  side: BorderSide(color: Colors.blueAccent),
)
```

---

## 🖱️ Cursor and Tap Behavior

```dart
TextButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.padded,
  enableFeedback: true,
  visualDensity: VisualDensity.compact,
)
```

---

## 🛠️ Example Usage

```dart
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    padding: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Text('Submit'),
)
```

---

## 📚 Resources

- [TextButton.styleFrom docs](https://api.flutter.dev/flutter/material/TextButton/TextButton.styleFrom.html)
- [ButtonStyle docs](https://api.flutter.dev/flutter/material/ButtonStyle-class.html)
