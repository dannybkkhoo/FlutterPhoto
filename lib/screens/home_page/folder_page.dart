import 'dart:io';
import 'package:app2/services/cloud_storage.dart';
import 'package:app2/services/firestore_storage.dart';
import 'package:app2/services/image_storage.dart';
import 'package:app2/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'horizontalscrollwithdescription.dart';

import 'package:app2/services/dataprovider.dart';
import 'package:app2/services/userdata.dart';
import 'package:app2/services/authprovider.dart';
import 'package:app2/services/authenticator.dart';
import 'package:after_init/after_init.dart';

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
  State<StatefulWidget> createState() => new MainPageFolderState();
}
class MainPageFolderState extends State<MainPageFolder> {
  UserDataStatus status = UserDataStatus.error;
  String statusText = "";
  List<Widget> folders = new List<Widget>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      onLoad();
    });
  }

  void deleteFolder(ShowFolder folder){
    if(folder != null) {
      setState(() {
        folders = List.from(folders)..remove(folder);
        print(folders);
      });
    }
  }

  Future<List<Widget>> generateFolders(List folders) async {
    final String uid = await AuthProvider.of(context).auth.getUID();
    print("Generating folders...");
    List<Widget> showfolders = [];
    folders.forEach((folder) async {  //create directory on local storage if not exists
      final folder_path = await getPath() + "/" + uid + "/" + folder['folder_id'];
      showfolders.add(ShowFolder(folder['folder_id'],folder['name'],folder['description'],folder['link'],folder['children']));
      await createDirectory(folder_path);
      folder['children'].forEach((file) async { //create file on local storage and download the image files if not exists
        await CloudStorage().getFile(uid, file['image_id'], folder_path);
      });
    });
    print(folders);
    return showfolders;
  }
  Future<UserData> onLoad() async {
    const int maxRetry = 3;
    String uid;
    print("Getting UID...");
    setState(() {
      status = UserDataStatus.loading;
      statusText = "Getting UID...";
    });
    for(int x = 0;x<maxRetry;x++) {
      uid = await AuthProvider.of(context).auth.getUID();
      if(uid != null){  //if UID successfully retrieved, continue next operation
        break;
      }
      else if(x<maxRetry-1){  //otherwise, retry getting UID for maxRetry - 1 times
        print("Failed to get UID, retrying...");
        setState(() {
          statusText = "Failed to get UID, retrying...";
        });
        await Future.delayed(Duration(seconds: 2)); //wait for 2 seconds and retry/continue get UID again
      }
      else{ //if UID still failed to get after maxRetry - 1, operation cancelled, print error
        print("Failed to get UID after $maxRetry tries, please check for errors.");
        setState(() {
          statusText = "Failed to get UID after $maxRetry tries, please check for errors.";
          status = UserDataStatus.error;
        });
        return null;  //ends the onLoad() function
      }
    }
    print("Retrieving User Data...");
    setState(() {
      statusText = "Retrieving User Data...";
    });
    for(int x = 0;x<maxRetry;x++){
      if(await DataProvider.of(context).userData.loadLatestUserData(uid) != null) {
        setState(() {
          status = UserDataStatus.loaded;
        });
        return DataProvider.of(context).userData;
      }
      else if(x<maxRetry-1){  //otherwise, retry getting UID for maxRetry - 1 times
        print("Failed to retrieve User Data, retrying...");
        setState(() {
          statusText = "Failed to retrieve User Data, retrying";
        });
        await Future.delayed(Duration(seconds: 2)); //wait for 2 seconds and retry/continue get data again
      }
      else{ //if User Data still failed to get after maxRetry - 1, operation cancelled, print error
        print("Failed to retrieve User Data after $maxRetry tries, please check for errors.");
        setState(() {
          statusText = "Failed to retrieve User Data after $maxRetry tries, please check for errors.";
          status = UserDataStatus.error;
        });
        return null;  //ends the onLoad() function
      }
    }
  }
  void _refresh() async {
    print("Refreshing screen...");
    await onLoad();
    setState(() {});
  }
  void _onCancel(){
    print("User cancelled operation.");
    setState((){
      statusText = "User Data loading interrupted.";
      status = UserDataStatus.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(status){
      case UserDataStatus.loading:
        //Shows a loading circle while fetching user data, if user cancel, will sign out and go back to login page
        return WaitingScreen(_onCancel,showText: statusText);break;
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
                  child: Text(statusText, style: TextStyle(fontSize: 36.0), textAlign: TextAlign.center,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      child: RaisedButton(
                        child: Text("Retry", style: TextStyle(fontSize: 24.0)),
                        onPressed: () => onLoad(),
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
        return new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
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
                  setState(() {
                    status = UserDataStatus.error;
                  });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => widget.onSignedOut()
                )
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async => ImageStorage().AddFolder(context),
              icon: Icon(Icons.add, color: Colors.black,),
              label: Text("New Folder"),
              foregroundColor: Colors.black,
              backgroundColor: Colors.amberAccent,
            ),
            body: LayoutBuilder(
              builder: (context, constraint) {
                return SafeArea(
                    child: CustomScrollView(
                      slivers: <Widget> [
                        SliverFillRemaining(
                          hasScrollBody: false,
                            child: IntrinsicHeight(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RaisedButton(
                                      child:Text("getsub"),
                                      onPressed: () => DataProvider.of(context).userData.deleteUserData('123'),
                                    ),
                                    FutureBuilder<List<Widget>>(
                                        future: generateFolders(DataProvider.of(context).userData.folders),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          switch(snapshot.connectionState){
                                            case ConnectionState.waiting: return sizedWaitingScreen();break;
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
                                                return Expanded(
                                                    child: Center(
                                                        child: Text("No Folders...",style: TextStyle(fontSize:24.0),)
                                                    )
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
                                  ],
                                )
                            )
                        )
                      ]
                    )
                );
              }
            )
        ); break;
      default:
        //Shows an error page, only allowing user to log out and go back to login page due to unknown error
        return ErrorScreen(widget.onSignedOut);
    }
  }
}
class ShowFolder extends StatefulWidget {
  final String folder_id, name, description, link;
  List children;
  ShowFolder(this.folder_id,this.name,this.description,this.link,this.children);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}
class _ShowFolderState extends State<ShowFolder>{
  Future<Widget> FolderThumbnail(List children) async { //finds the image on local device and display
    if(children.isNotEmpty){
      final file_path = await getPath() + "/" + await AuthProvider.of(context).auth.getUID() + "/" + widget.folder_id;
      final image_filename = children[0]['image_id'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Image.file(File("$file_path/$image_filename.jpg"),height: 100.0, width: 100.0,fit: BoxFit.cover),
          ),
          Text(widget.name, style: TextStyle(fontSize: 15.0),)
        ],
      );
    }
    else{
      return NoImage(widget.name);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: (){
                print("pressed");
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription(widget.folderName)));
              },
              child: Container(
                child: new Card(
                  elevation: 10.0,
                  child: FutureBuilder<Widget>(
                    future: FolderThumbnail(widget.children),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch(snapshot.connectionState){
                        case ConnectionState.done:
                          if(snapshot.hasData){
                            return snapshot.data;
                          };break;
                        default:
                          return NoImage(widget.name);
                      }
                    }
                  )
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}
