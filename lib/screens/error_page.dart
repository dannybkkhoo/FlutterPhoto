import 'package:flutter/material.dart';
import '../bloc/screen.dart';
import '../constants/strings.dart';
import '../constants/images.dart';

class ErrorPage extends StatelessWidget {
  late String text;
  late String image;
  ErrorPage({Key? key, this.text = Strings.defaultError, this.image = Images.defaultError}) : super(key:key) {Screen().portrait();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context,constraints) {
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(13.0),child: Image.asset(image, width: constraints.maxHeight*0.15, height: constraints.maxHeight*0.15, fit: BoxFit.contain)),
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
