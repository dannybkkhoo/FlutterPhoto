import 'package:flutter/material.dart';

enum ThemeType {
  LightBlue,
  DarkBlue,
  LightPurple,
  DarkPurple,
}

//Note: Flutter code code is 8 hex chars, eg. 0xFF5E94FF
//Note: The first 2 characters after 0x defines the opacity, 0xFF -> full opacity (0-255)
//Note: Find the inverse color here: https://colorinverter.imageonline.co/
class AppTheme {
  static ThemeType defaultTheme = ThemeType.LightBlue;

  final ThemeType type;
  final bool isDark;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color outline;
  final Color inversePrimary;

  late Color background;
  late Color shadow;
  late Color surface;
  late Color inverseSurface;
  late Color surfaceTint;
  late Color surfaceVariant;
  late Color mainTextColor;
  late Color inverseTextColor;

  AppTheme({
    required this.type,
    required this.isDark,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.outline,
    required this.inversePrimary,
  }) {
    background = isDark? Color(0xFF434A54): Color(0xFFE6E9ED);
    shadow = isDark? Color(0xFFF5F7FA): Color(0xFFAAB2BD);    //shadow always brighter/darker than background
    surface = isDark? Colors.black: Colors.white;
    inverseSurface = isDark? Colors.white: Colors.black;
    surfaceTint = isDark? Color(0xFF434A54): Color(0xFFE6E9ED);
    surfaceVariant = shift(this.primary, 0.1);
    mainTextColor = isDark? Colors.white: Colors.black;
    inverseTextColor = isDark? Colors.black : Colors.white;
  }

  factory AppTheme.fromType(ThemeType t) {
    switch(t) {
      case ThemeType.LightBlue:
        return AppTheme(
          type: t,
          isDark: false,
          primary: const Color(0xFF5E94FF),
          secondary: const Color(0xFF7EA9FF),
          tertiary: const Color(0xFF5485E5),
          error: Colors.red,
          outline: const Color(0xFF7EA9FF),
          inversePrimary: const Color(0xFFA16B00),
        );
      case ThemeType.DarkBlue:
        return AppTheme(
          type: t,
          isDark: true,
          primary: const Color(0xFF5E94FF),
          secondary: const Color(0xFF7EA9FF),
          tertiary: const Color(0xFF5485E5),
          error: Colors.red,
          outline: const Color(0xFF7EA9FF),
          inversePrimary: const Color(0xFFA16B00),
        );
      case ThemeType.LightPurple:
        return AppTheme(
          type: t,
          isDark: false,
          primary: const Color(0xFFA071FF),
          secondary: const Color(0xFFB38DFF),
          tertiary: const Color(0xFF9065E5),
          error: Colors.red,
          outline: const Color(0xFFB38DFF),
          inversePrimary: const Color(0xFF5F8E00),
        );
      case ThemeType.DarkPurple:
        return AppTheme(
          type: t,
          isDark: true,
          primary: const Color(0xFFA071FF),
          secondary: const Color(0xFFB38DFF),
          tertiary: const Color(0xFF9065E5),
          error: Colors.red,
          outline: const Color(0xFFB38DFF),
          inversePrimary: const Color(0xFF5F8E00),
        );
      default:
        return AppTheme.fromType(defaultTheme);
    }
  }

  ThemeData toThemeData() {
    // Use the .dark() and .light() constructors to handle the text themes
    TextTheme textTheme;
    if(isDark)
      textTheme = ThemeData.dark().textTheme;
    else
      textTheme = ThemeData.light().textTheme;
    // textTheme = textTheme.copyWith(
    //     headline6: TextStyle(color: surface),
    //     bodyText1: TextStyle(color: surface1),
    //     bodyText2: TextStyle(color: surface1),
    //     subtitle1: TextStyle(color: surface2),
    //     subtitle2: TextStyle(color: surface2)
    // );
    var t = ThemeData.from(
      textTheme: textTheme,
      // Use ColorScheme to generate the bulk of the color theme
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: primary,
        secondary: secondary,
        onSecondary: secondary,
        tertiary: tertiary,
        error: error,
        onError: error,
        outline: outline,
        inversePrimary: inversePrimary,
        background: background,
        onBackground: background,
        shadow: shadow,
        surface: surface,
        onSurface: surface,
        inverseSurface: inverseSurface,
        surfaceTint: surfaceTint,
        surfaceVariant: surfaceVariant,
      )
    );
    // Apply additional styling that is missed by ColorScheme
    t.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: inverseSurface,
        selectionHandleColor: Colors.transparent,
        selectionColor: tertiary,
      ),
      highlightColor: shift(primary, .1),
      toggleableActiveColor: primary,
    );
    // All done, return the ThemeData
    return t;
  }

  Color shift(Color c, double amt) {
    amt *= (isDark ? -1 : 1);
    var hslc = HSLColor.fromColor(c); // Convert to HSL
    double lightness = (hslc.lightness + amt).clamp(0, 1.0) as double; // Add/Remove lightness
    return hslc.withLightness(lightness).toColor(); // Convert back to Color
  }
}