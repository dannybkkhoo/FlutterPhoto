import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

//Create instance of firebase authentication (to be used for sign in etc)
//final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseAuthProvider = Provider<AuthProvider>((ref) => AuthProvider(FirebaseAuth.instance));

//Continuously track user authentication status (logged in or not) as stream
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.firebaseAuth.authStateChanges();
};