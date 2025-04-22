import 'package:flutter/material.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
      body: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  localizations.about_title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.about_intro,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.tos_ownership,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.about_mission,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.about_audiences_title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.about_mission,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.about_lawyers,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextWidget(
                  localizations.about_clients,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                CustomTextWidget(
                  localizations.about_business_model,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                CustomTextWidget(
                  localizations.about_technology,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                CustomTextWidget(
                  localizations.about_closing,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                CustomTextWidget(
                  localizations.about_signature,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
