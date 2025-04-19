## **Controlling Word Spacing in Flutter's `Text()` Widget**

In Flutter, the **spacing between words** in a `Text()` widget can be adjusted using the `wordSpacing` and `letterSpacing` properties in `TextStyle`.

---

### **✅ Adjusting Word Spacing**
Use the `wordSpacing` property in `TextStyle` to increase or decrease the space between words.

```dart
Text(
  "This is an example text.",
  style: TextStyle(
    fontSize: 18,
    wordSpacing: 8.0, // Adjust the space between words
  ),
)
```
🔹 **Effect:** This increases the space between words by `8.0` logical pixels.

---

### **✅ Adjusting Letter Spacing**
If words are too close due to font settings, adjusting `letterSpacing` can help.

```dart
Text(
  "This is an example text.",
  style: TextStyle(
    fontSize: 18,
    letterSpacing: 2.0, // Adjust space between letters
    wordSpacing: 5.0, // Adjust space between words
  ),
)
```
🔹 **Effect:**  
- `letterSpacing: 2.0` → Spreads out the characters.
- `wordSpacing: 5.0` → Increases space between words.

---

### **🛠 When to Use Which Property?**
- ✅ Use **`wordSpacing`** when words are too close together or you need a **more readable layout**.
- ✅ Use **`letterSpacing`** if a font makes letters too tight or you want a more **aesthetic look**.

---

### **🚀 Now You Can Adjust Word Spacing Easily!**
Would you like a **dynamic way** to change spacing based on screen size? Let me know! 😊🔥
