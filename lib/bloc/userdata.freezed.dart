// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'userdata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Userdata _$UserdataFromJson(Map<String, dynamic> json) {
  return _Userdata.fromJson(json);
}

/// @nodoc
mixin _$Userdata {
  String get id => throw _privateConstructorUsedError;
  set id(String value) => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  set name(String value) => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  set createdAt(String value) => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  set version(String value) => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  set theme(String value) => throw _privateConstructorUsedError;
  Map<String, Folderdata> get folders => throw _privateConstructorUsedError;
  set folders(Map<String, Folderdata> value) =>
      throw _privateConstructorUsedError;
  Map<String, Imagedata> get images => throw _privateConstructorUsedError;
  set images(Map<String, Imagedata> value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserdataCopyWith<Userdata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserdataCopyWith<$Res> {
  factory $UserdataCopyWith(Userdata value, $Res Function(Userdata) then) =
      _$UserdataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String createdAt,
      String version,
      String theme,
      Map<String, Folderdata> folders,
      Map<String, Imagedata> images});
}

/// @nodoc
class _$UserdataCopyWithImpl<$Res> implements $UserdataCopyWith<$Res> {
  _$UserdataCopyWithImpl(this._value, this._then);

  final Userdata _value;
  // ignore: unused_field
  final $Res Function(Userdata) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? version = freezed,
    Object? theme = freezed,
    Object? folders = freezed,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      version: version == freezed
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      folders: folders == freezed
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as Map<String, Folderdata>,
      images: images == freezed
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as Map<String, Imagedata>,
    ));
  }
}

/// @nodoc
abstract class _$$_UserdataCopyWith<$Res> implements $UserdataCopyWith<$Res> {
  factory _$$_UserdataCopyWith(
          _$_Userdata value, $Res Function(_$_Userdata) then) =
      __$$_UserdataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String createdAt,
      String version,
      String theme,
      Map<String, Folderdata> folders,
      Map<String, Imagedata> images});
}

