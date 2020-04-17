import 'package:flutter/material.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';

class ThemeUtils {
  // Dark theme of the app
  static ThemeData buildDarkTheme({String language}) {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      accentColor: Colors.tealAccent,
      bottomAppBarTheme: BottomAppBarTheme(
        color: ColorUtils.darkThemeBlueColor,
      ),
    );
  }

  //Dark theme of the app
  static ThemeData buildLightTheme({String language}) {
    final ThemeData base = ThemeData(
      // defines the primary color and the accent color
      primaryColor: ColorUtils.primaryColor,
      accentColor: ColorUtils.primaryColor,
      scaffoldBackgroundColor: Colors.grey[200],
      bottomAppBarTheme: BottomAppBarTheme(
        color: ColorUtils.primaryColor,
      ),
    );
    return base;
  }
}
