import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'userdata.g.dart';
/*
Use the terminal command below to generate the userdata.g.dart automatically
flutter packages pub run build_runner build
 */

@JsonSerializable()
class UserData extends Equatable {
  
}

@JsonSerializable()
class FolderModel extends Equatable {
  final String id, name, date, description, link;
  final Map<String,dynamic> children;

  FolderModel({
    required this.id,
    required this.name,
    required this.date,
    this.description = "",
    this.link = "",
    this.children = const {}
  });

  @override
  bool get stringify => true; //enable toString method for this class, eg. returns data of each field in string instead of "Instance of Foldermodel" when toString is called

  @override
  List<Object> get props => [id, name, date, description, link, children];  //get all properties easily for this class

  //easily copy over parameters and create new instance of object, while overriding specific parameter
  FolderModel copyWith({String? id, String? name, String? date, String? description, String? link, Map<String,dynamic>? children,})
  => FolderModel(id:id??this.id,name:name??this.name,date:date??this.date,description:description??this.description,link:link??this.link,children:children??this.children);
}

@JsonSerializable()
class ImageModel extends Equatable {
  final String id, name, date, filepath, description;

  ImageModel({
    required this.id,
    required this.name,
    required this.date,
    required this.filepath,
    this.description = ""
  });

  @override
  bool get stringify => true; //enable toString method for this class

  @override
  List<Object> get props => [id,name,date,filepath,description];  //get all properties easily for this class

  //easily copy over parameters and create new instance of object, while overriding specific parameter
  ImageModel copyWith({String? id, String? name, String? date, String? filepath, String? description})
  => ImageModel(id:id??this.id,name:name??this.name,date:date??this.date,filepath:filepath??this.filepath,description:description??this.description);
}