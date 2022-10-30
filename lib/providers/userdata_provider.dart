import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../bloc/userdata.dart';
import '../bloc/firestore_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/strings.dart';
import 'package:random_string/random_string.dart';

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

  Future<bool> deleteFolder(String id) async {
    bool updated = false;
    _userdata!.folders.removeWhere((key, value) => key == id);
    updated = await updateLocalandFirestore();
    notifyListeners();
    return updated;
  }

  Future<bool> deleteFolders(List<String> ids ) async {
    bool updated = false;
    for (String id in ids) {
      _userdata!.folders.removeWhere((key, value) => key == id);
    }
    updated = await updateLocalandFirestore();
    notifyListeners();
    return updated;
  }

  Future<bool> addImage({required String name, required String ext, String description = ""}) async {

    return false;
  }

  Future<bool> deleteImage(String id) async {

    return false;
  }
}