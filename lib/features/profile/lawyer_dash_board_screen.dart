import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:my_right_portal/utils/button_styles.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/loading_action_button.dart';
import 'package:url_launcher/url_launcher.dart';

enum DeviceType { mobile, tablet, desktop }

class LawyerDashboardScreen extends StatefulWidget {
  const LawyerDashboardScreen({super.key});

  @override
  State<LawyerDashboardScreen> createState() => _LawyerDashboardScreenState();
}

class _LawyerDashboardScreenState extends State<LawyerDashboardScreen> {
  String lawFirmName = '';
  String contactName = '';
  bool subscriptionActive = false;
  bool isLoading = true;

  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('assets/images/mrts_background.png'),
        context,
      );
    });
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc =
        await FirebaseFirestore.instance
            .collection('lawyers')
            .doc(user.uid)
            .get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        lawFirmName = data['companyNameEn'] ?? '';
        contactName = data['contactNameEn'] ?? '';
        subscriptionActive = data['subscriptionActive'] ?? false;
        isLoading = false;
      });
    }
    // debugPrint('Law Firm Name: $lawFirmName');
    // debugPrint('Contact Name: $contactName');
    // debugPrint('Subscription Active: $subscriptionActive');
  }

  Future<void> _launchBillingPortal(BuildContext context) async {
    debugPrint('Launching billing portal...');
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('User: ${user?.uid}');
    if (user == null) return;
    try {
      final response = await http.post(
        Uri.parse(
          'https://us-central1-my-right-portal.cloudfunctions.net/createBillingPortalSession',
        ),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "${user.uid}"}',
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final url = Uri.parse(jsonDecode(response.body)['url']);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.dashboard_billing_portal_error,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.dashboard_general_error(e.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final getToolBarHeight = screenHeight * Constants.kToolbarHeight;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: localizations.legal_help_title,
        getToolBarHeight: getToolBarHeight,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/mrts_background.png',
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final deviceType = _getDeviceType(screenWidth);
                final padding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
                final widthFactor =
                    deviceType == DeviceType.mobile
                        ? 0.8
                        : deviceType == DeviceType.tablet
                        ? 0.7
                        : 0.6;

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: (deviceType == DeviceType.mobile
                                ? screenWidth * 0.8
                                : deviceType == DeviceType.tablet
                                ? screenWidth * 0.7
                                : screenWidth * 0.6)
                            .clamp(0.0, 640.0),
                      ),
                      child: FractionallySizedBox(
                        //widthFactor: widthFactor,
                        widthFactor: widthFactor,
                        child:
                            isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 40),
                                    Text(
                                      '👤 ${localizations.dashboard_title}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 20
                                                : deviceType ==
                                                    DeviceType.tablet
                                                ? 24
                                                : 28,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      localizations.dashboard_law_firm(
                                        lawFirmName,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 18
                                                : deviceType ==
                                                    DeviceType.tablet
                                                ? 20
                                                : 22,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      localizations.dashboard_contact_name(
                                        contactName,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 18
                                                : deviceType ==
                                                    DeviceType.tablet
                                                ? 20
                                                : 22,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      subscriptionActive
                                          ? localizations
                                              .dashboard_subscription_active
                                          : localizations
                                              .dashboard_subscription_inactive,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 18
                                                : deviceType ==
                                                    DeviceType.tablet
                                                ? 20
                                                : 22,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      style:
                                          ButtonStyles.primaryElevatedButtonStyle(
                                            screenHeight: screenHeight,
                                            screenWidth: screenWidth,
                                            context: context,
                                          ),
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/data-form',
                                          (route) => false,
                                        );
                                      },
                                      child: SizedBox(
                                        width: screenWidth * 0.8,
                                        child: Text(
                                          localizations.dashboard_manage_data,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge?.copyWith(
                                            fontSize:
                                                deviceType == DeviceType.mobile
                                                    ? 18
                                                    : deviceType ==
                                                        DeviceType.tablet
                                                    ? 20
                                                    : 22,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    LoadingActionButton(
                                      initialLabel:
                                          localizations
                                              .dashboard_manage_billing,
                                      onPressed:
                                          () => _launchBillingPortal(context),
                                      color: Theme.of(context).primaryColor,
                                      successColor: Colors.green,
                                      height: 50,
                                      width: screenWidth * 0.8,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      style:
                                          ButtonStyles.primaryElevatedButtonStyle(
                                            screenHeight: screenHeight,
                                            screenWidth: screenWidth,
                                            context: context,
                                          ),
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/home',
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        localizations.dashboard_log_out,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.copyWith(
                                          fontSize:
                                              deviceType == DeviceType.mobile
                                                  ? 18
                                                  : deviceType ==
                                                      DeviceType.tablet
                                                  ? 20
                                                  : 22,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                      height: screenHeight * .5,
                                    ),
                                  ],
                                ),
                      ),
                    ),
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
