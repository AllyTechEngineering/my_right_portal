import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle primaryElevatedButtonStyle({
    required double screenHeight,
    required double screenWidth,
    required BuildContext context,
  }) {
    return ElevatedButton.styleFrom(
      elevation: 3.0,
      shadowColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant,
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide.none,
      ),
    );
  }
}