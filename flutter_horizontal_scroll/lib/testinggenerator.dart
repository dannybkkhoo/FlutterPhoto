import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
  home: GridviewFolder(),
)
);
class GridviewFolder extends StatefulWidget{
  @override
  _GridviewFolderState createState() => new _GridviewFolderState();
}

class _GridviewFolderState extends State<GridviewFolder>{
  List<Widget> folders = new List<Widget>();
  int num = 0;

  void addFolder(ShowFolder folder){
    if(folder != null) {
      setState(() {
        //folders.add(folder);
        folders = List.from(folders)..add(folder);
      });
    }
  }

  createAlertDialog(BuildContext context){
    TextEditingController foldernameController = TextEditingController();
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Folder Name?"),
        content: TextField(
          controller: foldernameController ,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
            onPressed: (){},
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
            onPressed: (){},
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Gallery"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print('sortyo');
              new Directory('/data/user/0/com.dreams.flutterhorizontalscroll/app_flutter/$num/').delete(recursive: true);
              print('Deleted until number $num');
              //deleteFolder(num.toString());
              num--;
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              print('sortyo');
              //ShowSortOptions(context);

            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print('Sharings');
              //ShowFolderOptions(context);
            },
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          createAlertDialog(context);
          addFolder( await AppUtil.createFolderInAppDocDir(num.toString()));
          num++;
        },
        icon: Icon(Icons.add, color: Colors.black,),
        label: Text("New Folder"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
            child:Column(
              children: <Widget>[
                SearchFolder(),
                Container(

                    alignment: Alignment.topLeft,
                    child: Text('  Number of Folders = $num ',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                    )

                ),

                GridView.count(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: folders,
                ),

              ],
            )
        ),
      )


    );
  }
}

class SearchFolder extends StatelessWidget{
  //final _imagepath;
  SearchFolder();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10,top: 20),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search Folder",
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

class ShowFolder extends StatefulWidget {
  final String folderName;
  ShowFolder(this.folderName);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}


class _ShowFolderState extends State<ShowFolder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Card(
        elevation: 10.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new SizedBox(
              height: 5.0,
            ),
            new Image.asset("assets/Capture01.PNG",
                height: 100.0, width: 100.0,fit: BoxFit.cover),
            new SizedBox(
              height: 5.0,
            ),
            new Text(widget.folderName, style: TextStyle(fontSize: 15.0),)
          ],
        ),
      ),
    );
  }
}

class AppUtil{
  static Future<ShowFolder> createFolderInAppDocDir(String folderName) async {
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');

    if(await _appDocDirFolder.exists()){
      print("Already Created Folder in: $_appDocDirFolder");
      return null;
    }
    else{
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive:true);
      print("Created new folder: $_appDocDirFolder");
      return ShowFolder(folderName);
    }
  }
}