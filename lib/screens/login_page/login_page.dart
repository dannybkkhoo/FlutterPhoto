import 'package:flutter/material.dart';
import '../../services/authprovider.dart';
import '../../services/authenticator.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedIn;
  const LoginPage({this.onSignedIn});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void GoogleButton() async {
    final Authenticator auth = AuthProvider.of(context).auth;
    final String uid = await auth.signInWithGoogle();
    uid == null ? print("Failed to log in") : widget.onSignedIn();
  }

  void FacebookButton() async {
    final Authenticator auth = AuthProvider.of(context).auth;
    final String uid = await auth.signInWithFacebook();
    uid == null ? print("Failed to log in") : widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LogInOption(GoogleButton,"assets/images/google_logo.png","Sign in with Google"),
              LogInOption(FacebookButton,"assets/images/facebook_logo.png","Sign in with Facebook"),
            ],
          )
        )
      )
    );
  }
}

class LogInOption extends StatelessWidget {
  Function loginMethod;
  final logoAsset, loginText;
  LogInOption(this.loginMethod,this.logoAsset,this.loginText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 270.0,
      margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
      child: new RaisedButton(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
        color: Colors.white,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(13.0),
            side: BorderSide(color: Colors.white)
        ),
        onPressed: loginMethod,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Image.asset(
              logoAsset, height: 50.0
            ),
            new Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                alignment: Alignment.center,
                child: new Text(
                  loginText,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto-Medium"
                  ),
                )
              )
            ),
          ],
        )
      )
    );
  }
}