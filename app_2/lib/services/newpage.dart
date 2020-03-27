import 'package:flutter/material.dart';

class notMaterial extends StatelessWidget{
  final _imageID, _imagePath, _date, _time;
  notMaterial(this._imageID,this._imagePath,this._date,this._time);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.asset(_imagePath),
            ListTile(
              title: Text(_date),
              subtitle: Text(_time),
            )
          ],
        )
      )
    );
  }
}