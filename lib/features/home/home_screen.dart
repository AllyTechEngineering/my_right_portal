import 'package:flutter/material.dart';
import 'package:my_right_portal/enums/app_screen.dart';
import 'package:my_right_portal/features/home/app_store_buttons.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_bottom_nav_bar.dart';
import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hold the current screen in state.
  AppScreen currentScreen = AppScreen.home;
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                  Text(
                    'Placeholder for Home Screen Content',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Placeholder for more Home Screen Content',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Placeholder for text explaining the features of the apps',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Placeholder for location of the iOS and Android custom banner widgets',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AppStoreButtons(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  Text(
                    'Attorney Login or Register',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
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
                    child: Text(
                      'Attorney login or register',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentScreen: AppScreen.home,
      ),
    );
  }
}
