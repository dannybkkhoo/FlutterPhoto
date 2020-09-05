import 'package:flutter/material.dart';
import 'login_page/root_page.dart';
import '../services/authenticator.dart';
import '../services/authprovider.dart';
import '../services/dataprovider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return AuthProvider(
        auth: Auth(),
        child: DataProvider(
          child:MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FlutterPhoto',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: RootPage(),
          )
        )
      );
  }
}
