import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
The GoogleAuth class is used for google user account authentication using
google's api,the signInWithGoogle method will allow the user to type in their
gmail and password, and try to authenticate the user, and if it fails, the
method will return a null value, otherwise, a AuthCredential object is returned,
where it can be used for firebase account sign in purposes.

Note: The signOutGoogle method will sign out the user's google account from the
phone, where the user will have to sign in again, this does not mean that the
firebase account is also signed out.
*/
class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthCredential? _googleCredential;  //can be null, if use not signed in or does not exist or error

  Future<AuthCredential?> signInWithGoogle() async {  //sign in using google account through google api
    try{
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();  //if sign in fails, will return null
      if(googleSignInAccount != null){  //if sign in process did not fail
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        _googleCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        print("Google Sign in Success!");
        return _googleCredential;  //returns a non null value
      }
    }
    catch (e){
      print("Google Sign in Failed.");
      rethrow;  //pass exception to caller
    }
    return null;  //if error or sign in fails, will return null
  }

  Future<void> signOutGoogle() async {  //signs out the user's google account on the phone (not firebase)
    await _googleSignIn.signOut();
    print("Signed Out Google Account.");
  }

  Future<AuthCredential?> get credential async {  //if user not logged in, returns null value
    return _googleCredential;
  }
}