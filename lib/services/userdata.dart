import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';
import 'package:app2/services/utils.dart';
import 'package:app2/services/firestore_storage.dart';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'userdata.g.dart';

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
/*Note: for Json Serializing of UserData class, use the commands below to...*/
/*-Start watcher to automatically generate Json code*/
/* "flutter pub run build_runner watch" */
/*-One time Json code generation*/
/* "flutter pub run build_runner build" */
@JsonSerializable(nullable: false)
class UserData {
//  Map<String,String> folder_list = {};
//  Map<String,String> image_list = {};
//  Map<String,List<Map>> folders = {"folders":[]};
  DateTime version = getDefaultDate();
  Map<String,dynamic> folder_list = {};
  Map<String,dynamic> image_list = {};
  List<dynamic> folders = [];
  UserData(this.version, this.folder_list,this.image_list,this.folders);

  factory UserData.fromJson(Map<String,dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  String generateUniqueID(){//Map<String,String> ID_list) {
    String ID;
    do{
      ID = randomAlphaNumeric(6);
    }while(folder_list.containsKey(ID));
    print(folder_list);
    return ID;
  }

  Future<UserData> loadLatestUserData(String uid) async {
    UserData local_data = await getLocalUserData(uid);
    UserData firestore_data = await getFirestoreUserData(uid);
    if(firestore_data == null || local_data == null){
      return null;   //to signify failure to obtain either firestore_data or local_data, retry to get data
    }
    else if(firestore_data.version.isAfter(local_data.version)) { //if firestore data is the latest version
      setUserDatatoFirestore(uid, firestore_data);
    }
    else if(firestore_data.version.isAtSameMomentAs(local_data.version)) { //otherwise, local data is latest, or firestore and local data are same
      version = local_data.version;
      folder_list = local_data.folder_list;
      image_list = local_data.image_list;
      folders = local_data.folders;
      print("Local Data is same as Firebase Data.");
    }
    else if(firestore_data.version.isBefore(local_data.version)){
      setUserDatatoLocal(uid, local_data);
    }
    var test = await getLocalUserData(uid);
    print(test.version);
    return UserData(version,folder_list,image_list,folders);
  }

  Future<void> setUserDatatoLocal(String uid, UserData local_data) async{
    version = local_data.version;
    folder_list = local_data.folder_list;
    image_list = local_data.image_list;
    folders = local_data.folders;
    await writeFirestoreUserData(uid, local_data);
    print("Synced to Local Data");
  }

  Future<void> setUserDatatoFirestore(String uid, UserData firestore_data) async {
    version = firestore_data.version;
    folder_list = firestore_data.folder_list;
    image_list = firestore_data.image_list;
    folders = firestore_data.folders;
    await writeUserData(uid, firestore_data);
    print("Synced to Firebase Data");
  }

  Future<UserData> getFirestoreUserData(String uid) async {
    List<Map> rawdata = await FirestoreStorage().getSubCollectionData('UserData', uid, 'collection')
        .catchError( (e) {  //if connection error or any other errors and user data is unavailable
      print("Failed to get user data from firestore.\n");
      print("Error:$e");
      return null;
    }); //gets all documents in the user collection
    if (rawdata != null) {  //if user collection exists, or is not empty (documents exists)
      return await readFirestoreUserData(uid, rawdata);
    }
    else{
      return await createFirestoreUserData(uid);
    }
  }

  Future<UserData> readFirestoreUserData(String uid, List rawdata) async {
    DateTime version = getDefaultDate();
    Map<String,dynamic> folder_list = {};
    Map<String,dynamic> image_list = {};
    List<dynamic> folders = [];
    rawdata.forEach((document) {  //for each seperate document retrieved,
      if(document.containsKey('version')){  //find the version among the documents, should only exist inside main document
        if(document['version'] == null){  //if cant find version
          version = getDefaultDate();
        }
        else{
          version = DateTime.parse(document['version']);
        }
      }
      if(document['folders'] != null){   //check if the document is empty, will be empty list if no files inside
        folders.addAll(document['folders']); //combine all data from multiple collection
      }
    });
    if(folders != null){  //check if any folders exist in user's collection
      folders.forEach((folder) {
        folder_list[folder['folder_id']] = folder['name']; //form folder_list to track folder_id and folder_names
        if(folder['children'] != null){  //check if there are any images in that folder
          folder['children'].forEach((image) {
            image_list[image['image_id']] = image['name'];  //form image_list to track image_id and image_names
          });
        }
      });
    }
    //print(version);
    //print(folder_list);
    //print(image_list);
    //print(folders);
    UserData userData = UserData(version,folder_list,image_list,folders);
    return userData;
  }

  Future<void> writeFirestoreUserData(String uid, UserData userData) async {
    await FirestoreStorage().addSubDocument("UserData", uid, "collection", "main_collection", {"folders":userData.folders, "version":userData.version.toString()});
    print("Firebase User Data updated.");
  }

  Future<void> deleteFirestoreUserData(String uid) async {
    await FirestoreStorage().deleteSubCollection('UserData',uid,'collection');
  }

  Future<UserData> createFirestoreUserData(String uid) async {
    await FirestoreStorage().addSubDocument("UserData", uid, "collection", "main_collection", {"folders":[],"version":getDefaultDate().toString()});
    return UserData(getDefaultDate(),{},{},[]);
  }

  Future<UserData> getLocalUserData(String uid) async {
    //Check if user folder exists in local directory
    final file_path = await getLocalPath() + "/" + uid;
    final userdata_path = file_path + "/" + "userdata.json";
    final Directory user_directory = Directory(file_path);
    try {
      if (await user_directory.exists()) {
        File userdata_file = File(userdata_path);
        print("USERDATA Folder Exists!");
        if (await userdata_file.exists()) {
          print("USERDATA JSON Exists!");
          return await readUserData(uid);
        }
        else {
          print("USERDATA JSON does not exist");
          await createUserData(uid);
          return UserData(getDefaultDate(), {}, {}, []); //null version
        }
      }
      else {
        print("USERDATA Folder does not exist");
        await createUserFile(uid);
        return UserData(getDefaultDate(), {}, {}, []); //null version
      }
    }
    catch (e){  //if errors occured when retrieving user data
      print("Failed to get user data from local storage.");
      print("Error:$e");
      return null;
    };
  }

  Future<UserData> readUserData(String uid) async {
    final String file_path = await getLocalPath() + "/" + uid;
    final String userdata_path = file_path + "/" + "userdata.json";
    final File userdata_file = File(userdata_path);
    Map rawdata = json.decode(userdata_file.readAsStringSync());
    UserData userData = UserData(DateTime.parse(rawdata['version']),rawdata['folder_list'],rawdata['image_list'],rawdata['folders']);
    //print(rawdata);
    return userData;
  }

  Future<void> writeUserData(String uid, UserData userData) async {
    final String file_path = await getLocalPath() + "/" + uid;
    final String userdata_path = file_path + "/" + "userdata.json";
    await createDirectory(file_path); //check if user folder exists, if not, create files
    final File userdata_file = File(userdata_path);
    await userdata_file.writeAsString(json.encode(userData));
    print("Local User Data updated.");
  }

  Future<void> deleteUserData(String uid) async {
    final String file_path = await getLocalPath() + "/" + uid;
    final String userdata_path = file_path + "/" + "userdata.json";
    await deleteFile(userdata_path);
    print("User data deleted");
  }

  Future<void> deleteUserFile(String uid) async {
    final String file_path = await getLocalPath() + "/" + uid;
    await deleteDirectory(file_path);
  }

  Future<void> createUserData(String uid) async {
    final String file_path = await getLocalPath() + "/" + uid;
    final String userdata_path = file_path + "/" + "userdata.json";
    final File userdata_file = File(userdata_path);
    final UserData userData = UserData(getDefaultDate(),{},{},[]);  //null version
    await userdata_file.writeAsString(json.encode(userData));
    print("User Data created.");
  }

  Future<void> createUserFile(String uid) async {
    final String file_path = await getLocalPath() + "/" + uid;
    await createDirectory(file_path);
    createUserData(uid);
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
    link: "www.testing.com",
);

var imag = imageRecord(
    image_id: "moonbyul321",
    name: "Test_img",
    date: "12/4/2020",
    filepath: "/Test_1",
    description: "Testing image",
);