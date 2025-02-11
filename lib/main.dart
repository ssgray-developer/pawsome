import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pawsome/core/theme/app_themes.dart';
import 'package:pawsome/presentation/auth/bloc/auth_cubit.dart';
import 'package:pawsome/presentation/auth/pages/login.dart';
import 'package:pawsome/presentation/home/pages/home.dart';
import 'package:upgrader/upgrader.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_languages.dart';
import '../firebase_options.dart';
import '../service_locator.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  // await Upgrader.clearSavedSettings();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      path: ASSETS_PATH_LOCALISATIONS,
      supportedLocales: const [ENGLISH_LOCAL, CHINESE_LOCAL],
      startLocale: ENGLISH_LOCAL,
      fallbackLocale: ENGLISH_LOCAL,
      child: Phoenix(
        child: const MyApp(),
      ),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String getCountryCodeFromDevice() {
    Locale currentLocale = WidgetsBinding.instance.platformDispatcher.locale;
    String countryCode = currentLocale.countryCode ?? 'US';
    return countryCode;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>()..listenToAuthChanges(),
        ),
        // BlocProvider(
        //   create: (context) => sl<AppUpdateCubit>()..checkForUpdate(),
        // ),
      ],
      child: MaterialApp(
        // themeMode: themeViewModel.themeMode,
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,

        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Pawsome',
        home: UpgradeAlert(
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          showIgnore: false,
          showLater: false,
          upgrader: Upgrader(
            // debugDisplayAlways: true,
            messages: UpgraderMessages(code: context.locale.languageCode),
            languageCode: context.locale.languageCode,
            countryCode: getCountryCodeFromDevice(),
          ),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthInitial || state is AuthLoading) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              } else if (state is AuthAuthenticated) {
                return const HomeScreen();
              } else if (state is AuthUnauthenticated) {
                return const LoginScreen();
              } else if (state is AuthError) {
                return const LoginScreen();
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
