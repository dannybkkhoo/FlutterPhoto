import 'package:flutter/material.dart';
import '../services/authprovider.dart';
import '../services/authenticator.dart';
import 'login_page/root_page.dart';
import 'login_page/image_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          title: 'FlutterPhoto',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: RootPage(),
        )
      );
  }
}
