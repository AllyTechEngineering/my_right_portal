import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomError {
  static void show(BuildContext context, Object error, {String? userMessage}) {
    final localizations = AppLocalizations.of(context)!;

    final String message =
        userMessage ?? '${localizations.error_generic}\n$error';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.surface,),
          softWrap: true,
          maxLines: null,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
        ),
        backgroundColor: Theme.of(context).colorScheme.onError,
      ),
    );

    // Optional: Log or send error to remote logging service
    debugPrint('Error: $error');
  }
}
