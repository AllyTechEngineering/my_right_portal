import 'package:flutter/material.dart';
import 'package:my_right_portal/widgets/language_toggle_button_widget.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double getToolBarHeight;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    required this.getToolBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize = (screenWidth * 0.06).clamp(50.0, 60.0);

    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: getToolBarHeight,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(size: iconSize),
      title: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: null,
        overflow: TextOverflow.visible,
      ),
      actions: const [LanguageToggleButton()],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blue_sky_background_app_bar.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(getToolBarHeight);
}