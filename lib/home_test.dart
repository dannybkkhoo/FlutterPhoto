import 'package:app2/strings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';
import 'images.dart';
import 'userdata.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'userdata_provider.dart';
import 'screen.dart';

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<Widget> listOfFolders = [];

  void loadfolders(){
    List<Widget> list = [];
    Map<String,Folderdata> folders = ref.read(userdataProvider).userdata?.folders??{};
    Map<String,String> foldernames = ref.read(userdataProvider).foldernames;
    for(MapEntry<String,String> folder in foldernames.entries){
      list.add(FolderItem(id: folder.key,  height: 250, width: 200));
    }
    listOfFolders = list;
  }

  @override
  void initState() {
    super.initState();
    Screen().portrait();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("2nd");
    loadfolders();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(firebaseAuthProvider);
    final uid = user.firebaseUser?.uid;
    final userdata = ref.watch(userdataProvider);
    Map<String,Folderdata> folders = userdata.userdata!.folders;
    Map<String,Imagedata> images = userdata.userdata!.images;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).backgroundColor),
        label: Text("New Folder", style: Theme.of(context).textTheme.bodyText2),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          addFolder(context, userdata);
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            final maxHeight = constraints.maxHeight;
            final maxWidth = constraints.maxWidth;
            return Container(
              height: maxHeight,
              width: maxWidth,
              child: AlignedGridView.count(
                itemCount: listOfFolders.length,
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                itemBuilder: (context, index){
                  return listOfFolders[index];
                },
              )
            );
          }
        )
      )
    );
  }
}

class FolderItem extends ConsumerWidget {
  late String _id;
  late double _height, _width;
  FolderItem({
    Key? key,
    required String id,
    required double height,
    required double width,
  }):super(key:key){
    this._id = id;
    this._height = height;
    this._width = width;
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String uid = ref.watch(userdataProvider).uid??"";
    String appDocDir = ref.watch(userdataProvider).appDocDir??"";
    Folderdata folder = ref.watch(userdataProvider.select((userdata) => userdata.folders[_id] as Folderdata));
    String foldername = folder.name;
    String imagepath = "";
    if(folder.imagelist.isEmpty){
      imagepath = "assets/images/question_mark.png";
    }
    else{
      Imagedata image = ref.watch(userdataProvider.select((userdata) => userdata.images[folder.imagelist[0]] as Imagedata));
      imagepath = appDocDir + "/" + uid + "/images/" + image.id + "." + image.ext;
    }

    return Container(
      height: _height,
      width: _width,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Card(
              elevation: 10.0,
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0)
              ),
              child: GridTile(
                header: GridTileBar(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      ),
                    )
                ),
                child: GestureDetector(
                    onLongPress: () {
                      print("Long press");
                    },
                    onTap: () {
                      print("Tap");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: constraints.maxHeight*0.8,
                          width: constraints.maxWidth*0.9,
                          color: Theme.of(context).accentColor,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13.0),
                              child: folder.imagelist.isEmpty?
                                  Image.asset(imagepath,fit: BoxFit.contain,):
                                  Image.file(File(imagepath), fit: BoxFit.contain,),
                            ),
                          )
                        ),
                        Container(
                          height: constraints.maxHeight*0.15,
                          width: constraints.maxWidth*0.9,
                          child: Center(
                            child: Text(foldername, style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        )
                      ],
                    )
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

Future<void> addFolder(BuildContext context, UserdataProvider userdata) async {
  String name = "", description = "", link = "", errormsg = "";
  bool tapped = false, validated = false;
  Map<String,String> foldernames = userdata.foldernames;
  final TextTheme hintStyle = Theme.of(context).textTheme.copyWith(
    subtitle2: TextStyle(color: Color(0xFFCCCCCC)),
  );
  final TextTheme errorStyle = Theme.of(context).textTheme.copyWith(
    subtitle2: TextStyle(color: Colors.red),
  );
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    backgroundColor: Theme.of(context).backgroundColor,
    padding: EdgeInsets.all(2.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(13.0))
    )
  );

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext showdialogContext) {
      return StatefulBuilder(
        builder: (stfulContext, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
            ),
            titlePadding: EdgeInsets.fromLTRB(9.0, 9.0, 0.0, 9.0),
            contentPadding: EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
            actionsPadding: EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
            title: Text('Add New Folder...', style: Theme.of(context).textTheme.headline6),
            content: SingleChildScrollView(
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'FOLDER NAME:',
                            labelStyle: Theme.of(context).textTheme.subtitle1,
                            hintText: 'eg. myFolder',
                            hintStyle: hintStyle.subtitle2,
                            errorText: (tapped & !validated) ? errormsg : null,
                            errorStyle: errorStyle.subtitle2,
                          ),
                          inputFormatters: [
                            //allow alphanumeric and underscore only
                            FilteringTextInputFormatter(RegExp("[a-zA-Z0-9_]"), allow: true)
                          ],
                          onChanged: (foldernameText) {
                            if (foldernames.containsValue(foldernameText)) {
                              setState((){
                                tapped = true;
                                validated = false;
                                name = foldernameText;
                                errormsg = name + " already exists";
                              });
                            }
                            else {
                              setState((){
                                tapped = true;
                                validated = true;
                                name = foldernameText;
                                errormsg = "";
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'DESCRIPTION:',
                            labelStyle: Theme.of(context).textTheme.subtitle1,
                            hintText: 'eg. Personal Photos',
                            hintStyle: hintStyle.subtitle2,
                          ),
                          onChanged: (descriptionText){
                            setState((){
                              description = descriptionText;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'LINK:',
                            labelStyle: Theme.of(context).textTheme.subtitle1,
                            hintText: 'eg. www.myFolder.com',
                            hintStyle: hintStyle.subtitle2,
                          ),
                          onChanged: (linkText){
                            setState((){
                              link = linkText;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
            ),
            actions: [
              TextButton(
                style: flatButtonStyle,
                child: Text("OK", style: Theme.of(context).textTheme.subtitle2),
                onPressed: () async {
                  if(name != "" && validated){
                    userdata.addFolder(name: name,description: description, link: link);
                    Navigator.of(context).pop(null);
                  }
                  else{
                    setState((){
                      tapped = true;
                      validated = false;
                      errormsg = "Name of folder cannot be empty!";
                    });
                  }
                },
              ),
              TextButton(
                style: flatButtonStyle,
                child: Text("Cancel", style: Theme.of(context).textTheme.subtitle2),
                onPressed: () => Navigator.of(context).pop(null),
              ),
            ]
          );
        }
      );
    }
  );
}
