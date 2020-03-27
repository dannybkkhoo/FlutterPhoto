import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget{
  final String _assetPath;
  ImageBanner(this._assetPath);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      constraints: BoxConstraints.expand(
        height: 100.0,
        width: 100.0,
      ),
      decoration: BoxDecoration(
        color: Colors.yellow,
      ),
      child: Image.asset(
        _assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}