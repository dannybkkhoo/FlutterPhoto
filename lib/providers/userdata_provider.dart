import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:app2/providers/top_level_providers.dart';
import 'package:app2/utils.dart';

import '../bloc/userdata.dart';
import '../bloc/firestore_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/strings.dart';
import 'package:random_string/random_string.dart';
import '../bloc/cloud_storage.dart';

class UserdataProvider with ChangeNotifier {
  late String? _uid;
  String? _firebasePath;
  String? _appDocDir;
  Userdata? _userdata = null;
  bool _hasRetrieved = false;
  bool _hasDownloaded = false;

  UserdataProvider(this._uid);

  String? get uid => _uid;
  String? get firebasePath => _firebasePath;
  String? get appDocDir => _appDocDir;
  Userdata? get userdata => _userdata;
  Map<String, Folderdata> get folders => _userdata?.folders??{};  //returns empty map if null
  Map<String, Imagedata> get images => _userdata?.images??{};     //returns empty map if null
  Map<String, String> get foldernames{  //returns a map of folder id:name
    Map<String, String> temp = {};
    Map<String, Folderdata> folders = _userdata?.folders??{};
    for(MapEntry<String,Folderdata> folder in folders.entries){
      temp[folder.key] = folder.value.name;
    }
    return temp;
  }
  Map<String, String> get folderids{  //returns a map of folder id:name
    Map<String, String> temp = {};
    Map<String, Folderdata> folders = _userdata?.folders??{};
    for(MapEntry<String,Folderdata> folder in folders.entries){
      temp[folder.value.name] = folder.key;
    }
    return temp;
  }
  Map<String, String> get imagenames{   //returns a map of image id:name
    Map<String, String> temp = {};
    Map<String, Imagedata> images = _userdata?.images??{};
    for(MapEntry<String,Imagedata> image in images.entries){
      temp[image.key] = image.value.name;
    }
    return temp;
  }
  Map<String, String> get imageids{   //returns a map of image id:name
    Map<String, String> temp = {};
    Map<String, Imagedata> images = _userdata?.images??{};
    for(MapEntry<String,Imagedata> image in images.entries){
      temp[image.value.name] = image.key;
    }
    return temp;
  }
  bool get hasRetrieved => _hasRetrieved;   //if retrieved userdata
  bool get hasDownloaded => _hasDownloaded; //if downloaded all image/folder
  bool get hasInitialized => _hasRetrieved&&_hasDownloaded?true:false;  //if retrieved userdata & downloaded all images already
  int get numOfFolders{
    if(_hasRetrieved && _userdata != null){
      return _userdata!.folders.length;
    }
    return 0;
  }
  int get numOfImages{
    if(_hasRetrieved && _userdata != null){
      return _userdata!.images.length;
    }
    return 0;
  }

  String foldername(String folderid){
    Map<String,Folderdata> folders = _userdata?.folders??{};
    return folders[folderid]?.name??"";
  }
  String imagename(String imageid){
    Map<String,Imagedata> images = _userdata?.images??{};
    return images[imageid]?.name??"";
  }
  Folderdata? folderData(String folderid){
    return folders[folderid];
  }
  Imagedata? imageData(String imageid){
    return images[imageid];
  }
  Map<String, Imagedata> imagesInFolder(String folderid) {
    Map<String, Imagedata> folderimages = {};
    if(folders.containsKey(folderid) && folders[folderid]!=null) {
      List<String> imagelist = folders[folderid]!.imagelist;
      for (String imageid in imagelist) {
        if(images.containsKey(imageid) && images[imageid]!=null) {
          folderimages[imageid] = images[imageid]!;
        }
      }
    }
    return folderimages;
  }
  Map<String, String> imagesNameInFolder(String folderid) {
    Map<String, String> folderimages = {};
    if(folders.containsKey(folderid) && folders[folderid]!=null) {
      List<String> imagelist = folders[folderid]!.imagelist;
      Map<String, String> imageNames = imagenames;
      for (String imageid in imagelist) {
        if(imagenames.containsKey(imageid)) {
          folderimages[imageid] = imageNames[imageid]!;
        }
      }
    }
    return folderimages;
  }

