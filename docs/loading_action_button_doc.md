# LoadingActionButton Widget - Complete Documentation

## Purpose
A reusable Flutter widget that replicates Stripe-style professional UX for buttons that perform an asynchronous action:
- Tap to start action
- Disable button during loading
- Show a spinner during loading
- Show a checkmark with a "pop" animation on success
- Optional navigation or state change afterward

---

## Features
- Initial label (e.g., "Upload Image", "Save Data")
- Loading spinner (white, centered)
- Success animation: Checkmark with scale ("pop") effect
- Customizable button color and success color
- Disable during action (prevent double taps)
- Mounted state safety checks

---

## Widget Code (`loading_action_button.dart`)

```dart
import 'package:flutter/material.dart';

class LoadingActionButton extends StatefulWidget {
  final String initialLabel;
  final Future<void> Function() onPressed;
  final String successLabel;
  final Color? color;
  final Color? successColor;
  final double? height;
  final double? width;

  const LoadingActionButton({
    Key? key,
    required this.initialLabel,
    required this.onPressed,
    this.successLabel = "Success!",
    this.color,
    this.successColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<LoadingActionButton> createState() => _LoadingActionButtonState();
}

class _LoadingActionButtonState extends State<LoadingActionButton> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isSuccess = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
    _scaleAnimation = _controller.drive(Tween(begin: 1.0, end: 1.2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      _controller.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = _isSuccess
        ? (widget.successColor ?? Colors.green)
        : (widget.color ?? Theme.of(context).primaryColor);

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor,
        ),
        onPressed: (_isLoading || _isSuccess) ? null : _handlePress,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : _isSuccess
                ? ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                : Text(
                    widget.initialLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
      ),
    );
  }
}
```

---

## Usage Example

```dart
LoadingActionButton(
  initialLabel: "Upload Image",
  onPressed: () async {
    await _pickAndUploadImage(context);
  },
)
```

---

## Pro UX Tips
- Use short async actions for best UX (under 3-5 seconds).
- Combine with a brief success page or direct navigation after success.
- Optional: Auto-reset the button after success if desired.

---

## Future Enhancements (Optional)
- Auto-reset after delay
- Error message display if failure
- Custom success animations
- Haptic feedback on success