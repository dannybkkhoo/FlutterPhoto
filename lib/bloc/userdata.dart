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
@unfreezed
abstract class Userdata with _$Userdata {
  factory Userdata({
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
@unfreezed
abstract class Folderdata with _$Folderdata {
  Folderdata._();

  //Status
  //-Monitor; to buy but not purchased yet
  //-Purchased; already paid but haven't receive
  //-Owned; paid and received
  //-For Sale; to be sold
  //-Received Sale Payment; before shipped
  //-Sold;  done receive payment and shipped

  factory Folderdata({
    required String id,
    required String name,
    required String createdAt,
    required String updatedAt,
    @Default("") String country,
    @Default("") String mintageYear,
    @Default("") String grade,
    @Default("") String serial, //110002020
    @Default("") String serialLink, //https//etc
    @Default("") String purchasePrice,  //currency set by main setting, just numerical, total price of all images
    @Default("") String purchaseDate,
    @Default("") String currentsoldprice,
    @Default("") String status, //under auction sold bought?
    @Default("") String storage,  //where it is stored
    @Default("") String populationLink, //mapped to a table/link
    @Default("") String remarks,
    @Default([]) List<String> category,
    @Default([]) List<String> imagelist,
  }) = _Folderdata;

  //Mapping sortable/searchable properties
  Map<String, dynamic> _toMap() {
    return {
      'name': name,
      'updatedAt': updatedAt,
    };
  }

  factory Folderdata.fromJson(Map<String,dynamic> json) => _$FolderdataFromJson(json);
}

@unfreezed
abstract class Imagedata with _$Imagedata {
  factory Imagedata({
    required String id,
    required String name,
    required String createdAt,
    required String ext,
    @Default("") String description,
  }) = _Imagedata;
  factory Imagedata.fromJson(Map<String,dynamic> json) => _$ImagedataFromJson(json);
}