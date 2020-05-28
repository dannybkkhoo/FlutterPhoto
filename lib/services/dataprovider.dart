import 'package:flutter/cupertino.dart';
import 'package:app2/services/utils.dart';
import "userdata.dart";
import 'package:path_provider/path_provider.dart';
import 'firestore_storage.dart';
import 'dart:convert';
import 'dart:io';

class DataProvider extends StatefulWidget {
  final Widget child;
  const DataProvider({Key key, this.child}) : super(key:key);
  static CacheData of (BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CacheData>();

  @override
  _DataProviderState createState() => _DataProviderState();
}

class _DataProviderState extends State<DataProvider>{
  UserData userData = UserData(DateTime.now(),{},{},[]);

  void update(var data){
    setState(() {
      userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CacheData(
      userData: userData,
      onChange: update,
      child: widget.child,
    );
  }
}


