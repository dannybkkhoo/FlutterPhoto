import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhorizontalscroll/Folder%20layer.dart';
import 'package:intl/intl.dart';
import 'photoview.dart';
import 'dart:ui' as ui;


/*void main() => runApp(MaterialApp(
  home: PhotoThing()
));*/
class PhotoPreviewFunction extends StatelessWidget{
  final _imagePath, _datetime, _photoname ;

  PhotoPreviewFunction(this._imagePath,this._datetime, this._photoname);

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

                Description(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),_photoname),

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
class Description extends StatefulWidget{
  final String _datetime, _photoname;
  Description(this._datetime, this._photoname);

  @override
  DescriptionState createState() => new DescriptionState();
}
class DescriptionState extends State<Description>{
  static String _Des = 'No Description';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,

      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text("Photoname: ${widget._photoname}",textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          /*new TextField(

            decoration: new InputDecoration(
                hintText: "Give your photo a name!"
            ),
          ),*/
          new Text('Date: ${widget._datetime}', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.justify),
          new Text('Size:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text('Description: $_Des', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        createAlertDialog(context,"Description").then((onValue) async {
                          if( onValue != null) {
                            setState(() {
                              _Des = onValue;
                            });
                          }

                        });

                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.edit), // icon
                          Text("Edit"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/Page1"));
                        //Navigator.pop(context);
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
  Future<String> createAlertDialog(BuildContext context, title){
    TextEditingController DescriptionCon = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: DescriptionCon ,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
            onPressed: (){
              Navigator.of(context).pop(DescriptionCon.text.toString());

            },
          )
        ],
      );
    });
  }
}
class PhotoThing extends StatelessWidget{
  String photoname;
  PhotoThing(this.photoname);
  @override

  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        title: new Text("Photos"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 800,

          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(), photoname),
              PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),photoname),
              PhotoPreviewFunction("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),photoname),
              PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),photoname),
              PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),photoname),
              PhotoPreviewFunction("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),photoname),
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