  set hasDownloaded(bool downloaded){
    _hasDownloaded = downloaded;
  }

  Future<bool> Init() async {
    if(_uid?.isEmpty ?? true)
      return false;
    _firebasePath = "${_uid}/images";
    final appDocDir = await getApplicationDocumentsDirectory();
    _appDocDir = appDocDir.path;
    late Userdata userdata;
    try{
      final Userdata? localUserdata = await readLocalUserdata();
      final Userdata? firestoreUserdata = await readFirestoreUserdata();
      if(localUserdata == null && firestoreUserdata == null){
        Userdata? tempdata = createUserdata();
        if(tempdata != null) {
          userdata = tempdata;
          await writeLocalUserdata(userdata);
          await writeFirestoreUserdata(userdata);
        }
        else {
          _hasRetrieved = true;
          notifyListeners();
          return false;
        }
      }
      else if(localUserdata != null && firestoreUserdata == null){
        await writeFirestoreUserdata(localUserdata);
        userdata = localUserdata;
      }
      else if(localUserdata == null && firestoreUserdata != null){
        await writeLocalUserdata(firestoreUserdata);
        userdata = firestoreUserdata;
      }
      else if(localUserdata != null && firestoreUserdata != null){  //same as just "else", but made it else if just for clarity of its conditions
        DateFormat dateformat = new DateFormat(Strings.dtFormat);
        final DateTime localVersion = dateformat.parse(localUserdata.version);
        final DateTime firestoreVersion = dateformat.parse(firestoreUserdata.version);
        if(localVersion.isAfter(firestoreVersion)){
          await writeFirestoreUserdata(localUserdata);
          userdata = localUserdata;
        }
        else{
          await writeLocalUserdata(firestoreUserdata);
          userdata = firestoreUserdata;
        }
      }
      _userdata = userdata;
      _hasRetrieved = true;
      notifyListeners();
      return true;
    } catch(e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Userdata? createUserdata() {
    if(_uid?.isEmpty ?? true)
      return null;
    try{
      DateFormat dateformat = new DateFormat(Strings.dtFormat);
      Userdata userdata = Userdata(
        id: _uid!, //_uid
        name: "",
        createdAt: dateformat.format(DateTime.now()).toString(),
        version: dateformat.format(DateTime.now()).toString(),
      );
      print("New user data created");
      return userdata;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> setUserdata(Userdata? userdata) async {  //temporary setter (until actual async setters exists in flutter)
    if(userdata == null)
      return false;
    _userdata = userdata;
    try {
      await writeLocalUserdata(userdata);
      await writeFirestoreUserdata(userdata);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> writeLocalUserdata(Userdata userdata) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String userdata_path = "${appDocDir.path}/${_uid}/userdata/userdata.json";
    File userdata_file = File(userdata_path);
    userdata_file.createSync(recursive:true);
    try {
      final String userdata_contents = await jsonEncode(userdata.toJson());
      userdata_file.writeAsString(userdata_contents);
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> writeFirestoreUserdata(Userdata userdata) async {
    final FirestoreStorage firestorestorage = FirestoreStorage();
    if (_uid?.isEmpty ?? true)
      return false;
    try{
      final Map<String,dynamic> userdata_contents = userdata.toJson();
      firestorestorage.writeData("Userdata", _uid!, "collection", "main_collection", userdata_contents);
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<Userdata?> readLocalUserdata() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String userdata_path = "${appDocDir.path}/${_uid}/userdata/userdata.json";
    File userdata_file = File(userdata_path);
    try {
      if(await userdata_file.exists()){ //if userdata file exists, then read it
        final String userdata_contents = await userdata_file.readAsString();     //read as string
        final Userdata userdata = Userdata.fromJson(jsonDecode(userdata_contents));//decode string as json, then generate Userdata object from json data
        return userdata;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<Userdata?> readFirestoreUserdata() async {
    final FirestoreStorage firestorestorage = FirestoreStorage();
    if (_uid?.isEmpty ?? true)
      return null;
    try {
      final userdata_contents = await firestorestorage.readData("Userdata", _uid!, "collection", "main_collection");  //returns in Json form
      if(userdata_contents != null){
        final Userdata userdata = Userdata.fromJson(userdata_contents); //convert to Userdata class
        return userdata;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<bool> deleteLocalUserdata() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String userdata_path = "${appDocDir.path}/${_uid}/userdata/userdata.json";
    File userdata_file = File(userdata_path);
    if(!await userdata_file.exists())
      return false;
    try {
      await userdata_file.delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteFirestoreUserdata() async {
    final FirestoreStorage firestorestorage = FirestoreStorage();
    if (_uid?.isEmpty ?? true)
      return false;
    try {
      return await firestorestorage.deleteData("Userdata", _uid!, "collection", "main_collection");
    } catch (e) {
      print(e);
      return false;
    }
  }

  String firstImageInFolder(String folderid){
    String imageid = folders[folderid]?.imagelist.first??"";
    return imageid;
  }

  String generateUniqueID(Map map){
    String id;
    do{
      id = randomAlphaNumeric(6);
    }while(map.containsKey(id));
    return id;
  }

  Future<bool> updateLocalandFirestore() async{
    bool localUpdated = false;
    bool firestoreUpdated = false;
    if(_userdata != null) {
      localUpdated = await writeLocalUserdata(_userdata as Userdata);
      firestoreUpdated = await writeFirestoreUserdata(_userdata as Userdata);
    }
    return localUpdated && firestoreUpdated;
  }

  //Originally was supposed to use this function to add folder, but later used addFolderData instead to directly store the whole Folderdata object
  Future<bool> addFolder({
    required String name,
    String countrygroup = "",
    String countrytype = "",
    String denomination = "",
    String mintageYear = "",
    String grade = "",
    String serial = "",
    String serialLink = "",
    String purchasePrice = "",
    String purchaseDate = "",
    String currentsoldprice = "",
    String solddate = "",
    String status = "",
    String storage = "",
    String populationLink = "",
    String remarks = "",
    List<String> category = const [],
    List<String> imageList = const []
  }) async {
    bool updated = false;
    String id = generateUniqueID(folders);
    Folderdata folder = Folderdata(
      id : id,
      name : name,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      countrygroup: countrygroup,
      countrytype: countrytype,
      mintageYear: mintageYear,
      grade: grade,
      serial: serial,
      serialLink: serialLink,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
      currentsoldprice: currentsoldprice,
      solddate: solddate,
      status: status,
      storage: storage,
      populationLink: populationLink,
      remarks: remarks,
      category: category,
      imagelist: imageList,
    );
    _userdata!.folders[id] = folder;
    updated = await updateLocalandFirestore();
    notifyListeners();
    return updated;
  }

  Future<bool> addFolderdata(Folderdata newFolder) async {
    bool updated = false;
    newFolder.id = generateUniqueID(folders);
    _userdata!.folders[newFolder.id] = newFolder;
    updated = await updateLocalandFirestore();
    notifyListeners();
    return updated;
  }

  Future<bool> replaceFolderdata(Folderdata newFolder) async {
    bool updated = false;
    _userdata!.folders[newFolder.id] = newFolder;
    updated = await updateLocalandFirestore();
    notifyListeners();
    return updated;
  }

  Future<bool> deleteFolder({required CloudStorageProvider cloudStorageProvider, required String folderid}) async {
    bool updated = false;

    if(_userdata!.folders.containsKey(folderid)) {  //check if folder exists
      List<String> imageids = _userdata!.folders[folderid]!.imagelist;  //get list of images in the folder
      if(imageids.isNotEmpty) {
        if(!await deleteImages(cloudStorageProvider: cloudStorageProvider, folderid: folderid, imageids: imageids)) { //delete the images in the folder first
          return updated; //if failed to delete all images, then won't delete the folder, and return false
        }
      }
      _userdata!.folders.removeWhere((key, value) => key == folderid);  //delete the folder data
      updated = await updateLocalandFirestore();
      notifyListeners();
    }
    return updated;
  }

  Future<bool> deleteFolders({required CloudStorageProvider cloudStorageProvider, required List<String> folderids}) async {
    bool updated = false;
    int deleted = 0;

    for (String folderid in folderids) {
      if(_userdata!.folders.containsKey(folderid)) {  //check if folder exists
        List<String> imageids = _userdata!.folders[folderid]!.imagelist;  //get list of images in the folder
        List<String> tempid = List.from(imageids);
        if(imageids.isNotEmpty) {
          if(!await deleteImages(cloudStorageProvider: cloudStorageProvider, folderid: folderid, imageids: tempid)) { //delete the images in the folder first
            continue; //if failed to delete all images in the folder, then skip this folder and continue next folder
          }
        }
        _userdata!.folders.removeWhere((key, value) => key == folderid);  //delete the folder data
        deleted++;
      }
    }

    //update the local and firestore userdata and check if all given folderids are deleted
    if(deleted > 0) {
      if(await updateLocalandFirestore() && deleted == folderids.length) {
        updated = true;
      }
      notifyListeners();
    }
    return updated;
  }

  Future<bool> addImage({required CloudStorageProvider cloudStorageProvider, required File imageFile, required String folderid, required String name, String description = ""}) async {
    bool updated = false;

    //Check if the given folderid is an existing folder
    if(_userdata!.folders.containsKey(folderid)) {
      String id = generateUniqueID(images);

      //upload the image file to cloud storage then store local first (at userid/images/imageid)
      if(_firebasePath != null){
        final bool uploadSuccess = await cloudStorageProvider.uploadImage("${_firebasePath}/${id}", imageFile, sync: true)??false;
        if(uploadSuccess) {
          //store local then upload the image data to firestore if image file successfully stored
          Imagedata image = Imagedata(
            id: id,
            name: name,
            createdAt: DateTime.now().toString(),
            ext: getFileExtension(imageFile),
            description: description,
          );
          List<String> tempImageList = _userdata!.folders[folderid]!.imagelist.toList();
          tempImageList.add(id);
          _userdata!.folders[folderid]!.imagelist = tempImageList;
          _userdata!.images[id] = image;
          updated = await updateLocalandFirestore();
          notifyListeners();
          updated = true;
        }
      }
    }
    return updated;
  }

  Future<bool> deleteImage({required CloudStorageProvider cloudStorageProvider, required String folderid, required String imageid}) async {
    bool updated = false;

    //Check if the given folderid is an existing folder
    if(_userdata!.folders.containsKey(folderid)) {

      //remove/delete the image file from cloud storage then delete from local storage first (at userid/images/imageid)
      if(_firebasePath != null) {
        final bool deleteSuccess = await cloudStorageProvider.deleteImage("${_firebasePath}/${imageid}", sync: true)??false;
        if(deleteSuccess) {
          //delete local and firestore data of the image if successfully deleted image file
          _userdata!.folders[folderid]!.imagelist.remove(imageid);
          _userdata!.images.removeWhere((key, value) => key == imageid);
          updated = await updateLocalandFirestore();
          notifyListeners();
        }
      }
    }
    return updated;
  }

  Future<bool> deleteImages({required CloudStorageProvider cloudStorageProvider, required String folderid, required List<String> imageids}) async {
    bool updated = false;
    int deleted = 0;

    //Check if the given folderid is an existing folder
    if(_userdata!.folders.containsKey(folderid)) {

      //remove/delete the image file from cloud storage then delete from local storage first (at userid/images/imageid)
      if(_firebasePath != null) {

        //remove each image one by one
        for (final String imageid in imageids) {
          //delete the image file on local and cloud firebase first
          final bool deleteSuccess = await cloudStorageProvider.deleteImage("${_firebasePath}/${imageid}", sync: true)??false;
          //delete local and firestore data of the image if successfully deleted image file
          if(deleteSuccess) {
            _userdata!.folders[folderid]!.imagelist.remove(imageid);
            _userdata!.images.removeWhere((key, value) => key == imageid);
            deleted++;
          }
        }

        //update the local and firestore userdata, and check if all given imageids are deleted
        if(deleted > 0) {
          if(await updateLocalandFirestore() && deleted == imageids.length) {
            updated = true;
          }
          notifyListeners();
        }
      }
    }
    return updated;
  }
}