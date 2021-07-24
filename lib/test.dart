import 'package:app2/themes.dart';
import 'package:flutter/material.dart';
import 'screen.dart';
import 'images.dart';
import 'strings.dart';
import 'theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';
import 'userdata.dart';
import 'firestore_storage.dart';
import 'cloud_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends ConsumerWidget {
  late String text;
  late String image;
  TestPage({Key? key, this.text = Strings.defaultError, this.image = Images.defaultError}) : super(key:key) {Screen().portrait();}

  Userdata user = Userdata(
    id:"123",
    name:"ABC",
    createdAt: DateTime.now().toString(),
    version: DateTime.now().toString(),
  );

  Folderdata fold = Folderdata(
    id:"123",
    name:"ABC",
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
    link: "DEF",
    description: "GHI",
    imagelist: ["HMMM","LOL"]
  );

  Imagedata imag = Imagedata(
    id: "123",
    name: "ABC",
    createdAt: DateTime.now().toString(),
  );

  void test() {
    final userz = user.copyWith(images: {imag.id:imag});
    final serial = userz.toJson();
    final deserial = Folderdata.fromJson(serial);
    print(serial);
    print(deserial);
  }

  void upload(String uid) async {
    final userz = user.copyWith(folders:{fold.id:fold},images: {imag.id:imag});
    final data = userz.toJson();
    await FirestoreStorage().writeData("UserData", uid, "collection", "main_collection", data);
  }

  void download(String uid) async {
    final data = await FirestoreStorage().readData("UserData", uid, "collection", "main_collection");
    if(data != null){
      final deserial = Userdata.fromJson(data);
      print("Data is:\n${deserial}");
    }
  }

  File? _image = null;

  void uploadImage(CloudStorage ref) async {
    if(_image != null)
      ref.uploadImage("123/photos/testing.jpg", _image!);
    else
      print("Null image");
  }

  void _imageExists(File image) {
    _image = image;
  }

  void _imageNotExists() {
    _image = null;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(themeProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final uid = firebaseAuth.firebaseUser?.uid;
    final cloud = watch(cloudStorageProvider);
    return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
              builder: (context,constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(image, width: constraints.maxHeight*0.15, height: constraints.maxHeight*0.15, fit: BoxFit.contain),
                      Container(height: constraints.maxHeight*0.05),
                      Text(this.text, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center,),
                      Container(height: constraints.maxHeight*0.05, width: constraints.maxHeight*0.05, padding: EdgeInsets.all(constraints.maxHeight*0.02)),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Light), child: Text("Light")),
                      //     ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Dark), child: Text("Dark")),
                      //     ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Purple), child: Text("Purple"))
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(onPressed: test, child: Text("Print")),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(onPressed: () => upload(uid??""), child: Text("Upload")),
                      //     ElevatedButton(onPressed: () => download(uid??""), child: Text("Download")),
                      //   ],
                      // ),
                      Column(
                        children:[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(onPressed: () => uploadImage(cloud), child: Text("Upload image")),
                                Text("${((cloud.bytesTransferred/cloud.totalBytes)*100).toStringAsFixed(2)}%", style: TextStyle(color: Colors.black))
                              ]
                          ),
                          ImageHolder(imageExists: _imageExists, imageNotExists: _imageNotExists,)
                        ]
                      )
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}

class ImageHolder extends StatefulWidget {
  XFile? image = null;
  Function imageExists;
  VoidCallback imageNotExists;

  ImageHolder({Key? key, this.image,required this.imageExists, required this.imageNotExists}):super(key:key); //acccess the _image of _ImageHolderState, allow parent to access methods.
  @override
  State<StatefulWidget> createState() => ImageHolderState();
}

class ImageHolderState extends State<ImageHolder> {
  XFile? _image = null; //File _image;
  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  XFile? returnImage() {
    return _image;
  }

  Future<XFile?> getCameraImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image != null){
      setState(() {
        _image = XFile(image.path);
      });
      widget.imageExists(File(image.path));
      return XFile(image.path);
    }
    return null;
  }

  Future<XFile?> getGalleryImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = XFile(image.path);
      });
      widget.imageExists(File(image.path));
      return XFile(image.path);
    }
    return null;
  }

  Future removeImage(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 50.0,
              width: 100.0,
              child: Center(child: Text("Remove Image?")),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Yes'),
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                  widget.imageNotExists;
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
          onTap: () => _image == null ? getGalleryImage() : removeImage(context),
          child: Container(
            width: 300,
            height: 400,
            child: Center(
              //child: widget.image == null? Text("No images...") : Image.file(widget.image)
                child: _image == null
                    ? Text("Tap to add image...")
                    : Image.file(File(_image!.path))),
          ),
        ));
  }
}