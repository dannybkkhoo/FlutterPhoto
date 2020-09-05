import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../../services/authprovider.dart';
import '../../services/cloud_storage.dart';
import '../../services/dataprovider.dart';
import '../../services/image_storage.dart';
import '../../services/userdata.dart';
import '../../services/utils.dart';

enum UserDataStatus{
  loading,
  loaded,
  error,
}

class MainPageFolder extends StatefulWidget {
  final String title;
  final VoidCallback onSignedOut;
  MainPageFolder({this.title, this.onSignedOut}) : super();

  @override
  State<StatefulWidget> createState() => MainPageFolderState();
}
class MainPageFolderState extends State<MainPageFolder> {
  UserDataStatus _status = UserDataStatus.error;
  String _statusText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      //_onLoad();
    });
  }

  Stream<List<Widget>> _generateFolders(List folders) async* {
    final String uid = await AuthProvider.of(context).auth.getUID();
    print("Generating folders...");
    List<Widget> showfolders = [];
    for(Map folder in folders){  //create directory on local storage if not exists, forEach cant be used as it does not await
      final folder_path = await getLocalPath() + "/" + uid + "/" + folder['folder_id'];
      //showfolders.add(ShowFolder(folder['folder_id'],folder['name'],folder['description'],folder['link'],folder[]'children'));
      //showfolders.add(ShowFolder(folder['folder_id']));
      await createDirectory(folder_path);
//       for(Map image in folder["children"]){ //create file on local storage and download the image files if not exists
//         //final appDocDir = await getLocalPath();   //all files stored under appDocDirectory/uid
//         //final uidpart = uid.substring(0,3);             //take first 4 digit of UID
//         //Directory tmbpath = Directory("$appDocDir/$uid/${folder["folder_id"]}/TMB_$uidpart${image["image_id"]}.jpg");
//         //Directory imgpath = Directory("/storage/emulated/0/FlutterPhoto/IMG_$uidpart${image["image_id"]}.jpg");
//         //bool exist = await File(imgpath.path).exists();
//         //bool exist2 = await File(tmbpath.path).exists();
// //        if(exist2){
// //          print("${image["image_id"]} exists");
// //        }
// //        if(!exist){
// //          print("${image["image_id"]} not exists");
// //          await CloudStorage().getFileToGallery(uid, image['image_id'], folder["folder_id"]);
// //          print("Done download");
// //        }
// //        if(!await tmbpath.exists()){
// //          await createLocalThumbnail(uid, image['image_id'],folder['folder_id'], File(imgpath.path));
// //        }
// //        if(!await tmbpath.exists()){
// //          await createLocalThumbnail(uid, image["image_id"], folder_path, File(imgpath.path));
// //        }
//       }
      //showfolders.add(ShowFolder(folder['folder_id']));
      showfolders.add(Foldr(folder['folder_id']));
      yield showfolders;
    }
  }
  Future<UserData> _onLoad() async {
    const int maxRetry = 3;
    String uid;
    print("Getting UID...");
    setState(() {
      _status = UserDataStatus.loading;
      _statusText = "Getting UID...";
    });
    for(int x = 0;x<maxRetry;x++) {
      uid = await AuthProvider.of(context).auth.getUID();
      if(uid != null){  //if UID successfully retrieved, continue next operation
        break;
      }
      else if(x<maxRetry-1){  //otherwise, retry getting UID for maxRetry - 1 times
        print("Failed to get UID, retrying...");
        setState(() {
          _statusText = "Failed to get UID, retrying...";
        });
        await Future.delayed(Duration(seconds: 2)); //wait for 2 seconds and retry/continue get UID again
      }
      else{ //if UID still failed to get after maxRetry - 1, operation cancelled, print error
        print("Failed to get UID after $maxRetry tries, please check for errors.");
        setState(() {
          _statusText = "Failed to get UID after $maxRetry tries, please check for errors.";
          _status = UserDataStatus.error;
        });
        return null;  //ends the onLoad() function
      }
    }
    print("Retrieving User Data...");
    setState(() {
      _statusText = "Retrieving User Data...";
    });
    for(int x = 0;x<maxRetry;x++){
      if(await DataProvider.of(context).userData.loadLatestUserData(uid) != null) {
        setState(() {
          _status = UserDataStatus.loaded;
        });
        return DataProvider.of(context).userData;
      }
      else if(x<maxRetry-1){  //otherwise, retry getting UID for maxRetry - 1 times
        print("Failed to retrieve User Data, retrying...");
        setState(() {
          _statusText = "Failed to retrieve User Data, retrying";
        });
        await Future.delayed(Duration(seconds: 2)); //wait for 2 seconds and retry/continue get data again
      }
      else{ //if User Data still failed to get after maxRetry - 1, operation cancelled, print error
        print("Failed to retrieve User Data after $maxRetry tries, please check for errors.");
        setState(() {
          _statusText = "Failed to retrieve User Data after $maxRetry tries, please check for errors.";
          _status = UserDataStatus.error;
        });
        return null;  //ends the onLoad() function
      }
    }
  }
  void _refresh() async {
    print("Refreshing screen...");
    await _onLoad();
    setState(() {});
  }
  void _onCancel(){
    print("User cancelled operation.");
    setState((){
      _statusText = "User Data loading interrupted.";
      _status = UserDataStatus.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(_status){
      case UserDataStatus.loading:
        //Shows a loading circle while fetching user data, if user cancel, will sign out and go back to login page
        return WaitingScreen(_onCancel,showText: _statusText);break;
      case UserDataStatus.error:
        //Shows an error page prompting user to retry, or log out and go back to login page
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20,10,20,10),
                  child: Text(_statusText, style: TextStyle(fontSize: 36.0), textAlign: TextAlign.center,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      child: RaisedButton(
                        child: Text("Retry", style: TextStyle(fontSize: 24.0)),
                        onPressed: () => _onLoad(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: RaisedButton(
                        child: Text("Back", style: TextStyle(fontSize:24.0)),
                        onPressed: () => widget.onSignedOut(),
                      ),
                    )
                  ],
                )
              ],
            )
          )
        );break;
      case UserDataStatus.loaded:
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
                await ImageStorage().AddFolder(context);
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
                RaisedButton(
                  child:Text("Download Image"),
                  onPressed: () async {
                    print("Wait");
                    print(await getLocalPath());
                    File img = await CloudStorage().getFileToGallery("123", "abc", "123");
                    print("K Done");
                  }
                ),
                RaisedButton(
                  child:Text("getsub"),
                  onPressed: () => DataProvider.of(context).userData.deleteUserData('123'),
                ),
                Expanded(
                  child: StreamBuilder<List<Widget>>(
                      stream: _generateFolders(DataProvider.of(context).userData.folders),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting: return sizedWaitingScreen();break;
                          case ConnectionState.active:
                          //print(snapshot.data);
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
              ],
          )
        ); break;
      default:
        //Shows an error page, only allowing user to log out and go back to login page due to unknown error
        return ErrorScreen(widget.onSignedOut);
    }
  }
}

