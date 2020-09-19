import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../authentication/authenticator.dart';
import '../authentication/authprovider.dart';
import '../local_storage/dataprovider.dart';
import '../local_storage/userdata.dart';
import '../utils.dart';
import 'cloud_storage.dart';

class ImageStorage {
  /*Handles the processes for adding a folder*/
  Future<void> AddFolder(BuildContext context) async {
    UserData userData = DataProvider.of(context).userData; //get user's data
    String name = "", description = "", link = "", errormsg = "";
    bool tapped = false, validated = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Folder...'),
              content: SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      /*Text Field for User to enter Folder Name, will check if folder name already exists*/
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Folder Name:',
                          hintText: 'eg. Solar',
                          errorText: (tapped & !validated) ? "$errormsg" : null,
                        ),
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9_]"))
                          //*Allow alphanumeric and underscore only
                        ],
                        onChanged: (folder_name) {
                          if (userData.folder_list.containsValue(folder_name)) {
                            setState(() {
                              tapped = true;
                              validated = false;
                              name = folder_name;
                              errormsg = name + " already exists";
                            });
                          } else {
                            setState(() {
                              tapped = true;
                              validated = true;
                              name = folder_name;
                              errormsg = "";
                            });
                          }
                        },
                      ),
                      /*Text Field for User to enter Description*/
                      TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                              labelText: 'Description:', hintText: 'eg. Bali Trip'),
                          onChanged: (description_text) {
                            setState(() {
                              description = description_text;
                            });
                          }),
                      /*Text Field for User to enter Link*/
                      TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                              labelText: 'Link:', hintText: 'eg. www.bali.com'),
                          onChanged: (link_text) {
                            setState(() {
                              link = link_text;
                            });
                          }),
                ]),
              ),
              actions: <Widget>[
                /*Cancel button, if user decides to cancel adding folder*/
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                /*Confirm button, if user confirmed folder name and details*/
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    if (name != "" && validated) {
                      final Authenticator auth = AuthProvider.of(context).auth;
                      String uid = await auth.getUID();
                      folderRecord folder = folderRecord(
                        folder_id: userData.generateUniqueID(),
                        name: name,
                        date: getDateTime(),
                        description: description,
                        link: link,
                        children: [],
                      );
                      userData.folder_list[folder.folder_id] = folder.name;
                      userData.folders.add(folder.dat());
                      userData.version = DateTime.now();
                      print(userData.folder_list);
                      userData.writeUserData(uid, userData);
                      createDirectory(await getLocalPath() +
                          "/" +
                          uid +
                          "/" +
                          folder.folder_id);
                      userData.writeFirestoreUserData(uid, userData);
                      Navigator.of(context).pop(null);
                    } else {
                      //if name of folder is invalid
                      setState(() {
                        tapped = true;
                        validated = false;
                        errormsg = "Name of folder cannot be empty!";
                      });
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  /*Handles the processes for adding an image to a folder*/
  Future<void> AddImage(BuildContext context, String folder_id) async {
    UserData userData = DataProvider.of(context).userData; //get user's data
    File _image = null;
    String filepath, image_id;
    String name = "", description = "", errormsg = "";
    bool tapped = false, validated = false;

    void _imageExists(File image) {
      _image = image;
    }

    void _imageNotExists() {
      _image = null;
    }

    final imageholder =
        ImageHolder(imageExists: _imageExists, imageNotExists: _imageNotExists);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Image...'),
              content: SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      imageholder, //no image at first
                      TextField(
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Image Name:',
                          hintText: 'eg. Solar',
                          errorText: (tapped & !validated) ? "$errormsg" : null,
                        ),
                        onChanged: (image_name) {
                          print(image_name);
                          if (userData.image_list.containsValue(image_name)) {
                            setState(() {
                              tapped = true;
                              name = image_name;
                              errormsg = name + " already exists";
                              validated = false;
                            });
                          } else {
                            setState(() {
                              tapped = true;
                              name = image_name;
                              errormsg = "";
                              validated = true;
                            });
                          }
                        },
                      ),
                      TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                              labelText: 'Description:', hintText: 'eg. Bali Trip'),
                          onChanged: (description_text) {
                            setState(() {
                              description = description_text;
                            });
                          }),
                ]),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () async {
                    String need = await getLocalPath();
                    print(need);
                    Navigator.of(context).pop(null);
                  },
                ),
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    if (name != "" && _image != null && validated) {
                      final Authenticator auth = AuthProvider.of(context).auth;
                      var uid = await auth.getUID();
                      image_id = userData.generateUniqueID();
                      String uidpart = uid.substring(0, 3);
                      String temp = await getTempPath();
                      File temp_image_file =
                          File("$temp/IMG_$uidpart$image_id.jpg");
                      await _image.copy(temp_image_file.path);
                      await createImageGarFile(
                          temp_image_file.path, "Flutter Photo");
                      temp_image_file.deleteSync(recursive: true);
                      imageRecord image = imageRecord(
                        image_id: image_id,
                        name: name,
                        date: getDate(),
                        filepath: folder_id,
                        description: description,
                      );
                      userData.image_list[image.image_id] = image.name;
                      for (Map folder in userData.folders) {
                        if (folder["folder_id"] == folder_id) {
                          folder["children"].add(image.dat());
                          break;
                        }
                      }
                      userData.version = DateTime.now();
                      print(userData.image_list);
                      print(userData.folders);
                      await userData.writeUserData(uid, userData);
                      await userData.writeFirestoreUserData(uid, userData);
                      createLocalThumbnail(uid, image_id, folder_id, _image);
                      CloudStorage().uploadImage(uid, image_id, _image);
                      Navigator.of(context).pop(null);
                    } else {
                      if (name == "") {
                        setState(() {
                          tapped = true;
                          errormsg = "Name of image cannot be empty!";
                          validated = false;
                        });
                      } else if (_image == null) {
                        setState(() {
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
          });
        });
  }
}
