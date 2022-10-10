import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ui_components/sign_in_button.dart';
import '../screens/loading_page.dart';
import '../providers/top_level_providers.dart';
import '../bloc/screen.dart';
import '../constants/strings.dart';
import '../constants/images.dart';

import 'package:alert_dialog/alert_dialog.dart';

class SignInPage extends ConsumerWidget {
  SignInPage({Key? key}) : super(key:key) {Screen().portrait();}

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final _firebaseAuth = ref.watch(firebaseAuthProvider);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
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
            );
          }
        ),
      )
    );
  }
}