
# Regular Expressions Cheat Sheet (RegExp)

Regular expressions (RegExp) are powerful tools for pattern matching in strings. They are used in most programming languages and tools including Dart, JavaScript, Python, etc.

---

## 🔤 Basic Syntax

| Pattern | Description |
|---------|-------------|
| `.`     | Any single character except newline |
| `^`     | Start of string |
| `$`     | End of string |
| `*`     | 0 or more of the preceding token |
| `+`     | 1 or more of the preceding token |
| `?`     | 0 or 1 of the preceding token |
| `|`     | Alternation (logical OR) |
| `()`    | Grouping |
| `[]`    | Character class |
| `\`    | Escape special character |

---

## 📦 Character Classes

| Pattern | Description |
|---------|-------------|
| `[abc]` | Match a, b, or c |
| `[^abc]`| Not a, b, or c |
| `[a-z]` | Any lowercase letter |
| `[A-Z]` | Any uppercase letter |
| `[0-9]` | Any digit |
| `\d`   | Any digit (`[0-9]`) |
| `\D`   | Any non-digit |
| `\w`   | Word character (alphanumeric + underscore) |
| `\W`   | Non-word character |
| `\s`   | Whitespace |
| `\S`   | Non-whitespace |

---

## 🧮 Quantifiers

| Pattern | Description |
|---------|-------------|
| `a*`    | 0 or more a’s |
| `a+`    | 1 or more a’s |
| `a?`    | 0 or 1 a’s |
| `a{3}`  | Exactly 3 a’s |
| `a{3,}` | 3 or more a’s |
| `a{3,6}`| Between 3 and 6 a’s |

---

## 🧠 Assertions

| Pattern | Description |
|---------|-------------|
| `^`     | Start of string |
| `$`     | End of string |
| `\b`   | Word boundary |
| `\B`   | Not a word boundary |
| `(?=...)` | Positive lookahead |
| `(?!...)` | Negative lookahead |

---

## 🛠️ Useful Examples

### ✅ Zip Code Validation (US)
```dart
final zipCodeRegExp = RegExp(r'^\d{5}$');
```

### ✅ Email
```dart
final emailRegExp = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,4}$');
```

### ✅ US Phone Number (basic)
```dart
final phoneRegExp = RegExp(r'^\d{10}$');
```

### ✅ Only Letters (English)
```dart
final lettersRegExp = RegExp(r'^[A-Za-z]+$');
```

### ✅ Password: at least 1 uppercase, 1 lowercase, 1 number, 1 special character
```dart
final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{6,}$');
```

---

## 💡 Dart Usage Example

```dart
final zipCode = '90210';
final isValid = RegExp(r'^\d{5}$').hasMatch(zipCode);
print('Is valid: \$isValid');
```

---

## 📚 Tips

- Always use raw strings (`r''`) in Dart to avoid escaping backslashes.
- Use online tools like [regex101.com](https://regex101.com) for testing.

---

Generated for the My Right Portal Project – Regular Expressions 101 📘
