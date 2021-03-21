// import 'package:flutter/material.dart';
// import 'authenticator.dart';

// class AuthProvider extends InheritedWidget {
//   final Authenticator auth;
//   const AuthProvider({Key key, Widget child, this.auth}) : super(key: key, child: child);
//
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) => true;
//
//   static AuthProvider of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }
// }

import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'google_auth.dart';
import 'facebook_auth.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  String _uid;
  AuthStatus _status = AuthStatus.Uninitialized;

  AuthProvider.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  AuthStatus get status => _status;
  FirebaseUser get user => _user;
  String get uid => _uid;

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = AuthStatus.Authenticating;
      notifyListeners();
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return authResult.user?.uid; //if uid is null, return null, else return uid value
    } catch (e) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return null; //if sign in return value is null, means failed to authenticate
    }
  }

  Future<String> signInWithGoogle(String email, String password) async {
    try {
      _status = AuthStatus.Authenticating;
      notifyListeners();
      GoogleAuth userGoogleAccount = GoogleAuth();
      AuthResult authResult = await _auth.signInWithCredential(await userGoogleAccount.getGoogleCredential());
      return authResult.user?.uid; //if uid is null, return null, else return uid value
    } catch (e) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return null; //if sign in return value is null, means failed to authenticate
    }
  }

  Future<String> signInWithFacebook(String email, String password) async {
    try {
      _status = AuthStatus.Authenticating;
      notifyListeners();
      FacebookAuth userFacebookAccount = FacebookAuth();
      final AuthResult authResult = await _auth.signInWithCredential(await userFacebookAccount.getFacebookCredential());
      return authResult.user?.uid; //if uid is null, return null, else return uid value
    } catch (e) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return null; //if sign in return value is null, means failed to authenticate
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if(firebaseUser == null) {
      _uid = null;
      _status = AuthStatus.Unauthenticated;
    } else {
      _user = firebaseUser;
      _uid = firebaseUser.uid;
      _status = AuthStatus.Authenticated;
    }
    notifyListeners();
  }
}