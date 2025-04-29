import 'package:flutter/material.dart';
import 'package:my_right_portal/utils/button_styles.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DeviceType { mobile, tablet, desktop }

class CancelScreen extends StatefulWidget {
  const CancelScreen({super.key});

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final deviceType = _getDeviceType(screenWidth);
    // final padding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
    // final widthFactor =
    //     deviceType == DeviceType.mobile
    //         ? 0.8
    //         : deviceType == DeviceType.tablet
    //         ? 0.7
    //         : 0.6;
    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      drawer: const CustomDrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red, size: 80),
            SizedBox(height: screenHeight * 0.02),
            Text(
              localizations.cancel_screen,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              localizations.cancel_screen_message,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyles.primaryElevatedButtonStyle(
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize:
                      deviceType == DeviceType.mobile
                          ? 18
                          : deviceType == DeviceType.tablet
                          ? 20
                          : 22,
                  color: Theme.of(context).colorScheme.surface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
