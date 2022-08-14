import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

/*
The FacebookAuth class is used for facebook user account authentication using
facebook's api,the signInWithFacebook method will allow the user to type in
their email and password, and try to authenticate the user, and if it fails, the
method will return a null value, otherwise, a AuthCredential object is returned,
where it can be used for firebase account sign in purposes.

Note: The signOutFacebook method will sign out the user's facebook account from
the phone, where the user will have to sign in again, this does not mean that
the firebase account is also signed out.
*/

// class FacebookAuth {
//   final FacebookLogin _facebookSignIn = FacebookLogin();
//   AuthCredential? _facebookCredential;  //can be null, if use not signed in or does not exist or error
//
//   Future<AuthCredential?> signInWithFacebook() async { //sign in using facebook account through facebook api
//     try{
//       final facebookSignInAccount = await _facebookSignIn.logIn(['email']); //always returns a status instead of null
//       if(facebookSignInAccount.status == FacebookLoginStatus.loggedIn){ //check if logged in or not
//         _facebookCredential = FacebookAuthProvider.credential(
//           facebookSignInAccount.accessToken.token,
//         );
//         print("Facebook Sign in Success!");
//         return _facebookCredential; //returns a non null value
//       }
//     }
//     catch(e){
//       print("Facebook Sign in Failed.");
//       rethrow;  //pass exception to caller
//     }
//     return null;  //if error or sign in fails, will return null
//   }
//
//   Future<void> signOutFacebook() async {   //signs out the user's facebook account on the phone (not firebase)
//     await _facebookSignIn.logOut();
//     print("Signed Out Facebook Account.");
//   }
//
//   Future<AuthCredential?> get credential async {  //if user not logged in, returns null value
//     return _facebookCredential;
//   }
// }

class FacebookAuth {
  final FacebookLogin _facebookSignIn = FacebookLogin();
  AuthCredential? _facebookCredential;  //can be null, if use not signed in or does not exist or error

  Future<AuthCredential?> signInWithFacebook() async { //sign in using facebook account through facebook api
    try{
      final facebookSignInAccount = await _facebookSignIn.logIn(
        permissions: [
          FacebookPermission.email
        ]
      );

      if(facebookSignInAccount.status == FacebookLoginStatus.success) {
        FacebookAccessToken _facebookToken = facebookSignInAccount.accessToken as FacebookAccessToken;
        _facebookCredential = AuthCredential(providerId: _facebookToken.userId, signInMethod: "password", token: int.parse(_facebookToken.token));
        print("Token: ${_facebookToken.token}, Token(i): ${int.parse(_facebookToken.token)}");
        print("Facebook Sign in Success!");
        return _facebookCredential;
      }
    }
    catch(e){
      print("Facebook Sign in Failed.");
      rethrow;  //pass exception to caller
    }
    return null;  //if error or sign in fails, will return null
  }

  Future<void> signOutFacebook() async {   //signs out the user's facebook account on the phone (not firebase)
    await _facebookSignIn.logOut();
    print("Signed Out Facebook Account.");
  }

  Future<AuthCredential?> get credential async {  //if user not logged in, returns null value
    return _facebookCredential;
  }
}