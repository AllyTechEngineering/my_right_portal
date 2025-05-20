import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js_interop';

@JS('window.open')
external void openWindow(String url, String target);

void openLink(String url) {
  openWindow(url, '_blank');
}

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
    return InkWell(
      onTap: () {
        final uri = Uri.parse(url);
        if (kIsWeb) {
          debugPrint('Launching URL: $url');
          openLink(url);
        } else {
          debugPrint('Launching URL: $url');
          launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          ); // Mobile: opens store app
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
