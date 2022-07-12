// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'userdata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Userdata _$UserdataFromJson(Map<String, dynamic> json) {
  return _Userdata.fromJson(json);
}

/// @nodoc
class _$UserdataTearOff {
  const _$UserdataTearOff();

  _Userdata call(
      {required String id,
      required String name,
      required String createdAt,
      required String version,
      String theme = "Light",
      Map<String, Folderdata> folders = const {},
      Map<String, Imagedata> images = const {}}) {
    return _Userdata(
      id: id,
      name: name,
      createdAt: createdAt,
      version: version,
      theme: theme,
      folders: folders,
      images: images,
    );
  }

  Userdata fromJson(Map<String, Object> json) {
    return Userdata.fromJson(json);
  }
}

/// @nodoc
const $Userdata = _$UserdataTearOff();

/// @nodoc
mixin _$Userdata {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  Map<String, Folderdata> get folders => throw _privateConstructorUsedError;
  Map<String, Imagedata> get images => throw _privateConstructorUsedError;

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
abstract class _$UserdataCopyWith<$Res> implements $UserdataCopyWith<$Res> {
  factory _$UserdataCopyWith(_Userdata value, $Res Function(_Userdata) then) =
      __$UserdataCopyWithImpl<$Res>;
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
class __$UserdataCopyWithImpl<$Res> extends _$UserdataCopyWithImpl<$Res>
    implements _$UserdataCopyWith<$Res> {
  __$UserdataCopyWithImpl(_Userdata _value, $Res Function(_Userdata) _then)
      : super(_value, (v) => _then(v as _Userdata));

  @override
  _Userdata get _value => super._value as _Userdata;

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
    return _then(_Userdata(
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

@JsonSerializable()

/// @nodoc
class _$_Userdata implements _Userdata {
  const _$_Userdata(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.version,
      this.theme = "Light",
      this.folders = const {},
      this.images = const {}});

  factory _$_Userdata.fromJson(Map<String, dynamic> json) =>
      _$_$_UserdataFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String createdAt;
  @override
  final String version;
  @JsonKey(defaultValue: "Light")
  @override
  final String theme;
  @JsonKey(defaultValue: const {})
  @override
  final Map<String, Folderdata> folders;
  @JsonKey(defaultValue: const {})
  @override
  final Map<String, Imagedata> images;

  @override
  String toString() {
    return 'Userdata(id: $id, name: $name, createdAt: $createdAt, version: $version, theme: $theme, folders: $folders, images: $images)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Userdata &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality()
                    .equals(other.version, version)) &&
            (identical(other.theme, theme) ||
                const DeepCollectionEquality().equals(other.theme, theme)) &&
            (identical(other.folders, folders) ||
                const DeepCollectionEquality()
                    .equals(other.folders, folders)) &&
            (identical(other.images, images) ||
                const DeepCollectionEquality().equals(other.images, images)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(theme) ^
      const DeepCollectionEquality().hash(folders) ^
      const DeepCollectionEquality().hash(images);

  @JsonKey(ignore: true)
  @override
  _$UserdataCopyWith<_Userdata> get copyWith =>
      __$UserdataCopyWithImpl<_Userdata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserdataToJson(this);
  }
}

abstract class _Userdata implements Userdata {
  const factory _Userdata(
      {required String id,
      required String name,
      required String createdAt,
      required String version,
      String theme,
      Map<String, Folderdata> folders,
      Map<String, Imagedata> images}) = _$_Userdata;

  factory _Userdata.fromJson(Map<String, dynamic> json) = _$_Userdata.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get createdAt => throw _privateConstructorUsedError;
  @override
  String get version => throw _privateConstructorUsedError;
  @override
  String get theme => throw _privateConstructorUsedError;
  @override
  Map<String, Folderdata> get folders => throw _privateConstructorUsedError;
  @override
  Map<String, Imagedata> get images => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserdataCopyWith<_Userdata> get copyWith =>
      throw _privateConstructorUsedError;
}

Folderdata _$FolderdataFromJson(Map<String, dynamic> json) {
  return _Folderdata.fromJson(json);
}

/// @nodoc
class _$FolderdataTearOff {
  const _$FolderdataTearOff();

  _Folderdata call(
      {required String id,
      required String name,
      required String createdAt,
      required String updatedAt,
      String link = "",
      String description = "",
      List<String> label = const [],
      List<String> imagelist = const []}) {
    return _Folderdata(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      link: link,
      description: description,
      label: label,
      imagelist: imagelist,
    );
  }

  Folderdata fromJson(Map<String, Object> json) {
    return Folderdata.fromJson(json);
  }
}

/// @nodoc
const $Folderdata = _$FolderdataTearOff();

/// @nodoc
mixin _$Folderdata {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get label => throw _privateConstructorUsedError; //multiple label
  List<String> get imagelist => throw _privateConstructorUsedError;

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
      String link,
      String description,
      List<String> label,
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
    Object? link = freezed,
    Object? description = freezed,
    Object? label = freezed,
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
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagelist: imagelist == freezed
          ? _value.imagelist
          : imagelist // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$FolderdataCopyWith<$Res> implements $FolderdataCopyWith<$Res> {
  factory _$FolderdataCopyWith(
          _Folderdata value, $Res Function(_Folderdata) then) =
      __$FolderdataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String createdAt,
      String updatedAt,
      String link,
      String description,
      List<String> label,
      List<String> imagelist});
}

/// @nodoc
class __$FolderdataCopyWithImpl<$Res> extends _$FolderdataCopyWithImpl<$Res>
    implements _$FolderdataCopyWith<$Res> {
  __$FolderdataCopyWithImpl(
      _Folderdata _value, $Res Function(_Folderdata) _then)
      : super(_value, (v) => _then(v as _Folderdata));

  @override
  _Folderdata get _value => super._value as _Folderdata;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? link = freezed,
    Object? description = freezed,
    Object? label = freezed,
    Object? imagelist = freezed,
  }) {
    return _then(_Folderdata(
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
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagelist: imagelist == freezed
          ? _value.imagelist
          : imagelist // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Folderdata extends _Folderdata {
  const _$_Folderdata(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt,
      this.link = "",
      this.description = "",
      this.label = const [],
      this.imagelist = const []})
      : super._();

  factory _$_Folderdata.fromJson(Map<String, dynamic> json) =>
      _$_$_FolderdataFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @JsonKey(defaultValue: "")
  @override
  final String link;
  @JsonKey(defaultValue: "")
  @override
  final String description;
  @JsonKey(defaultValue: const [])
  @override
  final List<String> label;
  @JsonKey(defaultValue: const [])
  @override //multiple label
  final List<String> imagelist;

  @override
  String toString() {
    return 'Folderdata(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, link: $link, description: $description, label: $label, imagelist: $imagelist)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Folderdata &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.link, link) ||
                const DeepCollectionEquality().equals(other.link, link)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.label, label) ||
                const DeepCollectionEquality().equals(other.label, label)) &&
            (identical(other.imagelist, imagelist) ||
                const DeepCollectionEquality()
                    .equals(other.imagelist, imagelist)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(link) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(label) ^
      const DeepCollectionEquality().hash(imagelist);

  @JsonKey(ignore: true)
  @override
  _$FolderdataCopyWith<_Folderdata> get copyWith =>
      __$FolderdataCopyWithImpl<_Folderdata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_FolderdataToJson(this);
  }
}

abstract class _Folderdata extends Folderdata {
  const factory _Folderdata(
      {required String id,
      required String name,
      required String createdAt,
      required String updatedAt,
      String link,
      String description,
      List<String> label,
      List<String> imagelist}) = _$_Folderdata;
  const _Folderdata._() : super._();

  factory _Folderdata.fromJson(Map<String, dynamic> json) =
      _$_Folderdata.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get createdAt => throw _privateConstructorUsedError;
  @override
  String get updatedAt => throw _privateConstructorUsedError;
  @override
  String get link => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  List<String> get label => throw _privateConstructorUsedError;
  @override //multiple label
  List<String> get imagelist => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FolderdataCopyWith<_Folderdata> get copyWith =>
      throw _privateConstructorUsedError;
}

Imagedata _$ImagedataFromJson(Map<String, dynamic> json) {
  return _Imagedata.fromJson(json);
}

/// @nodoc
class _$ImagedataTearOff {
  const _$ImagedataTearOff();

  _Imagedata call(
      {required String id,
      required String name,
      required String createdAt,
      required String ext,
      String description = ""}) {
    return _Imagedata(
      id: id,
      name: name,
      createdAt: createdAt,
      ext: ext,
      description: description,
    );
  }

  Imagedata fromJson(Map<String, Object> json) {
    return Imagedata.fromJson(json);
  }
}

/// @nodoc
const $Imagedata = _$ImagedataTearOff();

/// @nodoc
mixin _$Imagedata {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get ext => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

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
abstract class _$ImagedataCopyWith<$Res> implements $ImagedataCopyWith<$Res> {
  factory _$ImagedataCopyWith(
          _Imagedata value, $Res Function(_Imagedata) then) =
      __$ImagedataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String createdAt,
      String ext,
      String description});
}

