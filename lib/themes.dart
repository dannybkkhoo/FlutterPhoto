import 'package:flutter/material.dart';

enum ThemeType {
  Light,
  Dark,
  Purple,
}

class AppTheme {
  static ThemeType defaultTheme = ThemeType.Light;

  final ThemeType type;
  final bool isDark;
  final Color bg1;
  final Color surface1;
  final Color surface2;
  final Color accent1;
  final Color greyWeak;
  final Color grey;
  final Color greyMedium;
  final Color greyStrong;
  final Color focus;

  late Color mainTextColor;
  late Color inverseTextColor;

  AppTheme({
    required this.type,
    required this.bg1,
    required this.surface1,
    required this.surface2,
    required this.accent1,
    required this.greyWeak,
    required this.grey,
    required this.greyMedium,
    required this.greyStrong,
    required this.focus,
    required this.isDark,
  }) {
    mainTextColor = isDark? Colors.white: Colors.black;
    inverseTextColor = isDark? Colors.black : Colors.white;
  }

  factory AppTheme.fromType(ThemeType t) {
    switch(t) {
      case ThemeType.Light:
        return AppTheme(
          isDark: false,
          type: t,
          bg1: const Color(0xFFF3F3F3),
          surface1: Colors.white,
          surface2: const Color(0xFFEBF0F3),
          accent1: const Color(0xFF2962FF),
          greyWeak: const Color(0xFFCCCCCC),
          grey: const Color(0xFF999999),
          greyMedium: const Color(0xFF747474),
          greyStrong: const Color(0xFF333333),
          focus: const Color(0xFF0D47A1),
        );
      case ThemeType.Dark:
        return AppTheme(
          isDark: true,
          type: t,
          bg1: const Color(0xFF303030),
          surface1: Colors.black,
          surface2: const Color(0xFF616161),
          accent1: const Color(0xFF2962FF),
          greyWeak: const Color(0xFFCCCCCC),
          grey: const Color(0xFF999999),
          greyMedium: const Color(0xFF747474),
          greyStrong: const Color(0xFF333333),
          focus: const Color(0xFF0D47A1),
        );
      case ThemeType.Purple:
        return AppTheme(
          isDark: false,
          type: t,
          bg1: const Color(0xFFF3F3F3),
          surface1: Colors.white,
          surface2: const Color(0xFFEBF0F3),
          accent1: const Color(0xFFD500F9),
          greyWeak: const Color(0xFFCCCCCC),
          grey: const Color(0xFF999999),
          greyMedium: const Color(0xFF747474),
          greyStrong: const Color(0xFF333333),
          focus: const Color(0xFF9C27B0),
        );
      default:
        return AppTheme.fromType(defaultTheme);
    }
  }

  ThemeData toThemeData() {
    var t = ThemeData.from(
      // Use the .dark() and .light() constructors to handle the text themes
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      // Use ColorScheme to generate the bulk of the color theme
      colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: accent1,
          primaryVariant: shift(accent1, .1),
          secondary: accent1,
          secondaryVariant: shift(accent1, .1),
          background: bg1,
          surface: surface1,
          onBackground: mainTextColor,
          onSurface: mainTextColor,
          onError: mainTextColor,
          onPrimary: inverseTextColor,
          onSecondary: inverseTextColor,
          error: focus),
    );
    // Apply additional styling that is missed by ColorScheme
    t.copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: surface1,
          selectionHandleColor: Colors.transparent,
          selectionColor: surface1,
        ),
        buttonColor: accent1,
        highlightColor: shift(accent1, .1),
        toggleableActiveColor: accent1);
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