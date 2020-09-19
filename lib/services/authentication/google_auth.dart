import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthCredential _googleCredential;

  Future<AuthCredential> signInWithGoogle() async {
    try{
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      _googleCredential = credential;
      print("Google Sign in Success!");
      return credential;
    }
    catch (error){
      print("Google Sign in Failed.");
      print(error);
    }
    return null;
  }

  Future<AuthCredential> getGoogleCredential() async {
    if(_googleCredential == null){
      _googleCredential = await signInWithGoogle();
    }
    return _googleCredential;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    print("Signed Out Google Account.");
  }

  Future<void> disconnectGoogle() async {
    await _googleSignIn.disconnect();
    print("Disconnected Google Account.");
  }
 }