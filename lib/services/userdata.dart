import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

/*This class holds temporary data locally to be passed on to any widget throughout the app*/
class CacheData extends InheritedWidget{
  final UserData userData;
  final ValueChanged onChange;

  CacheData({
    Key key,
    this.userData,
    this.onChange,
    Widget child,
  }): super(key:key, child:child);

  @override
  bool updateShouldNotify(CacheData oldWidget) => true;
}

/*This class stores user's data*/
/*-folder_list = {"abcdef123456:"folder_1","bcdefg234567":"folder_2"}*/
/*-image_list = {"abcdef123456":"image_1","bcdefg234567":"image_2"}*/
/*-folders = {"folders":[<Map>folderRecord_1.dat(),<Map>folderRecord_2.dat()]}*/
class UserData {
  Map<String,String> folder_list = {};
  Map<String,String> image_list = {};
  Map<String,List<Map>> folders = {"folders":[]};
  UserData(this.folder_list,this.image_list,this.folders);

  String generateUniqueID(){//Map<String,String> ID_list) {
    String ID;
    do{
      ID = randomAlphaNumeric(6);
    }while(folder_list.containsKey(ID));
    print(folder_list);
    return ID;
  }
}

/*folderRecord object stores all data of a folder, able to return a map of its data*/
class folderRecord {
  String folder_id, name, date, description, link;
  List<Map> children;

  folderRecord({
    @required this.folder_id,
    @required this.name,
    @required this.date,
    this.description = "",
    this.link = "",
    this.children = const [],
  });

  Map<String,dynamic> dat(){
    return {
      "folder_id": folder_id,
      "name": name,
      "date": date,
      "description": description,
      "link": link,
      "children": children,
    };
  }
}

/*imageRecord object stores all data of an image, able to return a map of its data*/
class imageRecord {
  String image_id, name, filepath, date, description = "";

  imageRecord({
    @required this.image_id,
    @required this.name,
    @required this.date,
    @required this.filepath,
    this.description = "",
  });

  Map<String,dynamic> dat() {
    return {
      "image_id": image_id,
      "name": name,
      "date": date,
      "filepath": filepath,
      "description": description,
    };
  }
}

/*For testing*/
var fold = folderRecord(
    folder_id: "solar123",
    name: "main_collection",
    date: "11/4/2020",
    description: "Testing folder",
    link: "www.testing.com"
);

var imag = imageRecord(
    image_id: "moonbyul321",
    name: "Test_img",
    filepath: "/Test_1",
    date: "12/4/2020",
    description: "Testing image",
);