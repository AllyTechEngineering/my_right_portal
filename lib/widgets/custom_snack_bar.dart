import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final screenHeight = MediaQuery.of(context).size.height;
  final double bottomMargin = screenHeight > 600 ? 100 : 50;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError
          ? Theme.of(context).colorScheme.onError
          : Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: bottomMargin,
        left: 16,
        right: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}