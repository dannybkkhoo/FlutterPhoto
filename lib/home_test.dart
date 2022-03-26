import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'images.dart';

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(firebaseAuthProvider);
    final uid = user.firebaseUser?.uid;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            final maxHeight = constraints.maxHeight;
            final maxWidth = constraints.maxWidth;
            return Container(
              height: maxHeight,
              width: maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FolderItem(name: uid??"HMM", height: maxHeight*0.20, width: maxHeight*0.150)
                ],
              ),
            );
          }
        )
      )
    );
  }
}

class FolderItem extends StatelessWidget {
  late String _name;
  late double _height, _width;
  FolderItem({
    Key? key,
    required String name,
    required double height,
    required double width
  }):super(key:key){
    this._name = name;
    this._height = height;
    this._width = width;
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13.0),
      child: Container(
        height: _height,
        width: _width,
        color: Theme.of(context).accentColor,
        child: GestureDetector(
          onTap: () {
            print("HELO");
          },
          child: Card(
            elevation: 10.0,
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: _width,
                  width: _width,
                  padding: EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.0),
                    child: Image.asset(Images.defaultError, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  // color:Theme.of(context).colorScheme.surface,
                  width: _width,
                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.0),
                    child: Text(_name, style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
                  ),
                ),
              ]
            )
          ),
        )
      ),
    );
  }
}
