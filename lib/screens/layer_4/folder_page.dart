import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/authentication/authenticator.dart';
import '../../services/authentication/authprovider.dart';
import '../../services/cloud_storage/cloud_storage.dart';
import '../../services/cloud_storage/image_storage.dart';
import '../../services/local_storage/dataprovider.dart';
import '../../services/local_storage/userdata.dart';
import '../../services/utils.dart';

class MainPageFolder extends StatefulWidget {
  final String title;
  final VoidCallback onSignedOut;
  MainPageFolder({this.title, this.onSignedOut}) : super();

  @override
  State<StatefulWidget> createState() => MainPageFolderState();
}
class MainPageFolderState extends State<MainPageFolder> {
  String _uid;
  UserData _userData;
  Future<UserData> _receivedData;
  ImageStorage imageStorage = ImageStorage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _receivedData = _loadUserData();
  }

  Stream<List<Widget>> _generateFolders(List folders) async* {
    print("Generating folders...");
    List<Widget> showfolders = [];
    for(Map folder in folders){  //forEach cant be used as it does not await
      //showfolders.add(Foldr(folder['folder_id']));
      showfolders.add(ShowFolder(folder["folder_id"]));
      yield showfolders;
    }
  }
  Future<UserData> _loadUserData() async {
    debugPrint("Getting UID...");
    _uid = await AuthProvider.of(context).auth.getUID();
    debugPrint("Loading User Data...");
    _userData = DataProvider.of(context).userData;
    return _userData;
  }
  void _refresh() async{
    UserData data = await _loadUserData();
    setState(() {
      _userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _receivedData,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.active:
              return WaitingScreen(()=>print("Loading..."));
              break;
            case ConnectionState.done:
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text(widget.title),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          print('sortyo');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.sort_by_alpha),
                        onPressed: () {
                          print('sortyo');
//                ShowSortOptions(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          print('Sharings');
//                ShowFolderOptions(context);
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () => widget.onSignedOut()
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () async {
                      await imageStorage.AddFolder(context);
                      setState(() {});
                    },
                    icon: Icon(Icons.add, color: Colors.black,),
                    label: Text("New Folder"),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.amberAccent,
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<List<Widget>>(
                            stream: _generateFolders(_userData.folders),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              switch(snapshot.connectionState){
                                case ConnectionState.waiting: return sizedWaitingScreen();
                                break;
                                case ConnectionState.active:
                                  if(snapshot.hasData && snapshot.data.isNotEmpty) {
                                    return GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
                    ],
                  )
              );
              break;
            default:
              return ErrorScreen(()=>print("Error!"));
          }
      }
    );
  }
}

class ShowFolder extends StatefulWidget {
  final String folder_id;
  ShowFolder(this.folder_id);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}
class _ShowFolderState extends State<ShowFolder>{
  String _uid, _name, _appDocDir;
  List _children = [];
  Future<Map> _receivedData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _receivedData = _loadFolderData();
  }

  Future<Map> _loadFolderData() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    _appDocDir = await getLocalPath();
    Map folder = getFolderData(_uid, widget.folder_id, context);
    return folder;
  }
  Widget FolderThumbnail(List children) { //finds the image on local device and display
    if(children.isNotEmpty){
      final file_path = _appDocDir + "/" + _uid + "/" + widget.folder_id;
      final image_filename = children[0]['image_id'];
      final uid = _uid.substring(0,3);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Image.file(File("$file_path/TMB_$uid$image_filename.jpg"),height: 100.0, width: 100.0,fit: BoxFit.contain),
          ),
          Text(_name, style: TextStyle(fontSize: 15.0),)
        ],
      );
    }
    else{
      return NoImage(_name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Map>(
      future: _receivedData,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(()=>print("Issue"));
            break;
          case ConnectionState.done:
            _name = snapshot.data["name"];
            _children = snapshot.data["children"];
            return Container(
                alignment: Alignment.center,
                child: Wrap(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.popAndPushNamed(context,File_Page,arguments: {'folder_id':widget.folder_id});
                          },
                          child: Container(
                            child: new Card(
                                elevation: 10.0,
                                child: FolderThumbnail(_children)
                            ),
                          ),
                        ),
                      )
                    ]
                )
            );break;
          default:
            return sizedErrorScreen(null,errorText: snapshot.error);
        }
      },
    );
  }
}

/*Foldr Page----------------------------------------------------------------------------------------*/
class Foldr extends StatefulWidget {
  final String folder_id;
  Foldr(this.folder_id);

  @override
  _FoldrState createState() => _FoldrState();
}
class _FoldrState extends State<Foldr>{
  String _uid, _name, appDocDir, uidpart;
  List _children = [];
  Future<Map> onLoad() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    Map folder = await getFolderData(_uid, widget.folder_id, context);
    return folder;
  }
  Stream<int> _downloadImages(List image_datas) async* {
    appDocDir = await getLocalPath();
    uidpart = _uid.substring(0,3);
    final length = image_datas.length;
    int index = 1;
    if(length != 0){
      print("Downloading images...");
      for(Map image in image_datas){
        print("[$index/$length] image id:${image["image_id"]}, image name:${image["name"]}");
        File img = File("/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg");
        Directory imgpath = Directory("/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg");
        File tmb = File("$appDocDir/$_uid/${widget.folder_id}/TMB_$uidpart${image["image_id"]}.jpg");
        if(await img.exists()){
          print("${image["name"]} exists.");
        }
        else {
          print("${image["name"]} does not exists.");
          await CloudStorage().getFileToGallery(_uid, image['image_id'], widget.folder_id);
          print("${image["name"]} successfully downloaded.");
        }
        if(await tmb.exists()){
          print("${image["name"]} thumbnail exists.");
        }
        else{
          print("${image["name"]} thumbnail does not exists.");
          await createLocalThumbnail(_uid,image['image_id'], widget.folder_id, img);
          print("${image["name"]} thumbnail successfully downloaded.");
        }
        index+=1;
        yield index;
      }
    }
    else{
      print("No images in file.");
      yield null;
    }
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
    return new FutureBuilder<Map>(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(pa);break;
          case ConnectionState.done:
            _name = snapshot.data["name"];
            _children = snapshot.data["children"];
            print(_children);
            return StreamBuilder<int>(
                stream: _downloadImages(_children),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return sizedWaitingScreen();break;
                    case ConnectionState.active:
                      if(snapshot.data != null){
                        String image_id = _children[0]["image_id"];
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                  child: Image.file(File("$appDocDir/$_uid/${widget.folder_id}/TMB_$uidpart$image_id.jpg"),height: 100.0, width: 100.0,fit: BoxFit.cover),
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      else {
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height:100.0,
                                                    width:100.0,
                                                    padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                    child: Center(child: Text("No images..."))
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      break;
                    case ConnectionState.done:
                      if(snapshot.data != null){
                        String image_id = _children[0]["image_id"];
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                        //Navigator.pushNamed(context, FolderDescription_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                  child: Image.file(File("$appDocDir/$_uid/${widget.folder_id}/TMB_$uidpart$image_id.jpg"),height: 100.0, width: 100.0,fit: BoxFit.cover),
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      else {
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height:100.0,
                                                    width:100.0,
                                                    padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                    child: Center(child: Text("No images..."))
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      break;
                    default:
                      return NoImage(_name);
                  }
                }
            );
          default:
            return sizedErrorScreen(null,errorText: snapshot.error);
        }
      },
    );
  }
}
/*End of Foldr Page---------------------------------------------------------------------------------*/