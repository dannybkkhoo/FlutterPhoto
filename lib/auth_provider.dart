import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'facebook_auth.dart';
import 'google_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth; //firebase instance must be created and provided to this class
  User? _firebaseUser = null;  //initially null before sign in, may also be null if sign in failed or signed out
  bool isLoading = false;
  dynamic error;

  AuthProvider(this._firebaseAuth);

  FirebaseAuth get firebaseAuth => _firebaseAuth; //returns the firebase instance
  User? get firebaseUser => _firebaseUser;  //may return null if not signed in
  String? get uid => _firebaseUser?.uid;    //may return null if not signed in or already signed out, otherwise returns a string of uid

  //This method is used as a template for any sign in action, where notifyListeners should be called to refresh page
  Future<void> _signIn(Future<UserCredential> Function() signInMethod) async {
    try{
      isLoading = true;
      notifyListeners();
      await signInMethod();  //if sign in fail, will throw exception
      error = null;
    }
    catch (e) {
      error = e;
      rethrow;  //pass exception to caller
    }
    finally {
      isLoading = false;
      notifyListeners();  //notify to redraw page to homepage etc
    }
  }

  //This method only sign out of the user's firebase account
  Future<void> signOut() async {
    try{
      await _firebaseAuth.signOut(); //sign out of firebase account only
    }
    catch (e) {
      error = e;
      rethrow;  //pass exception to caller, to show a pop up dialog
    }
    finally {
      notifyListeners();  //notify to redraw page to sign in page
    }
  }

  Future<UserCredential> _withGoogle() async {
    final GoogleAuth googleAuth = GoogleAuth();
    return _firebaseAuth.signInWithCredential(await googleAuth.signInWithGoogle() as AuthCredential);
  }

  Future<UserCredential> _withFacebook() async {
    final FacebookAuth facebookAuth = FacebookAuth();
    return _firebaseAuth.signInWithCredential(await facebookAuth.signInWithFacebook() as AuthCredential);
  }

  //Sign in with google using google API, once google signed in, create/sign in to firebase using that account
  Future<void> signInWithGoogle() async {
    await _signIn(_withGoogle);
  }

  //Sign in with facebook using facebook API, once facebook signed in, create/sign in to firebase using that account
  Future<void> signInWithFacebook() async {
    await _signIn(_withFacebook);
  }
}