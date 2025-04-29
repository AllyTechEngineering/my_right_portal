import 'package:flutter/material.dart';
import 'package:my_right_portal/utils/button_styles.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';

enum DeviceType { mobile, tablet, desktop }

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
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
    final padding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextWidget(
                localizations.subscription_thank,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize:
                      deviceType == DeviceType.mobile
                          ? 20
                          : deviceType == DeviceType.tablet
                          ? 24
                          : 28,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextWidget(
                localizations.subscription_thank_message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize:
                      deviceType == DeviceType.mobile
                          ? 20
                          : deviceType == DeviceType.tablet
                          ? 24
                          : 28,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.assignment,
                  size: iconSize,
                  color: Colors.white,
                ),
                label: Text(
                  localizations.subscription_data_entry,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize:
                        deviceType == DeviceType.mobile
                            ? 18
                            : deviceType == DeviceType.tablet
                            ? 20
                            : 22,
                  ),
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacementNamed('/data-form');
                  });
                },
                style: ButtonStyles.primaryElevatedButtonStyle(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
