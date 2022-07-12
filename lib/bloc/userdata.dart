import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'userdata.freezed.dart';
part 'userdata.g.dart';

/*
Use this command in terminal to automatically rebuild freezed/json part file:
flutter pub run build_runner watch --delete-conflicting-outputs
Use this command in terminal to rebuild freezed/json part file once:
flutter packages pub run build_runner build --delete-conflicting-outputs

Note: Must manually add build.yaml file to configure "explicit_to_json: true"
for json_serializable due to having nested dataclasses. References here:
https://github.com/rrousselGit/freezed/issues/86
*/
@freezed
abstract class Userdata with _$Userdata {
  const factory Userdata({
    required String id,
    required String name,
    required String createdAt,
    required String version,
    @Default("Light") String theme,
    @Default({}) Map<String,Folderdata> folders,
    @Default({}) Map<String,Imagedata> images,
  }) = _Userdata;
  factory Userdata.fromJson(Map<String,dynamic> json) => _$UserdataFromJson(json);
}

//imagelist initially named as "images", which is same as Userdata, but will
// cause issues when decoding from json, as both key with same name appear in
// the json data, thus renamed as "imagelist" to better reflect the datatype
// and also to workaround this issue
@freezed
abstract class Folderdata with _$Folderdata {
  const Folderdata._();

  const factory Folderdata({
    required String id,
    required String name,
    required String createdAt,
    required String updatedAt,
    @Default("") String link,
    @Default("") String description,
    @Default([]) List<String> label,  //multiple label
    @Default([]) List<String> imagelist,
  }) = _Folderdata;

  //Mapping sortable/searchable properties
  Map<String, dynamic> _toMap() {
    return {
      'name': name,
      'updatedAt': updatedAt,
      'label': label,
      'description': description,
    };
  }

  factory Folderdata.fromJson(Map<String,dynamic> json) => _$FolderdataFromJson(json);
}

@freezed
abstract class Imagedata with _$Imagedata {
  const factory Imagedata({
    required String id,
    required String name,
    required String createdAt,
    required String ext,
    @Default("") String description,
  }) = _Imagedata;
  factory Imagedata.fromJson(Map<String,dynamic> json) => _$ImagedataFromJson(json);
}