import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';
import 'error_page.dart';
import 'strings.dart';
import 'images.dart';

class LoadingPage extends StatelessWidget {
  String? _text;
  LoadingPage([this._text]);

  @override
  Widget build(BuildContext context) {
    if(_text == null) {
      return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
      );
    }
    else {
      return Scaffold(
        body: Container(
          color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: CircularProgressIndicator(),
                )
              ),
              Text(
                  _text!,
                  style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        )
      );
    }
  }
}
