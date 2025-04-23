import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

/// Custom Theme for the app
/// Color Palette: https://colorhunt.co/palette/f8fafcd9eafdbcccdc9aa6b2
/// Color(0xFF9AA6B2) -
/// Color(0xFFBBCCCDC) -
/// Color(0xFFD9EAFD) -
/// Color(0xFFF8FAFC) -

class CustomAppTheme {
  static final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.openSans().fontFamily,
    fontFamilyFallback: ['NotoSansSymbols'],
    colorScheme: appColorScheme,
    textTheme: customTextTheme,
    scaffoldBackgroundColor: appColorScheme.tertiaryFixed,
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     padding: EdgeInsets.all(8.0),
    //     backgroundColor: Colors.white70,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8.0),
    //       side: BorderSide(color: Colors.black, width: 1.0),
    //     ),
    //   ),
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // shadowColor: Colors.black,
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.transparent,
        // surfaceTintColor: Color(0xFFF2F7FF),
        elevation: 15.0,
        padding: EdgeInsets.zero,
        // shape: RoundedRectangleBorder(
        //   side: const BorderSide(width: 3.0, style: BorderStyle.solid),
        //   borderRadius: BorderRadius.circular(20.0),
        // ),
      ),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      // backgroundColor: appColorScheme.primary,
      backgroundColor: Colors.transparent,
      foregroundColor: appColorScheme.onPrimary,
      titleTextStyle: customTextTheme.displaySmall,
      toolbarTextStyle: customTextTheme.titleLarge,

      // actionsIconTheme: IconThemeData(
      //   size: Constants.kActionsIconThemeIconSize,
      //   color: appColorScheme.onPrimary,
      // ),
      iconTheme: IconThemeData(
        size: 30.0,
        weight: 900.0,
        fill: 1.0,
        color: appColorScheme.onPrimary,
      ),
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      shadowColor: appColorScheme.onPrimary,
    ),

    // Input Decoration Theme for Text Fields
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      filled: true,
      labelStyle: customTextTheme.titleMedium,
      floatingLabelStyle: customTextTheme.bodyMedium,
      hintStyle: customTextTheme.bodyMedium,
      helperStyle: customTextTheme.bodyMedium,
      errorStyle: customTextTheme.bodyMedium,
      suffixStyle: customTextTheme.bodyMedium,
      prefixStyle: customTextTheme.bodyMedium,
    ),

    // ListTile Theme
    listTileTheme: ListTileThemeData(
      iconColor: appColorScheme.onSurface,
      // textColor: Colors.white,
      titleTextStyle: customTextTheme.titleSmall,
      subtitleTextStyle: customTextTheme.bodySmall,
      // tileColor: Color(0xFF053B50),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      size: Constants.kIconThemeIconSize,
      color: appColorScheme.surface,
    ),

    // Icon Button Theme
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        // foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        iconSize: WidgetStateProperty.all<double>(30.0),
        iconColor: WidgetStateProperty.all<Color>(appColorScheme.onSurface),
        elevation: WidgetStateProperty.all<double>(16.0),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      // backgroundColor: Color(0xFFEEEEEE),
      dayPeriodTextStyle: customTextTheme.bodyMedium,
      hourMinuteTextStyle: customTextTheme.bodyMedium,
      helpTextStyle: customTextTheme.bodyMedium,
      hourMinuteShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        side: BorderSide(width: 2.0),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        side: BorderSide(width: 2.0),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      // backgroundColor: Color(0xFFEEEEEE),
      // rangePickerBackgroundColor: Color(0xFFEEEEEE),
      rangePickerElevation: 4,
      // rangePickerShadowColor: Colors.black,
      elevation: 4,
      // shadowColor: Colors.black,
      dayStyle: customTextTheme.bodySmall,
      weekdayStyle: customTextTheme.bodySmall,
      yearStyle: customTextTheme.bodySmall,
      headerHelpStyle: customTextTheme.bodySmall,
      headerHeadlineStyle: customTextTheme.bodySmall,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 4,
      backgroundColor: Colors.transparent,
      selectedItemColor: Color(0xFF1976D2),
      unselectedItemColor: Color(0xFF79B3ED),
      selectedIconTheme: const IconThemeData(
        size: 30,
        color: Color(0xFF1976D2),
      ),
      unselectedIconTheme: const IconThemeData(
        size: 30,
        color: Color(0xFF79B3ED),
      ),
      selectedLabelStyle: customTextTheme.labelSmall,
      unselectedLabelStyle: customTextTheme.labelSmall,
      type: BottomNavigationBarType.fixed,
    ),
    drawerTheme: DrawerThemeData(
      elevation: 8,
      shadowColor: Colors.black,
      backgroundColor: Color(0xFFFFF8F0),
      surfaceTintColor: appColorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
    ),
    cardTheme: CardTheme(
      // elevation: 4,
      // shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        // side: const BorderSide(width: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    dialogTheme: DialogTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1976D2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  );

  static final customTextTheme = TextTheme(
    // Text Theme
    /*
    Montserrat (titles) + Open Sans (body)
    Poppins (titles) + Lato (body)
    Raleway (titles) + Nunito (body)
    */
    //Headlines for large screens / splash pages
    displayLarge: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
      fontSize: 26.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Page titles or sections
    displayMedium: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Sub-sections or headings
    displaySmall: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // App bar titles, large buttons
    titleLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Dialog titles, card titles
    titleMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Subtitles, section headers
    titleSmall: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    //Paragraphs of readable body text
    bodyLarge: GoogleFonts.lato(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Smaller body text
    bodyMedium: GoogleFonts.lato(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Caption-style body text
    bodySmall: GoogleFonts.lato(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Button text, labels
    labelLarge: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Smaller labels, form hints
    labelMedium: GoogleFonts.lato(
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // Captions, very small labels
    labelSmall: GoogleFonts.lato(
      fontWeight: FontWeight.normal,
      fontSize: 11.0,
      color: appColorScheme.onSurface,
      wordSpacing: 0.0,
      height: 1.2,
    ),
  );
  static final ColorScheme appColorScheme = ColorScheme.fromSeed(
    // https://colorhunt.co/palettes/sea
    // dark blue #27445D
    // green blue #497D74
    // light blue #71BBB2
    // tan #EFE9D5
    seedColor: const Color(0xFF27445D), // dark blue (Primary)
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF27445D), //dark blue
    onPrimary: Colors.white,
    onPrimaryFixed: Color(0xFF6990B1),
    onSecondaryContainer: Color(0xFFDDE5EC),
    primaryContainer: Color(0xFFF4ECF8), // light pink
    onPrimaryFixedVariant: Color(0xFF0C640E),
    secondary: const Color(0xFF497D74), //green blue
    onSecondary: Colors.white,
    surface: Color(0xFFffffff),
    onSurface: Colors.black,
    error: Color(0xFFEA9090),
    onError: Color(0xFFB00303),
    tertiary: const Color(0xFFEFE9D5), //tan
    onTertiary: Color(0xFF71BBB2), //light blue
    tertiaryFixed: Color(0xFFF9F9F9), //Ghost white
    onTertiaryFixed: Color(0xFFEDEAE0), //light blue
  );
}
