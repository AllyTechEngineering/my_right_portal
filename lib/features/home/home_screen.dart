import 'package:flutter/material.dart';
import 'package:my_right_portal/enums/app_screen.dart';
import 'package:my_right_portal/features/home/app_store_buttons.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/cookie_notice_banner.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
// import 'package:my_right_portal/widgets/custom_bottom_nav_bar.dart';
import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum DeviceType { mobile, tablet, desktop }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppScreen currentScreen = AppScreen.home;
  String? getVersion;
  String? getBuildNumber;
  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      getVersion = packageInfo.version;
      getBuildNumber = packageInfo.buildNumber;
    });
    debugPrint('Version: $getVersion, Build: $getBuildNumber');
  }

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      drawer: const CustomDrawerWidget(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/mrts_boat.png',
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final deviceType = _getDeviceType(screenWidth);
                // ignore: unused_local_variable
                final padding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
                // ignore: unused_local_variable
                final widthFactor =
                    deviceType == DeviceType.mobile
                        ? 0.9
                        : deviceType == DeviceType.tablet
                        ? 0.7
                        : 0.6;
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.8,
                            child: CustomTextWidget(
                              localizations.website,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          //mrts_home_screen_title
                          SizedBox(
                            width: screenWidth * 0.8,
                            child: CustomTextWidget(
                              localizations.kyr_home_screen_title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: screenWidth * 0.8,
                            child: CustomTextWidget(
                              localizations.mrts_home_screen_title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AppStoreButtons(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: screenWidth * 0.8,
                            child: CustomTextWidget(
                              localizations.attorney_only,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005), //'/login'
                          ElevatedButton(
                            onPressed:
                                () => Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (Route<dynamic> route) =>
                                      false, // removes everything before
                                ),
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
                                horizontal: screenWidth * 0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide.none,
                              ),
                            ),
                            child: CustomTextWidget(
                              localizations.attorney_login_register,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CustomTextWidget(
                            'Version: $getVersion, Build: $getBuildNumber',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const CookieNoticeBanner(),
                          Container(
                            color: Colors.transparent,
                            height: screenHeight * .45,
                          ),
                        ],
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
