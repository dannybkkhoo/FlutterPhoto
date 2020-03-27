import 'package:flutter/material.dart';
import 'firebase_auth.dart';
import 'login_page.dart';
import '../../services/authprovider.dart';
import '../../services/authenticator.dart';
import '../home_page/home_page.dart';

enum AuthStatus {
  notDetermined,
  notSignedIn,
  SignedIn,
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Authenticator auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userID) {
      setState(() {
        authStatus = userID == null ? AuthStatus.notSignedIn : AuthStatus.SignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SignedIn;
    });
  }
  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
  Widget _WaitingScreen() {
    return Scaffold(
      body: Container(
        alignment:  Alignment.center,
        child: CircularProgressIndicator(),
      )
    );
  }
  Widget _ErrorScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text("Application Error..."),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _WaitingScreen();
        break;
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.SignedIn:
        return HomePage(
          onSignedOut: _signedOut,
        );
        break;
      default:
        return _ErrorScreen();
    }
  }
}