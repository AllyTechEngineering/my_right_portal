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
        vertical: 24.0,
        horizontal: 24.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
        side: BorderSide.none,
      ),
    );
  }
}