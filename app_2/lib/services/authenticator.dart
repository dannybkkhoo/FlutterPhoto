import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'google_auth.dart';
import 'facebook_auth.dart';

abstract class Authenticator {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> signInWithGoogle();
  Future<String> signInWithFacebook();
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements Authenticator {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = authResult.user;
    return user?.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = authResult.user;
    return user?.uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    GoogleAuth userGoogleAccount = GoogleAuth();
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(await userGoogleAccount.getGoogleCredential());
    final FirebaseUser user = authResult.user;
    return user?.uid;
  }

  @override
  Future<String> signInWithFacebook() async {
    FacebookAuth userFacebookAccount = FacebookAuth();
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(await userFacebookAccount.getFacebookCredential());
    final FirebaseUser user = authResult.user;
    return user?.uid;
  }

  @override
  Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}