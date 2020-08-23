import 'package:app2/services/cloud_storage.dart';
import 'package:app2/services/dataprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app2/services/userdata.dart';
//import 'package:flutterhorizontalscroll/multiplephoto.dart';
import 'package:intl/intl.dart';
import '../../services/utils.dart';
import '../../services/authprovider.dart';
import 'dart:io';

const File_Page= "/Files";

enum DescriptionFolderStatus{
  changed,
  unchanged,
}

class DescriptionFolder extends StatefulWidget{
  final String folder_id;
  DescriptionFolder(this.folder_id);

  @override
  DescriptionFolderState createState() => new DescriptionFolderState();
}
class DescriptionFolderState extends State<DescriptionFolder>{
  final linkCon = new TextEditingController();
  DescriptionFolderStatus status = DescriptionFolderStatus.unchanged;
  String _uid = "";
  String _name = "";
  String _date = "";
  String _link = "No Link";
  String _description = 'No Description';
  List _children = [];

  @override
//  void initState() {
//    super.initState();
//    WidgetsBinding.instance.addPostFrameCallback((_){
//      _onLoad();
//    });
//  }

  Future<Map> onLoad() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    Map folder = await getFolderData(_uid, widget.folder_id, context);
    return folder;
  }

  void _update() async {
    UserData userData;
    Directory oldPath;
    //userData = await DataProvider.of(context).userData.loadLatestUserData(_uid); //find user data from local
    userData = await DataProvider.of(context).userData; //find user data from local
    List folders = userData.folders;
    for(var i=0;i<folders.length;i++) {
      if(folders[i]['folder_id'] == widget.folder_id){
//        oldPath = Directory(await getLocalPath() + "/" + _uid + "/" + folders[i]['name']);
//        await createDirectory(await getLocalPath() + "/" + _uid + "/" + _name);
//        oldPath.renameSync(await getLocalPath() + "/" + _uid + "/" + _name);
        folders[i]['name'] = _name; //replace old folder name with updated one
        folders[i]['date'] = getDateTime(); //update the date modified
        folders[i]['description'] = _description;
        folders[i]['link'] = _link;
        //folders = folders;
      }
    }
    userData.folder_list[widget.folder_id] = _name;  //update folder name in user data
    userData.version = DateTime.now();  //update version number
    userData.writeUserData(_uid, userData);  //update local user data
    userData.writeFirestoreUserData(_uid, userData); //update cloud data
  }
  void pa(){
    print("HELLO");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<Map>(
       future: onLoad(),
       builder: (BuildContext context, AsyncSnapshot snapshot){
         switch(snapshot.connectionState){
           case ConnectionState.waiting:
           case ConnectionState.active:
            return WaitingScreen(pa);break;
           case ConnectionState.done:
             _name = snapshot.data["name"];
             _date = snapshot.data["date"];
             _description = snapshot.data["description"];
             _link = snapshot.data["link"];
             _children = snapshot.data["children"];
            return SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    HorizontalScroll(widget.folder_id),
                    Container(
                      width: 800,
                      height: 800,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Folder Name: ${_name}',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
                          Text('Date: ${_date}', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.justify),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text('Description: $_description', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
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
                                              _description = onValue;
                                              await _update();
                                              setState(() {
                                                _description = onValue;
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
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text('Link: ${_link}', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
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
                                              _link = onValue;
                                              await _update();
                                              setState(() {
                                                _link = onValue;
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox.fromSize(
                                size: Size(80, 80), // button width and height
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
                                          Text("Save &\nBack", textAlign: TextAlign.center,), // text
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
            );break;
           default:
             return sizedErrorScreen(null,errorText: snapshot.error);
         }
       },
      )
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

class HorizontalScroll extends StatefulWidget{
  final folder_id;
  HorizontalScroll(this.folder_id);

  @override
  State<StatefulWidget> createState() => new _HorizontalScrollState();
}
class _HorizontalScrollState extends State<HorizontalScroll>{
  String _name, _description, _link;
  String _date;
  List _children;
  List<Widget> _images;
  String _uid;

  void pa(){
    print("HELLO");
  }

  Future<Map> onLoad() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    Map folder = await getFolderData(_uid, widget.folder_id, context);
    return folder;
  }

  void onTap(){
    Navigator.pushNamed(context, File_Page,arguments: {'folder_id':widget.folder_id});
  }

  Future<List<Widget>> _generateImagePreview(List children) async {
    String uid = _uid;
    final String folder_path = await getLocalPath() + "/" + uid + "/" + widget.folder_id;
    print("Generating image previews...");
    List<Widget> showImagePreview = [];
    uid = uid.substring(0,3);
    for(Map image in children){  //create directory on local storage if not exists
      final String file_path = folder_path + "/" + "TMB_" + uid + image["image_id"] + ".jpg";
      File file = File(file_path);
      if(await file.exists())
        showImagePreview.add(ImagePreview(file_path,onTap:onTap));
      else {
        await CloudStorage().getFileToGallery(
            _uid, image["image_id"], widget.folder_id);
        showImagePreview.add(ImagePreview(file_path,onTap:onTap));
      }
    }
    print(showImagePreview);
    return showImagePreview;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:800.0,
      height: 200.0,
      child: FutureBuilder(
        future: onLoad(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.active:
              return WaitingScreen(pa);break;
            case ConnectionState.done:
              _name = snapshot.data["name"];
              _date = snapshot.data["date"];
              _description = snapshot.data["description"];
              _link = snapshot.data["link"];
              _children = snapshot.data["children"];
              if(_children.isNotEmpty)
                return FutureBuilder(
                  future: _generateImagePreview(_children),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return WaitingScreen(pa);break;
                      case ConnectionState.done:
                        return Container(
                          color: Colors.black12,
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 240,
                          child: GestureDetector(
                            onTap: () => onTap(),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children:
                                snapshot.data
                            ),
                          )
                        );break;
                      default:
                        return sizedErrorScreen(null,errorText: snapshot.error);
                    }
                  },
                );
              else
                return Container(
                    color: Colors.black12,
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    height: 240,
                    child: GestureDetector(
                      onTap: () => onTap(),
                      child: ImagePreview("null")
                    )
                );
              break;
            default:
              return sizedErrorScreen(null,errorText: snapshot.error);
          }
        },
      )
    );
  }
}

class ImagePreview extends StatelessWidget{
  final String _imagePath;  //with file extension
  final Function onTap;
  ImagePreview(this._imagePath,{this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100.0,
      height: 100.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Center(
              child: _imagePath == "null"?  Text("No Images") : Image.file(File(_imagePath)),
            ),
          ]
        )
      )
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