/// @nodoc
class __$ImagedataCopyWithImpl<$Res> extends _$ImagedataCopyWithImpl<$Res>
    implements _$ImagedataCopyWith<$Res> {
  __$ImagedataCopyWithImpl(_Imagedata _value, $Res Function(_Imagedata) _then)
      : super(_value, (v) => _then(v as _Imagedata));

  @override
  _Imagedata get _value => super._value as _Imagedata;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? createdAt = freezed,
    Object? ext = freezed,
    Object? description = freezed,
  }) {
    return _then(_Imagedata(
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

@JsonSerializable()

/// @nodoc
class _$_Imagedata implements _Imagedata {
  const _$_Imagedata(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.ext,
      this.description = ""});

  factory _$_Imagedata.fromJson(Map<String, dynamic> json) =>
      _$_$_ImagedataFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String createdAt;
  @override
  final String ext;
  @JsonKey(defaultValue: "")
  @override
  final String description;

  @override
  String toString() {
    return 'Imagedata(id: $id, name: $name, createdAt: $createdAt, ext: $ext, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Imagedata &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.ext, ext) ||
                const DeepCollectionEquality().equals(other.ext, ext)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(ext) ^
      const DeepCollectionEquality().hash(description);

  @JsonKey(ignore: true)
  @override
  _$ImagedataCopyWith<_Imagedata> get copyWith =>
      __$ImagedataCopyWithImpl<_Imagedata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ImagedataToJson(this);
  }
}

abstract class _Imagedata implements Imagedata {
  const factory _Imagedata(
      {required String id,
      required String name,
      required String createdAt,
      required String ext,
      String description}) = _$_Imagedata;

  factory _Imagedata.fromJson(Map<String, dynamic> json) =
      _$_Imagedata.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get createdAt => throw _privateConstructorUsedError;
  @override
  String get ext => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ImagedataCopyWith<_Imagedata> get copyWith =>
      throw _privateConstructorUsedError;
}
