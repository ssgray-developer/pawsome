import 'package:flutter/material.dart';
import 'package:pawsome/core/utils/generate_primary_swatch.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_styles.dart';
import 'app_values.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.secondary,
    scaffoldBackgroundColor: Colors.grey[100],
    colorScheme: ColorScheme.light(
      secondaryContainer: Colors.grey[900],
    ),
    // useMaterial3: false,
    // primarySwatch: generatePrimarySwatch(AppColors.primary),
    // colorSchemeSeed: AppColors.primary,
    // inputDecorationTheme:
    //     InputDecorationTheme(filled: false, fillColor: Colors.transparent),
    // colorScheme: ColorScheme.light(
    //   secondaryContainer: Colors.grey[900],
    // ),
    appBarTheme: AppBarTheme(
      surfaceTintColor: AppColors.primary,
      //   shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   titleTextStyle: const TextStyle(
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //     fontSize: FontSize.s18,
    ),
    //   backgroundColor: AppColors.primary,
    //   elevation: 0,
    // ),
    radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => AppColors.primary)),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary, // Button text color (purple)
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grey,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentTextStyle: TextStyle(color: AppColors.white),
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
