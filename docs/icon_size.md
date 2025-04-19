
# Responsive Icon Sizing in Flutter

This guide explains how to make your icons responsive across different screen sizes in Flutter, especially useful when targeting multiple iPhone models with various widths.

---

## ✅ Recommended Pattern

Use `MediaQuery` to calculate a base icon size and then clamp it to ensure it stays within a usable range across screen sizes:

```dart
final double screenWidth = MediaQuery.of(context).size.width;
double iconSize = screenWidth * 0.055;
iconSize = iconSize.clamp(18.0, 26.0);
```

---

## 🎯 Why This Works

| Aspect         | Benefit                                               |
|----------------|--------------------------------------------------------|
| `screenWidth * 0.055` | Scales icon proportionally to device width          |
| `.clamp(18.0, 26.0)`  | Prevents icons from becoming too small or too large |

---

## 📦 Usage Example in a Widget

```dart
Icon(
  Icons.location_on,
  size: iconSize,
  color: Colors.white,
),
```

You can apply this `iconSize` to any `Icon` widget inside rows, buttons, or card layouts.

---

## 🧠 Tip for Title Icons

If you're using title or header icons (like `Icons.apartment` in ConsularOfficeCard), scale it up slightly:

```dart
Icon(
  Icons.apartment,
  size: iconSize * 1.5,
  color: Color(0xFF147107),
),
```

---

## 💡 When to Clamp

Clamping is useful to:
- Avoid layout breakage on small phones (like iPhone SE)
- Prevent over-scaling on tablets or large iPhones
- Maintain visual consistency across cards or tiles

---

## ✅ Best Practice Summary

- Calculate icon size with `screenWidth * factor`
- Clamp it to a safe range using `.clamp(min, max)`
- Adjust `factor` for context (e.g. 0.045 for inline, 0.07 for headers)
