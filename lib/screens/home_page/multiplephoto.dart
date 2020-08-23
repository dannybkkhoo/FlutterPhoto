import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app2/services/dataprovider.dart';
import 'package:app2/services/userdata.dart';
import 'package:app2/services/authprovider.dart';
import 'package:app2/services/utils.dart';
import 'package:app2/services/image_storage.dart';
//import 'last2layers.dart';

class MainPage extends StatefulWidget {
  final String folder_id;
  @override
  MainPage(this.folder_id) : super();
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();//Return a state object
  }
}
class MainPageState extends State<MainPage> {
  String _name, _description, _link;
  String _date;
  List _children;
  List<Widget> _images;
  String _uid;
  File _image;
  static String _photoname = 'Photoname';
  @override
  void open_camera() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }
  void open_gallery() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<Map> onLoad() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    Map folder = await getFolderData(_uid, widget.folder_id, context);
    return folder;
  }
  void _refresh() async {
    print("Refreshing screen...");
    setState(() {});
  }
  void pa(){
    print("HELLO");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <Map>(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(pa);break;
          case ConnectionState.done:
            _name = snapshot.data["name"];
            _children = snapshot.data["children"];
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: new AppBar(
                title: new Text(_name),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      print('sortyo');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      open_camera();
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.sort_by_alpha),
                      onPressed: () {
                        print('sortyo');
                        ShowSortOptions(context);
                      }
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  await ImageStorage().AddImage(context,widget.folder_id);
                  setState(() {});
                  //open_gallery();
                },
                icon: Icon(Icons.add, color: Colors.black,),
                label: Text("Import Photos"),
                foregroundColor: Colors.black,
                backgroundColor: Colors.amberAccent,
              ),
              body:  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
//                    SearchPhoto(),
//                    Container(
//                        alignment: Alignment.topLeft,
//                        child: Text('  Number of Photos = ',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
//                        )
//
//                    ),
//                            _children.isNotEmpty?
                  Expanded(
                    child: StreamBuilder<List<Widget>>(
                        stream: _buildGridTiles(_children),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          switch(snapshot.connectionState){
                            case ConnectionState.waiting: return sizedWaitingScreen();break;
                            case ConnectionState.active:
                              print("AXN");
                              if(snapshot.hasData && snapshot.data.isNotEmpty) {
                                print(snapshot.data.runtimeType);
                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                                  itemCount: snapshot.data.length,
                                  padding: EdgeInsets.all(2.0),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        child: snapshot.data[index]
                                    );
                                  },
                                );
                              }
                              else {
                                return Center(
                                    child: Text("No Folders...",style: TextStyle(fontSize:24.0),)
                                );
                              }
                              break;
                            case ConnectionState.done:
                              print("DONE");
                              if(snapshot.hasData && snapshot.data.isNotEmpty) {
                                return GridView.count(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  children: snapshot.data,
                                );
                              }
                              else {
                                return Center(
                                    child: Text("No Folders...",style: TextStyle(fontSize:24.0),)
                                );
                              }
                              break;
                            default:
                              if(snapshot.hasError) {
                                print(snapshot.error);
                                return sizedErrorScreen(_refresh,errorText: snapshot.error);
                              }
                              else {
                                print(snapshot.data);
                                return sizedWaitingScreen(waitingWidget: Text("No Data...", style: TextStyle(fontSize:24.0)));
                              }
                          }
                        }
                    ),
                  )
//                                :
//                                Center(
//                                  child: Padding(
//                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
//                                    child: Text("No images..."),
//                                  )
//                                )
//                              GridView.count(
//                                physics: ScrollPhysics(),
//                                shrinkWrap: true,
//                                crossAxisCount: 3,
//                                children: _buildGridTiles(_children),
//                              ):
//                              Center(
//                                child: Padding(
//                                  padding: EdgeInsets.fromLTRB(0.0,20.0,0.0, 20.0),
//                                  child: Text("No images...")
//                                )
//                              ),
                ],
              )
            );break;
          default:
            return ErrorScreen(pa);
        }
      }
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
//  List<Widget> _buildGridTiles(BuildContext context, List children) {
//    List<Container> containers = new List<Container>.generate(children.length,
//            (int index) {
//          final imageName = index < 9 ?
//          'assets/Capture${index +1}.PNG' : 'assets/Capture${index +1}.PNG';
//
//          return new Container(
//              child: Wrap(
//                  children: <Widget>[
//                    Container(
//                      child: GestureDetector(
//                        onTap: (){
//                          print("pressed");
//                          //Navigator.push(context,MaterialPageRoute(builder: (context) => PhotoThing(_photoname)));
//                        },
//                        child: Container(
//                          child: new Card(
//                            elevation: 10.0,
//                            child: new Column(
//                              mainAxisSize: MainAxisSize.max,
//                              children: <Widget>[
//                                new Image.asset(imageName,
//                                    height: 90.0, width: 200.0,fit: BoxFit.fill),
//                                new FlatButton(
//                                  color: Colors.grey,
//                                  textColor: Colors.black,
//                                  splashColor: Colors.white,
//                                  padding: EdgeInsets.all(8.0),
//                                  child: Text(_photoname,style: TextStyle(fontSize: 20.0),),
//                                  onPressed: (){
//                                    createAlertDialog(context, "Photoname").then((onValue) async {
//                                      if( onValue != null) {
//                                        setState(() {
//                                          _photoname = onValue;
//                                        });
//                                      }
//                                    });
//                                  },
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    )
//
//                  ]
//              )
//          );
//        });
//    return containers;
//  }
  Stream<List<Widget>> _buildGridTiles(List children) async* {
    print("Generating images...");
    List<Widget> imagefiles = [];
    for(Map image in children){
      imagefiles.add(ShowImage(widget.folder_id,image['image_id']));
      print("HEREE");
      yield imagefiles;
    }
  }
}