/// @nodoc
class __$$_UserdataCopyWithImpl<$Res> extends _$UserdataCopyWithImpl<$Res>
    implements _$$_UserdataCopyWith<$Res> {
  __$$_UserdataCopyWithImpl(
      _$_Userdata _value, $Res Function(_$_Userdata) _then)
      : super(_value, (v) => _then(v as _$_Userdata));

  @override
  _$_Userdata get _value => super._value as _$_Userdata;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? version = freezed,
    Object? theme = freezed,
    Object? folders = freezed,
    Object? images = freezed,
  }) {
    return _then(_$_Userdata(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      version: version == freezed
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      folders: folders == freezed
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as Map<String, Folderdata>,
      images: images == freezed
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as Map<String, Imagedata>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Userdata implements _Userdata {
  _$_Userdata(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.version,
      this.theme = "Light",
      this.folders = const {},
      this.images = const {}});

  factory _$_Userdata.fromJson(Map<String, dynamic> json) =>
      _$$_UserdataFromJson(json);

  @override
  String id;
  @override
  String name;
  @override
  String createdAt;
  @override
  String version;
  @override
  @JsonKey()
  String theme;
  @override
  @JsonKey()
  Map<String, Folderdata> folders;
  @override
  @JsonKey()
  Map<String, Imagedata> images;

  @override
  String toString() {
    return 'Userdata(id: $id, name: $name, createdAt: $createdAt, version: $version, theme: $theme, folders: $folders, images: $images)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_UserdataCopyWith<_$_Userdata> get copyWith =>
      __$$_UserdataCopyWithImpl<_$_Userdata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserdataToJson(
      this,
    );
  }
}

abstract class _Userdata implements Userdata {
  factory _Userdata(
      {required String id,
      required String name,
      required String createdAt,
      required String version,
      String theme,
      Map<String, Folderdata> folders,
      Map<String, Imagedata> images}) = _$_Userdata;

  factory _Userdata.fromJson(Map<String, dynamic> json) = _$_Userdata.fromJson;

  @override
  String get id;
  set id(String value);
  @override
  String get name;
  set name(String value);
  @override
  String get createdAt;
  set createdAt(String value);
  @override
  String get version;
  set version(String value);
  @override
  String get theme;
  set theme(String value);
  @override
  Map<String, Folderdata> get folders;
  set folders(Map<String, Folderdata> value);
  @override
  Map<String, Imagedata> get images;
  set images(Map<String, Imagedata> value);
  @override
  @JsonKey(ignore: true)
  _$$_UserdataCopyWith<_$_Userdata> get copyWith =>
      throw _privateConstructorUsedError;
}

Folderdata _$FolderdataFromJson(Map<String, dynamic> json) {
  return _Folderdata.fromJson(json);
}

/// @nodoc
mixin _$Folderdata {
  String get id => throw _privateConstructorUsedError;
  set id(String value) => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  set name(String value) => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  set createdAt(String value) => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  set updatedAt(String value) => throw _privateConstructorUsedError;
  String get countrygroup => throw _privateConstructorUsedError;
  set countrygroup(String value) => throw _privateConstructorUsedError;
  String get countrytype => throw _privateConstructorUsedError;
  set countrytype(String value) => throw _privateConstructorUsedError;
  String get denomination => throw _privateConstructorUsedError;
  set denomination(String value) => throw _privateConstructorUsedError;
  String get mintageYear => throw _privateConstructorUsedError;
  set mintageYear(String value) => throw _privateConstructorUsedError;
  String get grade => throw _privateConstructorUsedError;
  set grade(String value) => throw _privateConstructorUsedError;
  String get serial => throw _privateConstructorUsedError;
  set serial(String value) => throw _privateConstructorUsedError; //110002020
  String get serialLink => throw _privateConstructorUsedError; //110002020
  set serialLink(String value) =>
      throw _privateConstructorUsedError; //https//etc
  String get purchasePrice => throw _privateConstructorUsedError; //https//etc
  set purchasePrice(String value) =>
      throw _privateConstructorUsedError; //currency set by main setting, just numerical, total price of all images
  String get purchaseDate =>
      throw _privateConstructorUsedError; //currency set by main setting, just numerical, total price of all images
  set purchaseDate(String value) => throw _privateConstructorUsedError;
  String get currentsoldprice => throw _privateConstructorUsedError;
  set currentsoldprice(String value) => throw _privateConstructorUsedError;
  String get solddate => throw _privateConstructorUsedError;
  set solddate(String value) => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  set status(String value) =>
      throw _privateConstructorUsedError; //under auction sold bought?
  String get storage =>
      throw _privateConstructorUsedError; //under auction sold bought?
  set storage(String value) =>
      throw _privateConstructorUsedError; //where it is stored
  String get populationLink =>
      throw _privateConstructorUsedError; //where it is stored
  set populationLink(String value) =>
      throw _privateConstructorUsedError; //mapped to a table/link
  String get remarks =>
      throw _privateConstructorUsedError; //mapped to a table/link
  set remarks(String value) => throw _privateConstructorUsedError;
  List<String> get category => throw _privateConstructorUsedError;
  set category(List<String> value) => throw _privateConstructorUsedError;
  List<String> get imagelist => throw _privateConstructorUsedError;
  set imagelist(List<String> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FolderdataCopyWith<Folderdata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FolderdataCopyWith<$Res> {
  factory $FolderdataCopyWith(
          Folderdata value, $Res Function(Folderdata) then) =
      _$FolderdataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String createdAt,
      String updatedAt,
      String countrygroup,
      String countrytype,
      String denomination,
      String mintageYear,
      String grade,
      String serial,
      String serialLink,
      String purchasePrice,
      String purchaseDate,
      String currentsoldprice,
      String solddate,
      String status,
      String storage,
      String populationLink,
      String remarks,
      List<String> category,
      List<String> imagelist});
}

/// @nodoc
class _$FolderdataCopyWithImpl<$Res> implements $FolderdataCopyWith<$Res> {
  _$FolderdataCopyWithImpl(this._value, this._then);

  final Folderdata _value;
  // ignore: unused_field
  final $Res Function(Folderdata) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? countrygroup = freezed,
    Object? countrytype = freezed,
    Object? denomination = freezed,
    Object? mintageYear = freezed,
    Object? grade = freezed,
    Object? serial = freezed,
    Object? serialLink = freezed,
    Object? purchasePrice = freezed,
    Object? purchaseDate = freezed,
    Object? currentsoldprice = freezed,
    Object? solddate = freezed,
    Object? status = freezed,
    Object? storage = freezed,
    Object? populationLink = freezed,
    Object? remarks = freezed,
    Object? category = freezed,
    Object? imagelist = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      countrygroup: countrygroup == freezed
          ? _value.countrygroup
          : countrygroup // ignore: cast_nullable_to_non_nullable
              as String,
      countrytype: countrytype == freezed
          ? _value.countrytype
          : countrytype // ignore: cast_nullable_to_non_nullable
              as String,
      denomination: denomination == freezed
          ? _value.denomination
          : denomination // ignore: cast_nullable_to_non_nullable
              as String,
      mintageYear: mintageYear == freezed
          ? _value.mintageYear
          : mintageYear // ignore: cast_nullable_to_non_nullable
              as String,
      grade: grade == freezed
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      serial: serial == freezed
          ? _value.serial
          : serial // ignore: cast_nullable_to_non_nullable
              as String,
      serialLink: serialLink == freezed
          ? _value.serialLink
          : serialLink // ignore: cast_nullable_to_non_nullable
              as String,
      purchasePrice: purchasePrice == freezed
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: purchaseDate == freezed
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      currentsoldprice: currentsoldprice == freezed
          ? _value.currentsoldprice
          : currentsoldprice // ignore: cast_nullable_to_non_nullable
              as String,
      solddate: solddate == freezed
          ? _value.solddate
          : solddate // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      storage: storage == freezed
          ? _value.storage
          : storage // ignore: cast_nullable_to_non_nullable
              as String,
      populationLink: populationLink == freezed
          ? _value.populationLink
          : populationLink // ignore: cast_nullable_to_non_nullable
              as String,
      remarks: remarks == freezed
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagelist: imagelist == freezed
          ? _value.imagelist
          : imagelist // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$$_FolderdataCopyWith<$Res>
    implements $FolderdataCopyWith<$Res> {
  factory _$$_FolderdataCopyWith(
          _$_Folderdata value, $Res Function(_$_Folderdata) then) =
      __$$_FolderdataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String createdAt,
      String updatedAt,
      String countrygroup,
      String countrytype,
      String denomination,
      String mintageYear,
      String grade,
      String serial,
      String serialLink,
      String purchasePrice,
      String purchaseDate,
      String currentsoldprice,
      String solddate,
      String status,
      String storage,
      String populationLink,
      String remarks,
      List<String> category,
      List<String> imagelist});
}

/// @nodoc
class __$$_FolderdataCopyWithImpl<$Res> extends _$FolderdataCopyWithImpl<$Res>
    implements _$$_FolderdataCopyWith<$Res> {
  __$$_FolderdataCopyWithImpl(
      _$_Folderdata _value, $Res Function(_$_Folderdata) _then)
      : super(_value, (v) => _then(v as _$_Folderdata));

  @override
  _$_Folderdata get _value => super._value as _$_Folderdata;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? countrygroup = freezed,
    Object? countrytype = freezed,
    Object? denomination = freezed,
    Object? mintageYear = freezed,
    Object? grade = freezed,
    Object? serial = freezed,
    Object? serialLink = freezed,
    Object? purchasePrice = freezed,
    Object? purchaseDate = freezed,
    Object? currentsoldprice = freezed,
    Object? solddate = freezed,
    Object? status = freezed,
    Object? storage = freezed,
    Object? populationLink = freezed,
    Object? remarks = freezed,
    Object? category = freezed,
    Object? imagelist = freezed,
  }) {
    return _then(_$_Folderdata(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      countrygroup: countrygroup == freezed
          ? _value.countrygroup
          : countrygroup // ignore: cast_nullable_to_non_nullable
              as String,
      countrytype: countrytype == freezed
          ? _value.countrytype
          : countrytype // ignore: cast_nullable_to_non_nullable
              as String,
      denomination: denomination == freezed
          ? _value.denomination
          : denomination // ignore: cast_nullable_to_non_nullable
              as String,
      mintageYear: mintageYear == freezed
          ? _value.mintageYear
          : mintageYear // ignore: cast_nullable_to_non_nullable
              as String,
      grade: grade == freezed
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      serial: serial == freezed
          ? _value.serial
          : serial // ignore: cast_nullable_to_non_nullable
              as String,
      serialLink: serialLink == freezed
          ? _value.serialLink
          : serialLink // ignore: cast_nullable_to_non_nullable
              as String,
      purchasePrice: purchasePrice == freezed
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: purchaseDate == freezed
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      currentsoldprice: currentsoldprice == freezed
          ? _value.currentsoldprice
          : currentsoldprice // ignore: cast_nullable_to_non_nullable
              as String,
      solddate: solddate == freezed
          ? _value.solddate
          : solddate // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      storage: storage == freezed
          ? _value.storage
          : storage // ignore: cast_nullable_to_non_nullable
              as String,
      populationLink: populationLink == freezed
          ? _value.populationLink
          : populationLink // ignore: cast_nullable_to_non_nullable
              as String,
      remarks: remarks == freezed
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagelist: imagelist == freezed
          ? _value.imagelist
          : imagelist // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Folderdata extends _Folderdata {
  _$_Folderdata(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt,
      this.countrygroup = "",
      this.countrytype = "",
      this.denomination = "",
      this.mintageYear = "",
      this.grade = "",
      this.serial = "",
      this.serialLink = "",
      this.purchasePrice = "",
      this.purchaseDate = "",
      this.currentsoldprice = "",
      this.solddate = "",
      this.status = "",
      this.storage = "",
      this.populationLink = "",
      this.remarks = "",
      this.category = const [],
      this.imagelist = const []})
      : super._();

  factory _$_Folderdata.fromJson(Map<String, dynamic> json) =>
      _$$_FolderdataFromJson(json);

  @override
  String id;
  @override
  String name;
  @override
  String createdAt;
  @override
  String updatedAt;
  @override
  @JsonKey()
  String countrygroup;
  @override
  @JsonKey()
  String countrytype;
  @override
  @JsonKey()
  String denomination;
  @override
  @JsonKey()
  String mintageYear;
  @override
  @JsonKey()
  String grade;
  @override
  @JsonKey()
  String serial;
//110002020
  @override
  @JsonKey()
  String serialLink;
//https//etc
  @override
  @JsonKey()
  String purchasePrice;
//currency set by main setting, just numerical, total price of all images
  @override
  @JsonKey()
  String purchaseDate;
  @override
  @JsonKey()
  String currentsoldprice;
  @override
  @JsonKey()
  String solddate;
  @override
  @JsonKey()
  String status;
//under auction sold bought?
  @override
  @JsonKey()
  String storage;
//where it is stored
  @override
  @JsonKey()
  String populationLink;
//mapped to a table/link
  @override
  @JsonKey()
  String remarks;
  @override
  @JsonKey()
  List<String> category;
  @override
  @JsonKey()
  List<String> imagelist;

  @override
  String toString() {
    return 'Folderdata(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, countrygroup: $countrygroup, countrytype: $countrytype, denomination: $denomination, mintageYear: $mintageYear, grade: $grade, serial: $serial, serialLink: $serialLink, purchasePrice: $purchasePrice, purchaseDate: $purchaseDate, currentsoldprice: $currentsoldprice, solddate: $solddate, status: $status, storage: $storage, populationLink: $populationLink, remarks: $remarks, category: $category, imagelist: $imagelist)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_FolderdataCopyWith<_$_Folderdata> get copyWith =>
      __$$_FolderdataCopyWithImpl<_$_Folderdata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FolderdataToJson(
      this,
    );
  }
}

abstract class _Folderdata extends Folderdata {
  factory _Folderdata(
      {required String id,
      required String name,
      required String createdAt,
      required String updatedAt,
      String countrygroup,
      String countrytype,
      String denomination,
      String mintageYear,
      String grade,
      String serial,
      String serialLink,
      String purchasePrice,
      String purchaseDate,
      String currentsoldprice,
      String solddate,
      String status,
      String storage,
      String populationLink,
      String remarks,
      List<String> category,
      List<String> imagelist}) = _$_Folderdata;
  _Folderdata._() : super._();

  factory _Folderdata.fromJson(Map<String, dynamic> json) =
      _$_Folderdata.fromJson;

  @override
  String get id;
  set id(String value);
  @override
  String get name;
  set name(String value);
  @override
  String get createdAt;
  set createdAt(String value);
  @override
  String get updatedAt;
  set updatedAt(String value);
  @override
  String get countrygroup;
  set countrygroup(String value);
  @override
  String get countrytype;
  set countrytype(String value);
  @override
  String get denomination;
  set denomination(String value);
  @override
  String get mintageYear;
  set mintageYear(String value);
  @override
  String get grade;
  set grade(String value);
  @override
  String get serial;
  set serial(String value);
  @override //110002020
  String get serialLink; //110002020
  set serialLink(String value);
  @override //https//etc
  String get purchasePrice; //https//etc
  set purchasePrice(String value);
  @override //currency set by main setting, just numerical, total price of all images
  String
      get purchaseDate; //currency set by main setting, just numerical, total price of all images
  set purchaseDate(String value);
  @override
  String get currentsoldprice;
  set currentsoldprice(String value);
  @override
  String get solddate;
  set solddate(String value);
  @override
  String get status;
  set status(String value);
  @override //under auction sold bought?
  String get storage; //under auction sold bought?
  set storage(String value);
  @override //where it is stored
  String get populationLink; //where it is stored
  set populationLink(String value);
  @override //mapped to a table/link
  String get remarks; //mapped to a table/link
  set remarks(String value);
  @override
  List<String> get category;
  set category(List<String> value);
  @override
  List<String> get imagelist;
  set imagelist(List<String> value);
  @override
  @JsonKey(ignore: true)
  _$$_FolderdataCopyWith<_$_Folderdata> get copyWith =>
      throw _privateConstructorUsedError;
}

Imagedata _$ImagedataFromJson(Map<String, dynamic> json) {
  return _Imagedata.fromJson(json);
}

/// @nodoc
mixin _$Imagedata {
  String get id => throw _privateConstructorUsedError;
  set id(String value) => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  set name(String value) => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  set createdAt(String value) => throw _privateConstructorUsedError;
  String get ext => throw _privateConstructorUsedError;
  set ext(String value) => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  set description(String value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImagedataCopyWith<Imagedata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImagedataCopyWith<$Res> {
  factory $ImagedataCopyWith(Imagedata value, $Res Function(Imagedata) then) =
      _$ImagedataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String createdAt,
      String ext,
      String description});
}

/// @nodoc
class _$ImagedataCopyWithImpl<$Res> implements $ImagedataCopyWith<$Res> {
  _$ImagedataCopyWithImpl(this._value, this._then);

  final Imagedata _value;
  // ignore: unused_field
  final $Res Function(Imagedata) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? ext = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      ext: ext == freezed
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ImagedataCopyWith<$Res> implements $ImagedataCopyWith<$Res> {
  factory _$$_ImagedataCopyWith(
          _$_Imagedata value, $Res Function(_$_Imagedata) then) =
      __$$_ImagedataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String createdAt,
      String ext,
      String description});
}

