import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'cloud_storage_service.dart';
import 'dart:io';

class ImagePage extends StatefulWidget{
  @override
  _ImageState createState() => _ImageState();
}

class _ImageState extends State<ImagePage>{
  File _image;
  CloudStorageResult _uploaded;
  String _uid;

  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }
  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  Future<String> getUID() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }
  Future<String> InputDialog(BuildContext context) async {
    String imageName = 'image_' + DateTime.now().toString();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Upload Image...'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Image Name:', hintText: 'eg. Solar'
                  ),
                  onChanged: (value) {
                    imageName = value;
                  },
                )
              )
            ]
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(imageName);
              },
            )
          ],
        );
      }
    );
  }

  Widget uploadQuestion(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Upload?',style: TextStyle(fontSize: 18.0),),
              onPressed:  () async{
                var UID = await getUID();
                String imageName = await InputDialog(context);
                var uploaded = await uploadImage(imageToUpload: _image, imageFilePath: UID, imageFileName: imageName);
                if(uploaded != null){
                  setState((){
                    _uploaded = uploaded;
                  });
                }
              },
            )
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:10.0),
            child: Center(
              child: Container(
                height: 200.0,
                width: 200.0,
                child:_image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
              ),
            ),
          ),
          Container(
            child: _image == null
                ? Text("Not yet")
                : uploadQuestion(context)
          ),
          Container(
            child: _uploaded == null
                ? Text("non")
                : Text(_uploaded.imageURL)
          ),
          Container(
            child: RaisedButton(
              child: _uid == null
                ? Text("UID:")
                : Text("UID:$_uid"),
              onPressed: () async {
                var id = await getUID();
                setState(() {
                  _uid = id;
                });
              },
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getCameraImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}