class ShowImage extends StatefulWidget {
  final String folder_id, image_id;
  ShowImage(this.folder_id, this.image_id);

  @override
  _ShowImageState createState() => _ShowImageState();
}
class _ShowImageState extends State<ShowImage>{
  String _uid, _name;
  Future<File> onLoad() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    var userData = DataProvider.of(context).userData; //get user's data
    _name = userData.image_list[widget.image_id];
    String uidpart = _uid.substring(0,3);
    final file_path = await getLocalPath() + "/" + _uid + "/" + widget.folder_id;
    return File("$file_path/TMB_$uidpart${widget.image_id}.jpg");
  }
  void _update() async {
    UserData userData;
    Directory oldPath;
    userData = await DataProvider.of(context).userData; //find user data from local
    List folders = userData.folders;
    for(var folder in folders){
      if(folder['folder_id'] == widget.folder_id){
        List images = folder['children'];
        for(var image in images){
          if(image['image_id'] == widget.image_id){
            image['name'] = _name;
            image['date'] = getDateTime();
            //image['filepath'] = _filepath;
            //image['description'] = _description;
            break;
          }
        }
        break;
      }
    }
    userData.image_list[widget.image_id] = _name;  //update folder name in user data
    userData.version = DateTime.now();  //update version number
    userData.writeUserData(_uid, userData);  //update local user data
    userData.writeFirestoreUserData(_uid, userData); //update cloud data
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
  void pa(){
    print("HELLO");
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<File>(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(pa);break;
          case ConnectionState.done:
            return Container(
                child: Wrap(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            print("pressed");
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => PhotoThing(_photoname)));
                          },
                          child: Container(
                            child: new Card(
                              elevation: 10.0,
                              child: new Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Image.file(snapshot.data,height: 100.0, width: 100.0,fit: BoxFit.cover),
                                  new FlatButton(
                                    color: Colors.grey,
                                    textColor: Colors.black,
                                    splashColor: Colors.white,
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(_name,style: TextStyle(fontSize: 18.0),),
                                    onPressed: (){
                                      createAlertDialog(context, "Change Photo Name?").then((onValue) async {
                                        if(onValue != null) {
                                          _name = onValue;
                                          await _update();
                                          setState(() {
                                            _name = onValue;
                                          });
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )

                    ]
                )
            );;break;
          default:
            return sizedErrorScreen(null,errorText: snapshot.error);
        }
      },
    );
  }
}


class SearchPhoto extends StatelessWidget{
  //final _imagepath;
  SearchPhoto();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10,top: 20),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search Photo",
            border: InputBorder.none,
            fillColor: Colors.grey,
            icon: Icon(Icons.search)
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )
      ),
    );
  }
}
void ShowSortOptions(BuildContext context) async{
  final items = <MultiSelectDialogSortItem<int>>[
    MultiSelectDialogSortItem(1, 'Name'),
    MultiSelectDialogSortItem(2, 'Date'),

  ];

  final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context){
        return MultiSelectDialogSort(
          items: items,
          //initialSelectedValues: [1].toSet(),
        );
      }
  );
}
class MultiSelectDialogSortItem<V> {
  const MultiSelectDialogSortItem(this.value, this.label);

  final V value;
  final String label;
}
class MultiSelectDialogSort<V> extends StatefulWidget {
  MultiSelectDialogSort({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogSortItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogStateSort<V>();
}
class _MultiSelectDialogStateSort<V> extends State<MultiSelectDialogSort<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sort By'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogSortItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}