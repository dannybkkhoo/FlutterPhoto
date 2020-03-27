import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class FBLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FBLoginState();
  }
}

class _FBLoginState extends State<FBLogin>{
  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginwithFB() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState((){
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout(){
    facebookLogin.logOut();
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(userProfile["picture"]["data"]["url"], height: 50.0, width: 50.0),
                  Text(userProfile["name"]),
                  OutlineButton( child: Text("LogOut"), onPressed: () {
                    _logout();
                  },)
                ],
              )
            : Center(
                child: OutlineButton(
                  child: Text("Login with Facebook"),
                  onPressed: () => _loginwithFB(),
                )
        )
      )
    );
  }
}