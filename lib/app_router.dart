import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_page.dart';
import 'home_page.dart';
import 'error_page.dart';
import 'auth_provider.dart';

class AppRoutes {
  static const signInPage = '/sign-in-page';
  static const homePage = '/home-page';
  static const loadingPage = '/loading-page';
  static const splashPage = '/splash-page';
  static const errorPage = '/error-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings, AuthProvider firebaseAuth) {
    final args = settings.arguments;
    Widget screen;

    switch(settings.name){
      case AppRoutes.signInPage:
        screen = SignInPage(); break;
      case AppRoutes.homePage:
        screen = HomePage(); break;
      default:
        screen =  ErrorPage();
    }
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
      fullscreenDialog: true, //true so that on iOS platform, the page switching animation is from bottom to top just like android
    );
  }
}