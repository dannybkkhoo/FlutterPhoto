import 'package:flutter/cupertino.dart';
import "userdata.dart";

class DataProvider extends StatefulWidget {
  final Widget child;
  const DataProvider({Key key, this.child}) : super(key:key);
  static CacheData of (BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CacheData>();

  @override
  _DataProviderState createState() => _DataProviderState();
}

class _DataProviderState extends State<DataProvider>{
  UserData userData = UserData({},{},{"folders":[]});

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