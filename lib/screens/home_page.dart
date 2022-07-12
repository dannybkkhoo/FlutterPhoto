import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/top_level_providers.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final String? uid = firebaseAuth.uid;
    Future<bool> _willPopCallBack() async {
      return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          content: Text("Sign out and return to login page?"),
          actions: <Widget>[
            ElevatedButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                }
            ),
            ElevatedButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }
            ),
          ]
        )
      )??false; //if showDialog dismissed/"No" pressed, return false, else true
    }
    return WillPopScope(
      onWillPop: _willPopCallBack,
      child: Scaffold(
        body: Column(
          children:[
            Center(
              child: ElevatedButton(
                child: Text("Log Out"),
                onPressed: firebaseAuth.signOut,
              ),
            ),
          ]
        ),
      ),
    );
  }
}
