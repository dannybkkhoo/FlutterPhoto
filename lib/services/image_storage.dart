import 'package:app2/services/dataprovider.dart';
import 'userdata.dart';
import 'package:flutter/cupertino.dart';
import 'firestore_storage.dart';
import 'cloud_storage.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'authprovider.dart';
import 'authenticator.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ImageStorage{
  String getDate(){
    final now = DateTime.now();
    final formatter = new DateFormat('dd/MM/yyyy');
    final String date = formatter.format(now);
    print(date);
    return date;
  }

  /*Handles the processes for adding a folder*/
  void AddFolder(BuildContext context) async {
    var userData = DataProvider.of(context).userData; //get user's data
    String name = "", description = "", link = "", errormsg = "";
    bool tapped = false, validated = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState){
              return AlertDialog(
                title: Text('Add New Folder...'),
                content: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Folder Name:', hintText: 'eg. Solar',
                            errorText: (tapped&!validated) ? "$errormsg" : null,
                          ),
                          onChanged: (folder_name) {
                            if(userData.folder_list.containsValue(folder_name)){
                              setState((){
                                tapped = true;
                                name = folder_name;
                                errormsg = name + " already exists";
                                validated = false;
                              });
                            }
                            else{
                              setState((){
                                tapped = true;
                                name = folder_name;
                                errormsg = "";
                                validated = true;
                              });
                            }
                          },
                        ),
                        TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'Description:', hintText: 'eg. Bali Trip'
                            ),
                            onChanged: (description_text) {
                              setState((){
                                description = description_text;
                              });
                            }
                        ),
                        TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'Link:', hintText: 'eg. www.bali.com'
                            ),
                            onChanged: (link_text) {
                              setState((){
                                link = link_text;
                              });
                            }
                        ),
                      ]
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      if(name!=""){
                        final Authenticator auth = AuthProvider.of(context).auth;
                        var uid = await auth.getUID();
                        folderRecord folder = folderRecord(
                          folder_id: userData.generateUniqueID(),
                          name: name,
                          date: getDate(),
                          description: description,
                          link: link,
                          children: [],
                        );
                        userData.folder_list[folder.folder_id] = folder.name;
                        userData.folders['folders'].add(folder.dat());
                        print(userData.folder_list);
                        FirestoreStorage().addSubDocument("UserData",uid, "collection", "main_collection", userData.folders);
                        String path = await getPath();
                        print(path + '/' + folder.name);
                        new Directory(path + '/' + folder.name).create();
                        Navigator.of(context).pop(null);
                      }
                      else{
                        setState((){
                          tapped = true;
                          errormsg = "Name of folder cannot be empty!";
                          validated = false;
                        });
                      }
                    },
                  ),
                ],
              );
            }
          );
        }
    );
  }

  void AddImage(BuildContext context) async {
    GlobalKey<ImageHolderState> addkey = GlobalKey();
    var userData = DataProvider.of(context).userData; //get user's data
    String current_path = "folder_id";
    String name = "", description = "", errormsg = "";
    var _image;
    bool tapped = false, validated = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  title: Text('Add New Image...'),
                  content: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
//                          Center(
//                            child: Container(
//                              width: 300,
//                              height: 400,
//                              child: Center(
//                                  child: _image == null? Text("No images...") : Image.file(_image)
//                              ),
//                            ),
//                          ),
                          ImageHolder(),
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Image Name:', hintText: 'eg. Solar',
                              errorText: (tapped&!validated) ? "$errormsg" : null,
                            ),
                            onChanged: (image_name) {
                              print(image_name);
                              if(userData.image_list.containsValue(image_name)){
                                setState((){
                                  tapped = true;
                                  name = image_name;
                                  errormsg = name + " already exists";
                                  validated = false;
                                });
                              }
                              else{
                                setState((){
                                  tapped = true;
                                  name = image_name;
                                  errormsg = "";
                                  validated = true;
                                });
                              }
                            },
                          ),
                          TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Description:', hintText: 'eg. Bali Trip'
                              ),
                              onChanged: (description_text) {
                                setState((){
                                  description = description_text;
                                });
                              }
                          ),
                        ]
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () async {
                        if(name!="" && _image!=null){
                          final Authenticator auth = AuthProvider.of(context).auth;
                          var uid = await auth.getUID();
                          imageRecord image = imageRecord(
                            image_id: userData.generateUniqueID(),
                            name: name,
                            date: getDate(),
                            filepath: current_path,
                            description: description,
                          );
                          userData.image_list[image.image_id] = image.name;
                          for(Map folders in userData.folders['folders']){
                            if(folders["folder_id"] == current_path){
                              folders["children"].add(image.dat());
                              break;
                            }
                          }
                          print(userData.image_list);
                          print(userData.folders);
                          FirestoreStorage().addSubDocument("UserData",uid, "collection", "main_collection", userData.folders);
                          Navigator.of(context).pop(null);
                        }
                        else{
                          if(name==""){
                            setState((){
                              tapped = true;
                              errormsg = "Name of image cannot be empty!";
                              validated = false;
                            });
                          }
                          else if(_image==null){
                            setState((){
                              tapped = true;
                              errormsg = "Image is not selected!";
                              validated = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }
}