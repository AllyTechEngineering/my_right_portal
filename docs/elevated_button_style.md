# ElevatedButton Style Cheat Sheet (Flutter)

This cheat sheet shows common customizations for `ElevatedButton.styleFrom` in Flutter.

---

## 🎨 Color Styling

```dart
ElevatedButton.styleFrom(
  foregroundColor: Colors.white,        // Text/icon color
  backgroundColor: Colors.indigo,       // Button fill color
  disabledForegroundColor: Colors.grey,
  disabledBackgroundColor: Colors.black12,
  shadowColor: Colors.black87,
  surfaceTintColor: Colors.indigoAccent,
  overlayColor: Colors.indigo.shade200,
)
```

---

## 📐 Size and Padding

```dart
ElevatedButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  minimumSize: Size(88, 48),
  fixedSize: Size(150, 50),
  maximumSize: Size.infinite,
  elevation: 4.0,
)
```

---

## 📦 Shape and Border

```dart
ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  side: BorderSide(color: Colors.white70),
)
```

---

## 🖱️ Cursor and Tap Behavior

```dart
ElevatedButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.padded,
  enableFeedback: true,
  visualDensity: VisualDensity.standard,
)
```

---

## 🛠️ Example Usage

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Get Started'),
)
```

---

## 📚 Resources

- [ElevatedButton.styleFrom docs](https://api.flutter.dev/flutter/material/ElevatedButton/ElevatedButton.styleFrom.html)
