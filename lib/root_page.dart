import 'sign_in_page.dart';
import 'home_page.dart';
import 'loading_page.dart';
import 'error_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'top_level_providers.dart';

//Using ConsumerWidget instead of Consumer since basically the whole page changes depending on user auth status
class RootPage extends ConsumerWidget {
  RootPage({Key? key}):super(key:key);  //keep track of widget changes for rebuilds

  @override
  Widget build(BuildContext context, ScopedReader watch) {  //ScopedReader is like a function to subscribe/listen to changes
    final authStateChanges = watch(authStateChangesProvider); //listen to user authentication status changes
    return authStateChanges.when(
      data: (user) => user != null? HomePage(): SignInPage(), //if user instance is null, means either unauthenticated/signed out
      loading: () => LoadingPage(),
      error: (_, __) => ErrorPage(),
    );
  }
}

