import 'package:flutter/material.dart';

class Blek extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Stateful"),
      ),
      body: Test(),
    );
  }
}

class Test extends StatefulWidget{
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test>{
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite(){
    setState((){
      if(_isFavorited){
        _favoriteCount -= 1;
        _isFavorited = false;
      }
      else{
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (_isFavorited ? Icon(Icons.star):Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          )
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$_favoriteCount'),
          )
        )
      ]
    );

  }
}