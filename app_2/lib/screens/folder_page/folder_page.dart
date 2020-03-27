import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FolderCreator extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FolderState();
}

class _FolderState extends State<FolderCreator>{
  List<Widget> folders = new List<Widget>();
  int num = 51;

  void addFolder(ShowFolder folder){
    if(folder != null) {
      setState(() {
        //folders.add(folder);
        folders = List.from(folders)..add(folder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Gallery"),
        centerTitle: true,
        backgroundColor:  Colors.red[600],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          addFolder( await AppUtil.createFolderInAppDocDir(num.toString()));
          num++;
        },
        icon: Icon(Icons.add, color: Colors.black,),
        label: Text("New Folder"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        //child: Row(children: folders,)
        child: Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: folders,
          ),
        )
      )
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

class ShowFolder extends StatefulWidget {
  final String folderName;
  ShowFolder(this.folderName);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}

class _ShowFolderState extends State<ShowFolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: 100,
      height: 100,
      child: Text(widget.folderName, style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic),
        textAlign: TextAlign.left,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        color: Colors.grey,
      )
    );
  }
}