import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'userdata.dart';
import 'firestore_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserdataProvider with ChangeNotifier {
  late String? _uid;
  late String _userdata_path;
  Userdata? _userdata = null;

  UserdataProvider(this._uid);

  String? get uid => _uid;
  String? get userdata_path => _userdata_path;
  Userdata? get userdata => _userdata;
  Folderdata? get folders => userdata.folders;  //getter setter

  Future<bool> Bootstrap() async {
    try{
      final Userdata? localUserdata = await readLocalUserdata();
      final Userdata? firestoreUserdata = await readFirestoreUserdata();
      if(localUserdata == null && firestoreUserdata == null){
        Userdata userdata = createUserdata();
        await writeLocalUserdata(userdata);
        await writeFirestoreUserdata(userdata);
      }
      else if(localUserdata != null && firestoreUserdata == null){
        await writeFirestoreUserdata(localUserdata);
      }
      else if(localUserdata == null && firestoreUserdata != null){
        await writeLocalUserdata(firestoreUserdata);
      }
      else if(localUserdata != null && firestoreUserdata != null){  //same as just "else", but made it else if just for clarity of its conditions
        DateFormat dateformat = new DateFormat("dd/MM/yyyy HH:mm:ss");
        final DateTime localVersion = dateformat.parse(localUserdata.version);
        final DateTime firestoreVersion = dateformat.parse(firestoreUserdata.version);
        if(localVersion.isAfter(firestoreVersion)){
          await writeFirestoreUserdata(localUserdata);
        }
        else{
          await writeLocalUserdata(firestoreUserdata);
        }
      }
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Userdata createUserdata() {
    DateFormat dateformat = new DateFormat("dd/MM/yyyy HH:mm:ss");
    Userdata userdata = Userdata(
      id: _uid,
      name: "",
      createdAt: dateformat.format(DateTime.now()).toString(),
      version: dateformat.format(DateTime.now()).toString(),
    );
    return userdata;
  }

  Future<bool> setUserdata(Userdata? userdata) async {  //temporary setter (until actual async setters exists in flutter)
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
    try{
      final Map<String,dynamic> userdata_contents = userdata.toJson();
      firestorestorage.writeData("Userdata", _uid, "collection", "main_collection", userdata_contents);
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
    try {
      final userdata_contents = await firestorestorage.readData("Userdata", _uid, "collection", "main_collection");  //returns in Json form
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
}