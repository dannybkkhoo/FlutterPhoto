import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app2/services/utils.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:app2/services/cloud_storage.dart';
import 'package:app2/services/authprovider.dart';
import 'package:app2/services/authenticator.dart';
import 'package:app2/services/firestore_storage.dart';
import 'package:app2/services/userdata.dart';
import 'package:app2/services/dataprovider.dart';
import 'package:app2/services/image_storage.dart';
import 'dart:io';

class ImagePage extends StatefulWidget{
  final VoidCallback onSignedOut;
  const ImagePage({this.onSignedOut});

  @override
  State<StatefulWidget> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>{
  GlobalKey<ImageHolderState> key = GlobalKey();

  Future<void> _signOut(BuildContext context) async {
    try{
      final Authenticator auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> cloudfunc() async {
    final HttpsCallable getData = CloudFunctions.instance.getHttpsCallable(functionName: "getData");
    var resp = await getData.call();
    print(resp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Photo Gallery"),
        leading: Icon(Icons.menu),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right:20.0),
            child: GestureDetector(
              onTap: () async => await _signOut(context),
              child: Icon(Icons.exit_to_app,size: 26.0),
            )
          )
        ],
      ),
      floatingActionButton: SpeedDialButton([
        SpeedButtonProperties(() async => await FirestoreStorage().getSubDocumentData('D','UID','collection','main_collection'),"test",Icon(Icons.adb)),
        SpeedButtonProperties(() async => FirestoreStorage().updateChild('A', 'Test_1', 'Test_img', 'date', '15/4/2020'),"Update Child",Icon(Icons.event_busy)),
        SpeedButtonProperties(() async => await CloudStorage().uploadImage('123', 'abc', key.currentState.returnImage()),"UP",Icon(Icons.add)),
        SpeedButtonProperties(() async => key.currentState.getCameraImage(),"Camera",Icon(Icons.add_a_photo)),
        SpeedButtonProperties(() async => key.currentState.clearImage(),"Clear",Icon(Icons.event_busy)),
        SpeedButtonProperties(() async => key.currentState.getImageFromFirebase("123","abc","a folder"),"getOnline",Icon(Icons.add)),
      ]),
      body: Column(
        children: <Widget>[
          ImageHolder(key: key),  //key passed to class so that parent can change variable state of that class
          RaisedButton(
            onPressed: () {
              //var data = DataProvider.of(context).userData.folders;
              var data = DataProvider.of(context).userData;
              print(data.folder_list);
              print(data.image_list);
              print(data.folders);
            },
          ),
          RaisedButton(
            onPressed: () {
              var data = DataProvider.of(context).userData.image_list;
              data['a'] = '1';
              var data2 = DataProvider.of(context).userData.folder_list;
              data2['b'] = '2';
              data2['c'] = 'Solar';
              DataProvider.of(context).userData.folders.add(fold.dat());
              print(DataProvider.of(context).userData.image_list);
              print(DataProvider.of(context).userData.folder_list);
              print(DataProvider.of(context).userData.folders);
            },
          ),
          RaisedButton(
            child: Text("Add Image"),
            onPressed: () {
              ImageStorage().AddImage(context);
            },
          ),
          RaisedButton(
            child: Text("Add Folder"),
            onPressed: () {
              ImageStorage().AddFolder(context);
            },
          )
        ],
      )
    );
  }
}