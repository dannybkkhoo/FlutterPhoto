import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'connection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
/*
Create provider instances here to avoid more imports in the other files
 */

//Create instance of firebase authentication (to be used for sign in etc)
final firebaseAuthProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(FirebaseAuth.instance));

//Continuously track user authentication status (logged in or not) as stream
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.firebaseAuth.authStateChanges();
});

//Create instance of connectivity, continuously check network/internet connection
final connProvider = ChangeNotifierProvider<ConnProvider>((ref) => ConnProvider());

