import 'package:flutter/material.dart';
import 'package:my_right_portal/enums/app_screen.dart';


class CustomBottomNavBar extends StatelessWidget {
  final AppScreen currentScreen;

  const CustomBottomNavBar({super.key, required this.currentScreen});

  void _onItemTapped(BuildContext context, AppScreen screen) {
    if (screen != currentScreen) {
      if (screen == AppScreen.legal) {
        Navigator.pushReplacementNamed(
          context,
          '/viewResources',
          arguments: 'legal',
        );
      } else {
        Navigator.pushReplacementNamed(context, screen.route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // const selectedColor = Color(0xFF475FBE); // green
    // const unselectedColor = Color(0xFF8697D4);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // final sizeBoxHeight = screenHeight * 0.01;
    // final sizedBoxWidth = screenWidth * 0.01;
    return SafeArea(
      top: false,
      child: Container(
        // height: screenHeight * 0.1,
        // width: screenWidth,
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              AppScreen.values
                  .where(
                    (screen) =>
                        screen == AppScreen.home ||
                        screen == AppScreen.addContacts ||
                        screen == AppScreen.rights ||
                        screen == AppScreen.legal ||
                        screen == AppScreen.healthcare,
                  )
                  .map((screen) {
                    final isSelected = screen == currentScreen;
                    return GestureDetector(
                      onTap: () => _onItemTapped(context, screen),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            screen.icon,
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixed,
                            size: isSelected ? 24 : 20,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          SizedBox(
                            width: screenWidth * 0.18,
                            child: Text(
                              screen.label(context),
                              style: TextStyle(
                                fontSize: isSelected ? 12 : 10,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryFixed,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(),
        ),
      ),
    );
  }
}
