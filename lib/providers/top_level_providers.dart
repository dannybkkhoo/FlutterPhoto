import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'connection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'theme_provider.dart';
import '../bloc/cloud_storage.dart';
import 'userdata_provider.dart';
import 'initialization_provider.dart';
import 'pagestatus_provider.dart';
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

//Create instance of user data, need to initialize it to retrieve user data after authentication
final userdataProvider = ChangeNotifierProvider<UserdataProvider>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final String? uid = firebaseAuth.uid;
  return UserdataProvider(uid); //instance based on uid (different uid different instance)
});

//Create instance of CloudStorage, to allow for upload/download tasks and tracking of its progress
final cloudStorageProvider = ChangeNotifierProvider<CloudStorageProvider>((ref) => CloudStorageProvider());

//Create instance of initializer, to perform initialization duties (download images from cloud if not exist in local)
final initializationProvider = ChangeNotifierProvider<InitializationProvider>((ref){
  final cloudprovider = ref.read(cloudStorageProvider);
  final userprovider = ref.read(userdataProvider);
  return InitializationProvider(cloudprovider,userprovider);
});

//Create instance of pagestatus, to track the status of the page when user selects items or searching items
final pagestatusProvider = ChangeNotifierProvider<PagestatusProvider>((ref) => PagestatusProvider());

//