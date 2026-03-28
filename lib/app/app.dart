import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../bindings/initial_binding.dart';
import '../views/splash_screen.dart';
import '../views/webview_screen.dart';
import '../views/no_internet_screen.dart';
import 'app_theme.dart';

class JSRApp extends StatelessWidget {
  const JSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JSR Students Group',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}

abstract class AppRoutes {
  static const splash = '/';
  static const webView = '/webView';
  static const noInternet = '/no-internet';
}

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.webView,
      page: () => const WebViewScreen(),
    ),
    GetPage(
      name: AppRoutes.noInternet,
      page: () => const NoInternetScreen(),
    ),
  ];
}
