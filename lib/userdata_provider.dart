import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'userdata.dart';
import 'firestore_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'strings.dart';

class UserdataProvider with ChangeNotifier {
  late String? _uid;
  String? _firebasePath;
  Userdata? _userdata = null;
  bool _hasRetrieved = false;
  bool _hasDownloaded = false;

  UserdataProvider(this._uid);

  String? get uid => _uid;
  String? get firebasePath => _firebasePath;
  Userdata? get userdata => _userdata;
  //Folderdata? get folders => _userdata.folders;  //getter setter
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

  set hasDownloaded(bool downloaded){
    _hasDownloaded = downloaded;
  }

  Future<bool> Init() async {
    if(_uid?.isEmpty ?? true)
      return false;
    _firebasePath = "${_uid}/images";
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
}