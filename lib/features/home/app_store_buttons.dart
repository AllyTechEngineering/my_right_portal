import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

/*
'dart:js' is deprecated and shouldn't be used. Use dart:js_interop instead.
Try replacing the use of the deprecated member with the replacement.
*/
class AppStoreButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const AppStoreButtons({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextWidget(
          localizations.download_app_message,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StoreButton(
              imageAsset: localizations.app_store_badge_image,
              url: localizations.app_store_url,
              height: screenHeight * 0.06,
            ),
            SizedBox(width: screenWidth * 0.04),
            _StoreButton(
              imageAsset: localizations.play_store_badge_image,
              url: localizations.play_store_url,
              height: screenHeight * 0.06,
            ),
          ],
        ),
      ],
    );
  }
}

class _StoreButton extends StatelessWidget {
  final String imageAsset;
  final String url;
  final double height;

  const _StoreButton({
    required this.imageAsset,
    required this.url,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        if (url.contains('play.google.com')) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 3.0,
                  shadowColor: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  title: CustomTextWidget(
                    localizations.app_coming_soon,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  content: CustomTextWidget(
                    localizations.app_coming_soon_subtitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: CustomTextWidget(
                        localizations.label_close_dialog,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
          );
        } else {
          final uri = Uri.parse(url);
          if (kIsWeb) {
            debugPrint('Launching URL: $url');
            // launchUrl(uri); // Web: opens in new tab
            // launch(url, isNewTab: true); // Web: opens in new tab
            js.context.callMethod('open', [url, '_blank']);
          } else {
            debugPrint('Launching URL: $url');
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            ); // Mobile: opens store app
          }
        }
      },
      child: Image.asset(imageAsset, height: height),
    );
  }

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }
}
