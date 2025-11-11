import 'package:flutter/material.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

class AppTheme {
  // ignore: non_constant_identifier_names
  static ThemeData CustomeLightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundWhite,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundWhite,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      // shape: CircleBorder(side: BorderSide(width: 5, color: AppColors.white)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.hintGray,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayMedium),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.coral),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
      ),
    ),

    primaryColor: AppColors.primary,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white,
      backgroundColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
