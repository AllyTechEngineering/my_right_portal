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
    super.key,
    required this.initialLabel,
    required this.onPressed,
    this.successLabel = "Success!",
    this.color,
    this.successColor,
    this.height,
    this.width,
  });

  @override
  State<LoadingActionButton> createState() => _LoadingActionButtonState();
}

class _LoadingActionButtonState extends State<LoadingActionButton>
    with SingleTickerProviderStateMixin {
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
        _controller.reverse(); // Bounce back to normal size
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
      _controller.forward(); // Trigger pop animation
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isSuccess = false;
      });
      // Optional: Show error
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor =
        _isSuccess
            ? (widget.successColor ?? Colors.green)
            : (widget.color ?? Theme.of(context).primaryColor);

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: BorderSide.none,
          ),
        ),
        onPressed: (_isLoading || _isSuccess) ? null : _handlePress,
        child:
            _isLoading
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
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.surface,
                    size: 28,
                  ),
                )
                : Text(
                  widget.initialLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
      ),
    );
  }
}
