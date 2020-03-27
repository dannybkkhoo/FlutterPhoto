import 'package:flutter/material.dart';
import 'auth.dart';
import '../home_page/home_page.dart';
import 'fb_auth.dart';

class Glogin_page extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Login Page'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              SizedBox(
                height: 50.0,
                width: 250.0,
                child: new FlatButton(
                  onPressed: () {
                    signInWithGoogle().whenComplete(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ),
                      );
                    });
                  },
                  child: Text('Login with Gmail',style: TextStyle(fontSize: 25.0)),
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height:50.0,
                width:250.0,
              ),
              FBLogin(),
              SizedBox(
                height: 50.0,
                width: 250.0,
                child: new FlatButton(
                  onPressed: () {
                    print('Hello');
                  },
                  child: Text('Login with Apple ID',style: TextStyle(fontSize: 25.0)),
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: 50.0,
                width: 250.0,
              ),
              SizedBox(
                height:50.0,
                width: 250.0,
                child: new FlatButton(
                  onPressed: () {
                    signOutGoogle();
                  },
                  child: Text('Log out',style: TextStyle(fontSize: 25.0)),
                  color: Colors.grey,
                ),
              )
          ])
      ),
    );
  }
}