/// @nodoc
class __$$_ImagedataCopyWithImpl<$Res> extends _$ImagedataCopyWithImpl<$Res>
    implements _$$_ImagedataCopyWith<$Res> {
  __$$_ImagedataCopyWithImpl(
      _$_Imagedata _value, $Res Function(_$_Imagedata) _then)
      : super(_value, (v) => _then(v as _$_Imagedata));

  @override
  _$_Imagedata get _value => super._value as _$_Imagedata;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? ext = freezed,
    Object? description = freezed,
  }) {
    return _then(_$_Imagedata(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      ext: ext == freezed
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Imagedata implements _Imagedata {
  _$_Imagedata(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.ext,
      this.description = ""});

  factory _$_Imagedata.fromJson(Map<String, dynamic> json) =>
      _$$_ImagedataFromJson(json);

  @override
  String id;
  @override
  String name;
  @override
  String createdAt;
  @override
  String ext;
  @override
  @JsonKey()
  String description;

  @override
  String toString() {
    return 'Imagedata(id: $id, name: $name, createdAt: $createdAt, ext: $ext, description: $description)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_ImagedataCopyWith<_$_Imagedata> get copyWith =>
      __$$_ImagedataCopyWithImpl<_$_Imagedata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImagedataToJson(
      this,
    );
  }
}

abstract class _Imagedata implements Imagedata {
  factory _Imagedata(
      {required String id,
      required String name,
      required String createdAt,
      required String ext,
      String description}) = _$_Imagedata;

  factory _Imagedata.fromJson(Map<String, dynamic> json) =
      _$_Imagedata.fromJson;

  @override
  String get id;
  set id(String value);
  @override
  String get name;
  set name(String value);
  @override
  String get createdAt;
  set createdAt(String value);
  @override
  String get ext;
  set ext(String value);
  @override
  String get description;
  set description(String value);
  @override
  @JsonKey(ignore: true)
  _$$_ImagedataCopyWith<_$_Imagedata> get copyWith =>
      throw _privateConstructorUsedError;
}
