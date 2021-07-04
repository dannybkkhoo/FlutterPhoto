import 'package:flutter/material.dart';
import 'screen.dart';
import 'strings.dart';
import 'images.dart';

class ErrorPage extends StatelessWidget {
  late String text;
  late String image;
  ErrorPage({this.text = Strings.defaultError, this.image = Images.defaultError}) {Screen().portrait();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context,constraints) {
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(image, width: constraints.maxHeight*0.15, height: constraints.maxHeight*0.15, fit: BoxFit.contain),
                  Container(height: constraints.maxHeight*0.05),
                  Text(this.text, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center,)
                ],
              ),
            );
          }
        ),
      )
    );
  }
}
