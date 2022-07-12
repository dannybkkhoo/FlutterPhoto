import 'package:app2/themes/themes.dart';
import 'package:flutter/material.dart';
import 'bloc/screen.dart';
import 'constants/images.dart';
import 'constants/strings.dart';
import 'providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/top_level_providers.dart';
import 'bloc/userdata.dart';
import 'bloc/firestore_storage.dart';
import 'bloc/cloud_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class DebugPage extends ConsumerWidget {
  late String text;
  late String image;
  DebugPage({Key? key, this.text = Strings.defaultError, this.image = Images.defaultError}) : super(key:key) {Screen().portrait();}

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
    name: "testing",
    ext: "jpg",
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
    await FirestoreStorage().writeData("Userdata", uid, "collection", "main_collection", data);
  }

  void download(String uid) async {
    final data = await FirestoreStorage().readData("Userdata", uid, "collection", "main_collection");
    if(data != null){
      final deserial = Userdata.fromJson(data);
      print("Data is:\n${deserial}");
    }
  }

  File? _image = null;

  void uploadImage(CloudStorageProvider ref, String firebasePath,String uid) async {
    final userz = user.copyWith(folders:{fold.id:fold},images: {imag.id:imag});
    final data = userz.toJson();
    await FirestoreStorage().writeData("Userdata", uid, "collection", "main_collection", data);
    if(_image != null)
      ref.uploadImage("${firebasePath}/testing.jpg", _image!);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final firebaseAuth = ref.read(firebaseAuthProvider);
    final uid = firebaseAuth.firebaseUser?.uid;
    final cloud = ref.watch(cloudStorageProvider);
    final userdata = ref.read(userdataProvider);
    String firebasePath = userdata.firebasePath!;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Light), child: Text("Light")),
                          ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Dark), child: Text("Dark")),
                          ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Purple), child: Text("Purple"))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () => userdata.deleteLocalUserdata(), child: Text("Delete"))
                          //ElevatedButton(onPressed: () => upload(uid??""), child: Text("Upload")),
                          //ElevatedButton(onPressed: () => download(uid??""), child: Text("Download")),
                        ],
                      ),
                      Column(
                        children:[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(onPressed: () => uploadImage(cloud,userdata.firebasePath!,uid!), child: Text("Upload image")),
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

class DebugPage2 extends ConsumerWidget {
  File? _image;

  void uploadImage(CloudStorageProvider ref) async {
    if(_image != null)
      ref.uploadImage("123/photos/testing2", _image!);
    else
      print("Null image");
  }

  void downloadImage(CloudStorageProvider ref) async {
    _image = null;
    await ref.downloadImage("123/photos/testing2");
  }

  void _imageExists(File image) {
    _image = image;
  }

  void _imageNotExists() {
    _image = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final firebaseAuth = ref.read(firebaseAuthProvider);
    final uid = firebaseAuth.firebaseUser?.uid;
    final cloud = ref.watch(cloudStorageProvider);
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
                      Container(height: constraints.maxHeight*0.05, width: constraints.maxHeight*0.05, padding: EdgeInsets.all(constraints.maxHeight*0.02)),
                      Column(
                        children:[
                          ImageHolder(imageExists: _imageExists, imageNotExists: _imageNotExists, height: constraints.maxHeight*0.3, width: constraints.maxHeight*0.15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(onPressed: () => uploadImage(cloud), child: Text("Upload image")),
                                  ElevatedButton(onPressed: () => downloadImage(cloud),child: Text("Download image"))
                                ],
                              )
                            ]
                          ),
                          if(cloud.isUploading)
                            if(cloud.uploadMap.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...cloud.uploadMap.entries.map((item) => taskBox.upload(taskName: item.key, task: item.value, ref: cloud)).toList(),
                                ]
                              )
                          ,
                          if(cloud.isDownloading)
                            if(cloud.downloadMap.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                ...cloud.downloadMap.entries.map((item) => taskBox.download(taskName: item.key, task: item.value, ref: cloud)).toList(),
                                ]
                              )
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
  double height;
  double width;

  ImageHolder({Key? key, this.image,required this.imageExists, required this.imageNotExists, this.height = 400, this.width = 300}):super(key:key); //acccess the _image of _ImageHolderState, allow parent to access methods.
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
            width: widget.width,
            height: widget.height,
            child: Center(
              //child: widget.image == null? Text("No images...") : Image.file(widget.image)
                child: _image == null
                    ? Text("Tap to add image...")
                    : Image.file(File(_image!.path))),
          ),
        ));
  }
}