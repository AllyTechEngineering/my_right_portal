import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/models/drawer_item_model.dart';
import 'package:my_right_portal/utils/custom_decorations.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 20.0);
//'/cancel-subscription': 
//'/success-subscription':

    // Manually defined items that do NOT use arguments
    final List<DrawerItemModel> staticDrawerItems = [
      DrawerItemModel(
        icon: Icons.home,
        title: localizations.drawer_home,
        route: '/home',
      ),
      DrawerItemModel(
        icon: Icons.check,
        title: 'Test Subscription',
       // title: localizations.drawer_legal_help,
        route: '/success-subscription',
      ),
      DrawerItemModel(
        icon: Icons.cancel,
        title: 'Cancel Subscription',
       // title: localizations.drawer_add_contacts,
        route: '/cancel-subscription',
      ),
      DrawerItemModel(
        icon: Icons.visibility,
        title: localizations.drawer_view_contacts,
        route: '/home',
      ),
      DrawerItemModel(
        icon: Icons.favorite_outline,
        title: localizations.healthcare_title,
        route: '/healthcare',
      ),
      DrawerItemModel(
        icon: Icons.language,
        title: localizations.drawer_consulate,
        route: '/home',
      ),
      DrawerItemModel(
        icon: Icons.people,
        title: localizations.community_support_title,
        route: '/home',
      ),
      DrawerItemModel(
        icon: Icons.group_outlined,
        title: localizations.label_about_us,
        route: '/home',
      ),
    ];
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/images/nature_background.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: SafeArea(
          child: ListView.builder(
            itemCount: staticDrawerItems.length,
            itemBuilder: (context, index) {
              final item = staticDrawerItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Container(
                  decoration: CustomDecorations.customGradientContainer(
                    color1: Theme.of(context).colorScheme.primary,
                    color2: Theme.of(context).colorScheme.primary,
                    color3: Theme.of(context).colorScheme.secondary,
                    alpha1: 255,
                    alpha2: 255,
                    alpha3: 255,
                    stop1: 0.0,
                    stop2: 0.2,
                    stop3: 1.0,
                    context: context,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: Theme.of(context).colorScheme.surface,
                      size: iconSize * 1.5,
                    ),
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.surface,
                      size: iconSize * 1.5,
                    ),

                    onTap: () {
                      Navigator.pop(context);

                      final currentRoute =
                          ModalRoute.of(context)?.settings.name;
                      if (currentRoute == item.route) return;

                      if (item.argument != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          item.route,
                          arguments: item.argument,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, item.route);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
