// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    DateTime.parse(json['version'] as String),
    json['folder_list'] as Map<String, dynamic>,
    json['image_list'] as Map<String, dynamic>,
    json['folders'] as List,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'version': instance.version.toIso8601String(),
      'folder_list': instance.folder_list,
      'image_list': instance.image_list,
      'folders': instance.folders,
    };
