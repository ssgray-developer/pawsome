import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_styles.dart';
import 'app_values.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.secondary,
    scaffoldBackgroundColor: Colors.white.withAlpha(400),
    colorScheme: ColorScheme.dark(
      secondaryContainer: Colors.grey[900],
    ),
    // appBarTheme: AppBarTheme(
    //   shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
    //   iconTheme: const IconThemeData(color: Colors.white),
    //   titleTextStyle: const TextStyle(
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white,
    //     fontSize: FontSize.s18,
    //   ),
    //   backgroundColor: AppColors.primary,
    //   elevation: 0,
    // ),
    radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => AppColors.primary)),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
      enableFeedback: false,
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle:
            getRegularStyle(color: AppColors.white, fontSize: AppSize.s16),
        backgroundColor: AppColors.primary,
        enableFeedback: false,
        elevation: AppSize.s0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s28),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.primary,
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.secondary,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(
      secondaryContainer: Colors.grey[900],
    ),
    appBarTheme: AppBarTheme(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: FontSize.s18,
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
    ),
    radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => AppColors.primary)),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
      enableFeedback: false,
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle:
            getRegularStyle(color: AppColors.white, fontSize: AppSize.s16),
        backgroundColor: AppColors.primary,
        enableFeedback: false,
        elevation: AppSize.s0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s28),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.primary,
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
  );
}
