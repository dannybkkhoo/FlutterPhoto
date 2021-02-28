import 'package:flutter/material.dart';
import 'layer_1/root_page.dart';
import '../services/authentication/authenticator.dart';
import '../services/authentication/authprovider.dart';
import '../services/local_storage/dataprovider.dart';

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
