import 'package:app2/app_router.dart';

import 'sign_in_page.dart';
import 'home_page.dart';
import 'loading_page.dart';
import '../screens/error_page.dart';
import 'initialization_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/top_level_providers.dart';
import '../providers/connection_provider.dart';
import '../constants/strings.dart';
import '../constants/images.dart';
import '../debug.dart';
import 'collection_page.dart';

/*
This page is the base of the app, on the highest level of the widget tree just
below the providers(riverpod) widget, it allows the user to either access the
homepage or the sign in page depending on the user's auth status, if the user's
firebase account is previously logged in, it will be cached under the app and
thus the user instance is non-null, once the user taps on the sign out button,
the AuthProvider class will sign out the user's firebase account and
automatically set the user instance to null, notifying all depending classes,
including RootPage.
*/
class RootPage extends ConsumerWidget { //Using ConsumerWidget instead of Consumer since basically the whole page changes depending on user auth status
  RootPage({Key? key}):super(key:key);  //keep track of widget changes for rebuilds

  @override
  Widget build(BuildContext context, WidgetRef ref) {    //ScopedReader is like a function to subscribe/listen to changes
    final connStateChanges = ref.watch(connProvider.select((conn) => conn.connectionStatus)); //listen to user device WiFi/Mobile/Internet conenction changes
    final authStateChanges = ref.watch(authStateChangesProvider); //listen to user authentication status changes
    switch(connStateChanges){
      case ConnStatus.connected:{       //If user device has internet connection
        return authStateChanges.when(   //Go to pages depending on user authentication status
          data: (user) => user != null? InitializationPage(): SignInPage(), //if user instance is null, means either unauthenticated/signed out
          loading: () => LoadingPage(),
          error: (_, __) => ErrorPage(), //default error page
        );
      }
      case ConnStatus.notConnected:     //If user device connected or not connected to WiFi/Mobile without internet connection
      case ConnStatus.unknown:          //If connection status not checked yet
      default:{
        return ErrorPage(
          text: Strings.noConnection,
          image: Images.noConnection,
        );
      //return DebugPage();
      }
    }
  }
}