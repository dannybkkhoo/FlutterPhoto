import 'package:flutter/foundation.dart';

/*folderRecord object stores all data of a folder, able to return a map of its data*/
class folderRecord {
  String name, path, date, description, link;
  var children = [];

  folderRecord({
    @required this.name,
    @required this.path,
    @required this.date,
    this.description,
    this.link,
    this.children,
  });

  Map<String,dynamic> dat(){
    return {
      "name": name,
      "path": path,
      "date": date,
      "description": description,
      "link": link,
      "children": children,
    };
  }
}

/*imageRecord object stores all data of an image, able to return a map of its data*/
class imageRecord {
  String name, path, date, description, imageurl;

  imageRecord({
    @required this.name,
    @required this.path,
    @required this.date,
    this.description,
    @required this.imageurl,
  });

  Map<String,dynamic> dat() {
    return {
      "name": name,
      "path": path,
      "date": date,
      "description": description,
      "imageurl": imageurl,
    };
  }
}

/*For testing*/
var fold = folderRecord(
    name: "Test_2",
    path: "UID",
    date: "11/4/2020",
    description: "Testing folder",
    link: "www.testing.com"
);

var imag = imageRecord(
    name: "Test_img",
    path: "UID/Test_1",
    date: "12/4/2020",
    description: "Testing image",
    imageurl: "www.testing_img.com"
);