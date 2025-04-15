import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show head;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'custom_error.dart';
import 'package:flutter/scheduler.dart';

class UrlLauncherHelper {

  static Future<void> launchWebAppWebsite(String url, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final Uri uri = Uri.parse(url);

    if (!kIsWeb) {
      try {
        final response =
            Uri.base.scheme == 'https' || uri.scheme == 'https'
                ? await http.head(uri).timeout(const Duration(seconds: 2))
                : null;
        if (response != null && response.statusCode != 200) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              CustomError.show(
                context,
                'HTTP ${response.statusCode}: $url',
                userMessage: localizations.error_website_unavailable,
              );
            }
          });
          return;
        }
      } catch (e) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            CustomError.show(
              context,
              e,
              userMessage: localizations.error_website_unavailable,
            );
          }
        });
        return;
      }
    }

    try {
      final launched = await launchUrl(
        uri,
        webOnlyWindowName: kIsWeb ? '_blank' : null,
      );

      if (!launched) {
        throw Exception('Launch failed');
      }
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          CustomError.show(
            context,
            e,
            userMessage: localizations.error_website_unavailable,
          );
        }
      });
    }
  }

  /// Launches a website URL with graceful error handling.
  static Future<void> launchWebsite(String url, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final Uri uri = Uri.parse(url);
    // debugPrint('Attempting to launch URL: $url');

    try {
      final response =
          Uri.base.scheme == 'https' || uri.scheme == 'https'
              ? await http.head(uri)
              : null;
      // if (response != null) {
      //   debugPrint('HEAD request response: ${response.statusCode}');
      // }
      if (response != null && response.statusCode != 200) {
        // debugPrint('HEAD request failed: ${response.statusCode}');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            CustomError.show(
              context,
              'HTTP ${response.statusCode}: $url',
              userMessage: localizations.error_website_unavailable,
            );
          }
        });
        return;
      }
    } catch (e) {
      debugPrint('HEAD request failed: $e');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          CustomError.show(
            context,
            e,
            userMessage: localizations.error_website_unavailable,
          );
        }
      });
      return;
    }

    if (await canLaunchUrl(uri)) {
      // debugPrint('Launching URL: $url');
      try {
        await launchUrl(uri);
      } catch (e) {
        debugPrint('Error launching URL: $e');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            CustomError.show(
              context,
              e,
              userMessage: localizations.error_website_unavailable,
            );
          }
        });
      }
    }
  }

  /// Launches the default email client with a mailto link.
  static Future<void> launchEmail(String email, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    // Validate email format before attempting to launch
    if (!_isValidEmail(email)) {
      CustomError.show(
        context,
        '${localizations.error_email_invalid} $email',
        userMessage: localizations.error_email_invalid,
      );
      return;
    }

    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      try {
        await launchUrl(emailUri);
      } catch (e) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            CustomError.show(
              context,
              e,
              userMessage: localizations.error_website_unavailable,
            );
          }
        });
      }
    }
  }

  /// Validates a basic email address format using RegExp.
  static bool _isValidEmail(String email) {
    try {
      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
      return emailRegex.hasMatch(email);
    } catch (e) {
      debugPrint('Email validation error: $e');
      return false;
    }
  }

  /// Launches the phone dialer with the given phone number.
  static Future<void> launchPhone(
    String phoneNumber,
    BuildContext context,
  ) async {
    final localizations = AppLocalizations.of(context)!;
    debugPrint('Attempting to launch unsanitized phone: $phoneNumber');
    final normalized = _sanitizeUsPhoneNumber(phoneNumber);
    debugPrint('Attempting to launch sanitized phone: $phoneNumber');
    if (normalized == null) {
      CustomError.show(
        context,
        '${localizations.error_phone_number_invalid} $phoneNumber',
        userMessage: localizations.error_phone_number_invalid,
      );
      return;
    }

    final Uri telUri = Uri(scheme: 'tel', path: normalized);
    if (await canLaunchUrl(telUri)) {
      try {
        await launchUrl(telUri);
      } catch (e) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            CustomError.show(
              context,
              e,
              userMessage: localizations.error_website_unavailable,
            );
          }
        });
      }
    }
  }

  /// Normalizes and validates a U.S. phone number.
  static String? _sanitizeUsPhoneNumber(String phoneNumber) {
    try {
      // Strip out non-numeric characters
      final sanitized = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Normalize
      String normalized = sanitized;
      if (sanitized.startsWith('1') && sanitized.length == 11) {
        normalized = '+$sanitized';
      } else if (sanitized.length == 10) {
        normalized = '+1$sanitized';
      }

      // Validate
      final validUsNumberPattern = RegExp(r'^\+1\d{10}$');
      if (!validUsNumberPattern.hasMatch(normalized)) {
        return null;
      }

      return normalized;
    } catch (e) {
      debugPrint('Phone number sanitization error: $e');
      return null;
    }
  }
}
