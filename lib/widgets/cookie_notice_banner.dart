// lib/widgets/cookie_notice_banner.dart
import 'package:flutter/material.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CookieNoticeBanner extends StatefulWidget {
  const CookieNoticeBanner({super.key});

  @override
  State<CookieNoticeBanner> createState() => _CookieNoticeBannerState();
}

class _CookieNoticeBannerState extends State<CookieNoticeBanner> {
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final consentGiven = prefs.getBool('cookieConsent') ?? false;
    setState(() => _showBanner = !consentGiven);
  }

  Future<void> _acceptCookies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cookieConsent', true);
    setState(() => _showBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextWidget(
              localizations.cookies_message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            CustomTextWidget(
              localizations.cookies_subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            ElevatedButton(
              onPressed: _acceptCookies,
              style: ElevatedButton.styleFrom(
                elevation: 3.0,
                shadowColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryFixedVariant,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide.none,
                ),
              ),
              child: CustomTextWidget(
                localizations.cookies_accept,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
