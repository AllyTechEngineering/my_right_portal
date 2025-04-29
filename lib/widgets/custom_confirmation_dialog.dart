// lib/widgets/custom_confirmation_dialog.dart

import 'package:flutter/material.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String cancelLabel,
  required String continueLabel,
  required VoidCallback onConfirmed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog first
              onConfirmed(); // Then call the confirm callback
            },
            child: Text(continueLabel),
          ),
        ],
      );
    },
  );
}