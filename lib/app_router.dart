import 'package:app2/screens/addfolder_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/sign_in_page.dart';
import 'screens/home_page.dart';
import 'screens/error_page.dart';
import 'providers/auth_provider.dart';
import 'screens/root_page.dart';
import 'screens/collection_page.dart';
import 'screens/folder_page.dart';
import 'debug.dart';

class AppRoutes {
  static const rootPage=  "/";
  static const signInPage = '/sign-in-page';
  static const loadingPage = '/loading-page';
  static const homePage = '/home-page';
  static const collectionsPage = '/collections-page';
  static const addFolderPage = '/add-folder-page';
  static const folderPage = '/folder-page';
  static const addImagePage = '/add-image-page';
  static const splashPage = '/splash-page';
  static const errorPage = '/error-page';
  static const debugPage = '/debug-page';

}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String,String>?;
    Widget screen;

    switch(settings.name){
      case AppRoutes.rootPage:
        screen = RootPage(); break;
      case AppRoutes.signInPage:
        screen = SignInPage(); break;
      case AppRoutes.homePage:
        screen = CollectionPage(); break;
      case AppRoutes.collectionsPage:
        screen = CollectionPage(); break;
      case AppRoutes.addFolderPage:
        screen = AddFolder(); break;
      case AppRoutes.folderPage:
        screen = FolderPage(args?['folderid']??""); break;
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