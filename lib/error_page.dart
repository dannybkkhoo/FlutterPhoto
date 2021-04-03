import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Image(image:AssetImage("error_fix.png")),
            Text("Something went wrong, try restarting the app...")
          ],
        )
      )
    );
  }
}
