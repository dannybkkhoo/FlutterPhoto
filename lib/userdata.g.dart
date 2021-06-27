// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) {
  return FolderModel(
    id: json['id'] as String,
    name: json['name'] as String,
    date: json['date'] as String,
    description: json['description'] as String,
    link: json['link'] as String,
    children: json['children'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date,
      'description': instance.description,
      'link': instance.link,
      'children': instance.children,
    };