class ShowFolder extends StatefulWidget {
  final String folder_id;
  ShowFolder(this.folder_id);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}
class _ShowFolderState extends State<ShowFolder>{
  String _uid, _name;
  List _children = [];
  Future<Widget> FolderThumbnail(List children) async { //finds the image on local device and display
    var uid = await AuthProvider.of(context).auth.getUID();
    if(children.isNotEmpty){
      final file_path = await getLocalPath() + "/" + uid + "/" + widget.folder_id;
      final image_filename = children[0]['image_id'];
      uid = uid.substring(0,3);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Image.file(File("$file_path/TMB_$uid$image_filename.jpg"),height: 100.0, width: 100.0,fit: BoxFit.cover),
          ),
          Text(_name, style: TextStyle(fontSize: 15.0),)
        ],
      );
    }
    else{
      return NoImage(_name);
    }
  }
  Future<Map> onLoad() async {
      _uid = await AuthProvider.of(context).auth.getUID();
      Map folder = await getFolderData(_uid, widget.folder_id, context);
      return folder;
  }

  @override
  void initState() {
    super.initState();
  }
  void pa(){
    print("HELLO");
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
            return Container(
                alignment: Alignment.center,
                child: Wrap(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,File_Page,arguments: {'folder_id':widget.folder_id});
                          },
                          child: Container(
                            child: new Card(
                                elevation: 10.0,
                                child: FutureBuilder<Widget>(
                                    future: FolderThumbnail(_children),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      switch(snapshot.connectionState){
                                        case ConnectionState.done:
                                          if(snapshot.hasData){
                                            return snapshot.data;
                                          };break;
                                        default:
                                          return NoImage(_name);
                                      }
                                    }
                                )
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
