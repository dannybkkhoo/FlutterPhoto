import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sign_in_button.dart';
import 'loading_page.dart';
import 'top_level_providers.dart';
import 'strings.dart';
import 'package:alert_dialog/alert_dialog.dart';

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context,ScopedReader watch) {
    print("rebuild");
    final _firebaseAuth = watch(firebaseAuthProvider);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: _firebaseAuth.isLoading?
            LoadingPage():
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SignInButton(loginMethod:_firebaseAuth.signInWithGoogle,loginLogo:"assets/images/google_logo.png",loginText:"Sign in with Google"),
                SignInButton(loginMethod:_firebaseAuth.signInWithFacebook,loginLogo:"assets/images/facebook_logo.png",loginText:"Sign in with Facebook"),
              ],
            )
        )
      )
    );
  }
}