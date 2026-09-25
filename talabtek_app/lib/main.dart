import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/config/app_config.dart';
import 'core/config/firebase_options.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'shared/providers/app_provider.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/cart_provider.dart';
import 'shared/providers/location_provider.dart';
import 'shared/providers/notification_provider.dart';
import 'shared/providers/network_provider.dart';
import 'shared/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await NotificationService.initialize();
  
  // Initialize network provider
  final networkProvider = NetworkProvider();
  await networkProvider.initialize();
  
  runApp(
    EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppConstants.defaultLocale,
      child: const TalabtekApp(),
    ),
  );
}

class TalabtekApp extends StatelessWidget {
  const TalabtekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: networkProvider),
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.splash,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}