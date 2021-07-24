import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'connection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'theme_provider.dart';
import 'cloud_storage.dart';
/*
Create provider instances here to avoid more imports in the other files
 */

//Create instance of theme, used for the whole app
final themeProvider = ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider());

//Create instance of connectivity, continuously check network/internet connection
final connProvider = ChangeNotifierProvider<ConnProvider>((ref) => ConnProvider());

//Create instance of firebase authentication (to be used for sign in etc)
final firebaseAuthProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(FirebaseAuth.instance));

//Continuously track user authentication status (logged in or not) as stream
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.firebaseAuth.authStateChanges();
});

//cloud storage
final cloudStorageProvider = ChangeNotifierProvider<CloudStorage>((ref) => CloudStorage());
final cloudStorageProvider2 = ChangeNotifierProvider<CloudStorage2>((ref) => CloudStorage2());

