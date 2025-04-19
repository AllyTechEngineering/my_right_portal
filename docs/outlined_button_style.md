# OutlinedButton Style Cheat Sheet (Flutter)

This cheat sheet shows common customizations for `OutlinedButton.styleFrom` in Flutter.

---

## 🎨 Color Styling

```dart
OutlinedButton.styleFrom(
  foregroundColor: Colors.black,         // Text/icon color
  backgroundColor: Colors.white,         // Optional background
  disabledForegroundColor: Colors.grey,
  overlayColor: Colors.black12,
  shadowColor: Colors.black38,
  side: BorderSide(color: Colors.blue, width: 1),
)
```

---

## 📐 Size and Padding

```dart
OutlinedButton.styleFrom(
  padding: EdgeInsets.all(12),
  minimumSize: Size(88, 48),
  fixedSize: Size(140, 48),
)
```

---

## 📦 Shape and Border

```dart
OutlinedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
)
```

---

## 🖱️ Cursor and Tap Behavior

```dart
OutlinedButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: VisualDensity.compact,
  enableFeedback: true,
)
```

---

## 🛠️ Example Usage

```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.blue,
    side: BorderSide(color: Colors.blueAccent),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('Learn More'),
)
```

---

## 📚 Resources

- [OutlinedButton.styleFrom docs](https://api.flutter.dev/flutter/material/OutlinedButton/OutlinedButton.styleFrom.html)
