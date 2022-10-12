// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Userdata _$$_UserdataFromJson(Map<String, dynamic> json) => _$_Userdata(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      version: json['version'] as String,
      theme: json['theme'] as String? ?? "Light",
      folders: (json['folders'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, Folderdata.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      images: (json['images'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, Imagedata.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$_UserdataToJson(_$_Userdata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'version': instance.version,
      'theme': instance.theme,
      'folders': instance.folders.map((k, e) => MapEntry(k, e.toJson())),
      'images': instance.images.map((k, e) => MapEntry(k, e.toJson())),
    };

_$_Folderdata _$$_FolderdataFromJson(Map<String, dynamic> json) =>
    _$_Folderdata(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      countrygroup: json['countrygroup'] as String? ?? "",
      countrytype: json['countrytype'] as String? ?? "",
      denomination: json['denomination'] as String? ?? "",
      mintageYear: json['mintageYear'] as String? ?? "",
      grade: json['grade'] as String? ?? "",
      serial: json['serial'] as String? ?? "",
      serialLink: json['serialLink'] as String? ?? "",
      purchasePrice: json['purchasePrice'] as String? ?? "",
      purchaseDate: json['purchaseDate'] as String? ?? "",
      currentsoldprice: json['currentsoldprice'] as String? ?? "",
      solddate: json['solddate'] as String? ?? "",
      status: json['status'] as String? ?? "",
      storage: json['storage'] as String? ?? "",
      populationLink: json['populationLink'] as String? ?? "",
      remarks: json['remarks'] as String? ?? "",
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      imagelist: (json['imagelist'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_FolderdataToJson(_$_Folderdata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'countrygroup': instance.countrygroup,
      'countrytype': instance.countrytype,
      'denomination': instance.denomination,
      'mintageYear': instance.mintageYear,
      'grade': instance.grade,
      'serial': instance.serial,
      'serialLink': instance.serialLink,
      'purchasePrice': instance.purchasePrice,
      'purchaseDate': instance.purchaseDate,
      'currentsoldprice': instance.currentsoldprice,
      'solddate': instance.solddate,
      'status': instance.status,
      'storage': instance.storage,
      'populationLink': instance.populationLink,
      'remarks': instance.remarks,
      'category': instance.category,
      'imagelist': instance.imagelist,
    };

_$_Imagedata _$$_ImagedataFromJson(Map<String, dynamic> json) => _$_Imagedata(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      ext: json['ext'] as String,
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$$_ImagedataToJson(_$_Imagedata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'ext': instance.ext,
      'description': instance.description,
    };
