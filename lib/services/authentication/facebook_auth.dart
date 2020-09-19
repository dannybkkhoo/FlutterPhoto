import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class FacebookAuth {
  final _facebookSignIn = FacebookLogin();
  AuthCredential _facebookCredential;
  Map _facebookProfile;

  Future<AuthCredential> signInWithFacebook() async {
    try{
      final facebookSignInAccount = await _facebookSignIn.logInWithReadPermissions(['email']);
      if(facebookSignInAccount.status == FacebookLoginStatus.loggedIn){
        final token = facebookSignInAccount.accessToken.token;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: token,
        );
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        _facebookProfile = profile;
        _facebookCredential = credential;
        print("Facebook Sign in Success!");
        return credential;
      }
      return null;
    }
    catch(error){
      print("Facebook Sign in Failed.");
      print(error);
    }
    return null;
  }

  Future<AuthCredential> getFacebookCredential() async {
    if(_facebookCredential == null) {
      await signInWithFacebook();
    }
    return _facebookCredential;
  }

  Future<Map> getFacebookProfile() async {
    if(_facebookProfile == null){
      await signInWithFacebook();
    }
    return _facebookProfile;
  }

  Future<void> signOutFacebook() async {
    await _facebookSignIn.logOut();
    print("Signed Out Facebook Account.");
  }
}