import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhorizontalscroll/Folder%20layer.dart';
import 'package:intl/intl.dart';
import 'photoview.dart';
import 'dart:ui' as ui;


void main() => runApp(MaterialApp(
  home: PhotoThing()
));
class PhotoPreviewFunction extends StatelessWidget{
  final _imagePath, _datetime ;

  PhotoPreviewFunction(this._imagePath,this._datetime);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400.0,
        height: 300.0,
        child: Card(
            child: Wrap(
              children: <Widget>[
                Container(
                  width: 400.0,
                  height: 400.0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => SimplePhotoViewPage(_imagePath,_datetime)));
                    },
                    child: Image.asset(_imagePath),
                  ),
                ),
                //Image.asset(_imagePath),

                Description(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

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
class Description extends StatelessWidget{
  final _datetime;

  //PhotoPreviewFunctionwithDes();
  Description(this._datetime);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,

      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text('Photo Name:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(

            decoration: new InputDecoration(
                hintText: "Give your photo a name!"
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
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(56, 56), // button width and height

                child: ClipOval(
                  child: Material(
                    color: Colors.red, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: ()async {
                        final action =
                        await Dialogs.yesAbortDialog(context, 'Delete Photo', 'Are you sure to photo?');
                        if (action == DialogAction.yes) {
                          print("Items Deleted");
                        } else {
                          print("NOPE");
                        }
                      }, // button pressed
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
              ),
              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => new MainPageFolder(title: "My Gallery",)));
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.keyboard_return), // icon
                          Text("Back"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),

    );
  }
}
class PhotoThing extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 800,

          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
            ],
          ),
        ),
      ),
    );
  }
}

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: const Text('No',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}