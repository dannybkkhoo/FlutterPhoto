import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/sign_in_page.dart';
import 'screens/home_page.dart';
import 'screens/error_page.dart';
import 'providers/auth_provider.dart';
import 'screens/root_page.dart';
import 'screens/home_test.dart';
import 'debug.dart';

class AppRoutes {
  static const rootPage=  "/";
  static const signInPage = '/sign-in-page';
  static const homePage = '/home-page';
  static const loadingPage = '/loading-page';
  static const splashPage = '/splash-page';
  static const errorPage = '/error-page';
  static const debugPage = '/debug-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Widget screen;

    switch(settings.name){
      case AppRoutes.rootPage:
        screen = RootPage(); break;
      case AppRoutes.signInPage:
        screen = SignInPage(); break;
      case AppRoutes.homePage:
        screen = Home(); break;
      case AppRoutes.debugPage:
        screen = DebugPage(); break;
      default:
        screen = ErrorPage();
    }
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
      fullscreenDialog: true, //true so that on iOS platform, the page switching animation is from bottom to top just like android
    );
  }
}