import 'package:app2/services/dataprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app2/services/userdata.dart';
//import 'package:flutterhorizontalscroll/multiplephoto.dart';
import 'package:intl/intl.dart';
import '../../services/utils.dart';
import '../../services/authprovider.dart';
import 'dart:io';

class HorizontalScrollWithDescription extends StatefulWidget{
  final _folder_id;
  HorizontalScrollWithDescription(this._folder_id);

  @override
  State<StatefulWidget> createState() => new _HorizontalScrollWithDescriptionState();
}

class _HorizontalScrollWithDescriptionState extends State<HorizontalScrollWithDescription>{
  String _name, _description, _link;
  DateTime _date;
  List _children;
  List<Widget> _images;

  void _findFolder(String folder_id){
    UserData user = DataProvider.of(context).userData;
    for(Map folder in user.folders){
      if(folder.containsKey("folder_id")){
        if(folder["folder_id"] == folder_id) {
          _name = folder["name"];
          _date = convertDate(folder["date"]);
          _description = folder["description"];
          _link = folder["link"];
          _children = folder["children"];
        }
      }
    }
  }

  Future<List<Widget>> _generateImagePreview(List children) async {
    final String uid = await AuthProvider.of(context).auth.getUID();
    final String folder_path = await getPath() + "/" + uid + "/" + widget._folder_id;
    print("Generating image previews...");
    List<Widget> showImagePreview = [];
    for(Map image in children){  //create directory on local storage if not exists
      final String file_path = folder_path + "/" + image["image_id"] + ".jpg";
      showImagePreview.add(ImagePreview(file_path));
    }
    print(showImagePreview);
    return showImagePreview;
  }

  @override
  void initState(){
    _findFolder(widget._folder_id);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            child: Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Text("TESTING")
                    ],
                  ),
                ),
//                DescriptionFolder(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(), _folder_id, _folder_id),
              ],
            ),
          ),
        )
    );
  }
}

class ImagePreview extends StatelessWidget{
  final String _imagePath;  //with file extension
  final onTap;
  ImagePreview(this._imagePath,{this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 350.0,
      height: 260.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () => onTap,
                child: Image.file(File(_imagePath)),
              ),
            ),
          ]
        )
      )
    );
  }
}

class DescriptionFolder extends StatefulWidget{
  final String _datetime, _foldername, _link;
  DescriptionFolder(this._datetime, this._foldername, this._link);

  @override
  DescriptionFolderState createState() => new DescriptionFolderState();
}
class DescriptionFolderState extends State<DescriptionFolder>{
  final linkCon = new TextEditingController();
  static String _Des = 'No Description';
  //static String _link = 'No link';
  @override

  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,

      child: new Column(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text('Folder Name: ${widget._foldername}',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),

          new Text('Date: ${widget._datetime}', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.justify),
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
                            var a = DataProvider.of(context).userData.folders;
                            a.forEach((folder){
                              folder['link'] = "a";
                            });
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text('Link: $widget._link', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        createAlertDialog(context, "Link").then((onValue) async {
                          if( onValue != null) {
                            setState(() {
                              //widget._link = onValue;
                              //Navigator.push(context,MaterialPageRoute(builder: (context) => URLPAGE(_link)));
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
          /*new Text('Description:', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(
            decoration: new InputDecoration(
                hintText: "What's on your mind?"
            ),
          ),
          new Text('Link:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(
            controller: linkCon,
            decoration: new InputDecoration(
                hintText: "Put your link here!"
            ),
          ),*/

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        Navigator.pop(context);
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => new MainPageFolder(title: "My Gallery",)));
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
              ),

              /*SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        //_link = linkCon.text;
                        print('$_link');
                        Navigator.push(context,MaterialPageRoute(builder: (context) => URLPAGE(_link)));
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.launch), // icon
                          Text("Link"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              )*/
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