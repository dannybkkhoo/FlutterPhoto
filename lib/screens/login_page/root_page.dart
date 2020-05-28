import 'package:flutter/material.dart';
import 'package:app2/services/authprovider.dart';
import 'package:app2/services/authenticator.dart';
import 'package:app2/services/dataprovider.dart';
import 'package:app2/services/userdata.dart';
import 'package:app2/screens/login_page/login_page.dart';
import 'package:app2/screens/login_page/image_page.dart';
import 'package:app2/screens/home_page/folder_page.dart';
import 'package:app2/services/utils.dart';

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
    auth.getUID().then((String userID) {
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

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return WaitingScreen(_signedOut);
        break;
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.SignedIn:
        return DataProvider(
          child: MainPageFolder(
            title: "Folder Page",
            onSignedOut: _signedOut,
          ),
//          child: ImagePage(
//            onSignedOut: _signedOut,
//          )
        );
        break;
      default:
        return ErrorScreen(_signedOut);
    }
  }
}