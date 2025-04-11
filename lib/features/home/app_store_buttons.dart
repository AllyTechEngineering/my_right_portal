import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Text(
          localizations.download_app_message,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: screenHeight * 0.01),
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
        if (url.contains('play.google.com')) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Coming Soon!'),
                  content: const Text(
                    'The Android version will be coming soon!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
          );
        } else {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      child: Image.asset(imageAsset, height: height),
    );
  }
}
