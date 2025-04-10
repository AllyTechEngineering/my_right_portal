import 'package:flutter/material.dart';

class CustomDecorations {
  static BoxDecoration gradientContainer({required BuildContext context}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.tertiary.withAlpha(255),
          Theme.of(context).colorScheme.tertiary.withAlpha(255),
          Theme.of(context).colorScheme.onTertiary.withAlpha(255),
        ],
        stops: [0.0, 0.1, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface, // Replaces withOpacity
          offset: const Offset(4, 4),
          blurRadius: 3,
        ),
      ],
    );
  }

  static BoxDecoration gradientCenteredContainer({
    required BuildContext context,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.tertiary.withAlpha(175),
          Theme.of(context).colorScheme.tertiary.withAlpha(255),
          Theme.of(context).colorScheme.tertiary.withAlpha(175),
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface, // Replaces withOpacity
          offset: const Offset(4, 4),
          blurRadius: 3,
        ),
      ],
    );
  }

  static BoxDecoration customGradientContainer({
    required BuildContext context,
    required Color color1,
    required Color color2,
    required Color color3,
    required int alpha1,
    required int alpha2,
    required int alpha3,
    required double stop1,
    required double stop2,
    required double stop3,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color1.withAlpha(alpha1),
          color2.withAlpha(alpha2),
          color3.withAlpha(alpha3),
        ],
        stops: [stop1, stop2, stop3],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface, // Replaces withOpacity
          offset: const Offset(4, 4),
          blurRadius: 3,
        ),
      ],
    );
  }

  static BoxDecoration radialGradientContainer({
    required BuildContext context,
  }) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          const Color(0xFFEA9090),
          const Color(0xFFB00303),
        ], // Adjust gradient colors
        center: Alignment.center,
        radius: 0.4, // Adjust spread of gradient
      ),
    );
  }
}
