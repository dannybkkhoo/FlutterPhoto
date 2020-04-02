import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'photoview.dart';
import 'main.dart';
void main() => runApp(MaterialApp(
  home: PhotoThing()
));
class PhotoPreviewFunction extends StatelessWidget{
  final _imagePath, _datetime;
  PhotoPreviewFunction(this._imagePath,this._datetime);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350.0,
        height: 160.0,
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
                Container(
                  width: 400,
                  height: 400,

                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text('Folder Name:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
                          new TextField(

                            decoration: new InputDecoration(
                                hintText: "Give your folder a name!"
                            ),
                          ),
                          new Text('Date: $_datetime', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.justify),
                          new Text('Size:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
                          new Text('Description:', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
                          new TextField(
                            decoration: new InputDecoration(
                                hintText: "What's on your mind?"
                            ),
                          ),
                          SizedBox.fromSize(
                            size: Size(56, 56), // button width and height
                            child: ClipOval(
                              child: Material(
                                color: Colors.red, // button color
                                child: InkWell(
                                  splashColor: Colors.white, // splash color
                                  onTap: () {
                                    Closed();
                                  }//=> print('Delete'), // button pressed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.delete), // icon
                                      Text("Delete"), // text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                ),

                /*(
                  title: Text('Description:',style: TextStyle(fontSize: 20),),
                  subtitle: Text('Date: $_datetime', style: TextStyle(fontSize: 20),),
                )*/

              ],
            )
        )
    );
  }
}