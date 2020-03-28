import 'package:flutter/material.dart';

class Folder extends StatelessWidget{
  final folder_name;
  final folder_date;
  final folder_size;
  Folder(this.folder_name,this.folder_date,this.folder_size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 100.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(folder_name,style: TextStyle(fontSize: 18.0),),
      )
    );
  }

}