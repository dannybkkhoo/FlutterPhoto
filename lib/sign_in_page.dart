import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sign_in_button.dart';
import 'auth_provider.dart';

class SignInPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context,ScopedReader watch) {
    final _firebaseAuth = watch(firebaseAuthProvider);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LogInOption(_firebaseAuth.,"assets/images/google_logo.png","Sign in with Google"),
                LogInOption(FacebookButton,"assets/images/facebook_logo.png","Sign in with Facebook"),
              ],
            )
        )
      )
    );
  }
}
