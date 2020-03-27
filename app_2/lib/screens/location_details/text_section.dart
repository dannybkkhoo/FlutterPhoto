import 'package:flutter/material.dart';

class TextSection extends StatelessWidget{
  final String _title,_body;
  static const double _hPad = 10.0;
  TextSection(this._title,this._body);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 10.0,_hPad , 5.0),
          child: Text(_title, style: Theme.of(context).textTheme.title),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 8.0, _hPad, 4.0),
          child: Text(_body, style: Theme.of(context).textTheme.body1),
        ),
      ]
    );
  }
}