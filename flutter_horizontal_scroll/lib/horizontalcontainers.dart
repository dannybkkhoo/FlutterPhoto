import 'package:flutter/material.dart';
import 'photoview.dart';
class PhotoPreviewFunction extends StatelessWidget{
  final _imagePath, _datetime;
  PhotoPreviewFunction(this._imagePath,this._datetime);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250.0,
        height: 260.0,
        child: Card(
            child: Wrap(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => SimplePhotoViewPage(_imagePath,_datetime)));
                    },
                    child: Image.asset(_imagePath),
                  ),
                ),
                //Image.asset(_imagePath),
                ListTile(
                  title: Text('Description'),
                  subtitle: Text(_datetime, style: TextStyle(fontSize: 10),),
                )

              ],
            )
        )
    );
  }
}