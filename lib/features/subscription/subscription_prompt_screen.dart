import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';
import '../../../utils/url_launcher_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DeviceType { mobile, tablet, desktop }

class SubscriptionPromptScreen extends StatefulWidget {
  const SubscriptionPromptScreen({super.key});

  @override
  State<SubscriptionPromptScreen> createState() =>
      _SubscriptionPromptScreenState();
}

class _SubscriptionPromptScreenState extends State<SubscriptionPromptScreen> {
  bool _isProcessing = false;

  String getStripeCheckoutUrl() {
    if (kDebugMode) {
      return 'http://localhost:8081/my-right-portal/us-central1/createCheckoutSession';
    } else {
      return 'https://createcheckoutsession-nzgeau3iuq-uc.a.run.app';
    }
  }

  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenHeight = MediaQuery.of(context).size.height;
    final getToolBarHeight = screenHeight * Constants.kToolbarHeight;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/mrts_wagons_2.png',
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final deviceType = _getDeviceType(constraints.maxWidth);
                final screenWidth = constraints.maxWidth;
                final horizontalPadding =
                    deviceType == DeviceType.mobile ? 16.0 : 32.0;
                final padding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: screenHeight * 0.04,
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withAlpha(100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextWidget(
                              localizations.cta_title_subscription,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize:
                                    deviceType == DeviceType.mobile
                                        ? 20
                                        : deviceType == DeviceType.tablet
                                        ? 24
                                        : 28,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.08,
                                right: screenWidth * 0.05,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    localizations.cta_roi_high_value,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize:
                                          deviceType == DeviceType.mobile
                                              ? 16
                                              : deviceType == DeviceType.tablet
                                              ? 18
                                              : 20,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  CustomTextWidget(
                                    localizations.cta_emotional_help_families,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize:
                                          deviceType == DeviceType.mobile
                                              ? 16
                                              : deviceType == DeviceType.tablet
                                              ? 18
                                              : 20,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  CustomTextWidget(
                                    localizations.cta_daily_clients_ready,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize:
                                          deviceType == DeviceType.mobile
                                              ? 16
                                              : deviceType == DeviceType.tablet
                                              ? 18
                                              : 20,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  CustomTextWidget(
                                    localizations.cta_visible_when_needed,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize:
                                          deviceType == DeviceType.mobile
                                              ? 16
                                              : deviceType == DeviceType.tablet
                                              ? 18
                                              : 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextWidget(
                              localizations.cta_message,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize:
                                    deviceType == DeviceType.mobile
                                        ? 18
                                        : deviceType == DeviceType.tablet
                                        ? 20
                                        : 26,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            FractionallySizedBox(
                              widthFactor:
                                  deviceType == DeviceType.mobile
                                      ? 0.9
                                      : deviceType == DeviceType.tablet
                                      ? 0.6
                                      : 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 3.0,
                                  shadowColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryFixedVariant,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    side: BorderSide.none,
                                  ),
                                ),
                                onPressed:
                                    _isProcessing
                                        ? null
                                        : () async {
                                          setState(() {
                                            _isProcessing = true;
                                          });
                                          final currentContext = context;
                                          final email = user?.email;
                                          final uid = user?.uid;
                                          // debugPrint('Email: $email');
                                          // debugPrint('UID: $uid');
                                          try {
                                            final response = await http.post(
                                              Uri.parse(getStripeCheckoutUrl()),
                                              headers: {
                                                "Content-Type":
                                                    "application/json",
                                              },
                                              body: json.encode({
                                                "email": email,
                                                "client_reference_id": uid,
                                              }),
                                            );

                                            if (!currentContext.mounted) return;

                                            if (response.statusCode == 200) {
                                              final data = jsonDecode(
                                                response.body,
                                              );
                                              final checkoutUrl = data['url'];
                                              UrlLauncherHelper.launchWebAppWebsite(
                                                    checkoutUrl,
                                                    currentContext,
                                                  )
                                                  .then((_) {
                                                    if (currentContext
                                                        .mounted) {
                                                      Navigator.pop(
                                                        currentContext,
                                                      );
                                                    }
                                                  })
                                                  .catchError((error) {
                                                    debugPrint(
                                                      "❌ Failed to launch checkout URL: $error",
                                                    );
                                                    if (currentContext
                                                        .mounted) {
                                                      ScaffoldMessenger.of(
                                                        currentContext,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            localizations
                                                                .cta_stripe_error_msg,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  });
                                            } else {
                                              ScaffoldMessenger.of(
                                                currentContext,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${localizations.cta_stripe_session_error_msg_one} ${response.body}, ${localizations.cta_stripe_session_error_msg_two} ${response.statusCode}',
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (!currentContext.mounted) return;
                                            ScaffoldMessenger.of(
                                              currentContext,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Stripe error: $e',
                                                ),
                                              ),
                                            );
                                          } finally {
                                            setState(() {
                                              _isProcessing = false;
                                            });
                                          }
                                        },
                                child:
                                    _isProcessing
                                        ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                        : Text(
                                          localizations.cta_subscribe_now,
                                          style: TextStyle(
                                            fontSize:
                                                deviceType == DeviceType.mobile
                                                    ? 16
                                                    : deviceType ==
                                                        DeviceType.tablet
                                                    ? 18
                                                    : 20,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                          ),
                                        ),
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              height: screenHeight * .50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
