import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebaseAuth = watch(firebaseAuthProvider);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Log Out"),
          onPressed: firebaseAuth.signOut,
        )
      ),
    );
  }
}
