import 'package:flutter/material.dart';

import 'horizontalscrollwithdescription.dart';

class ShowFolder extends StatefulWidget {
 String folderName;
  final customFunction;
  ShowFolder(this.folderName, {this.customFunction});
  @override
  _ShowFolderState createState() => _ShowFolderState();
}

class SelectionList {
  SelectionList._();
  bool _selectionMode;
  static var _selectedIndexList = [];
  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    SelectionList._selectedIndexList.add(index);
    if (index == -1) {
      SelectionList._selectedIndexList.clear();
    }
  }


}
class _ShowFolderState extends State<ShowFolder>{
  @override

 bool _selectionMode = false;

  Widget build(BuildContext context) {
    if (_selectionMode){
      return Container(
          child: Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[

                    Container(
                      child: GestureDetector(
                        onLongPress: (){
                          widget.customFunction(true);
                          setState(() {
                            _selectionMode = false;
                          });
                          print("long press detected");
                        },
                        onTap: (){
                          print("pressed");
                          //Navigator.push(context,
                          // MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription(widget.folderName)));
                          //Navigator.of(context).push(PageRouteBuilder(
                              //opaque: false,
                              //pageBuilder: (BuildContext context, _, __) =>
                              //    HorizontalScrollWithDescription(widget.folderName)));
                        },

                        child: Container(
                          child: new Card(
                            elevation: 10.0,
                            child: new Column(

                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new SizedBox(
                                  height: 5.0,
                                ),
                                new Image.asset("assets/Capture01.PNG",
                                    height: 100.0, width: 100.0,fit: BoxFit.cover),
                                new SizedBox(
                                  height: 5.0,
                                ),
                                new Text(widget.folderName != null? widget.folderName: 'Foldername', style: TextStyle(fontSize: 15.0),),


                              ],
                            ),
                          ),
                        ),
                      ),


                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(Icons.check_circle_outline),
                    ),
                  ],
                )

              ]
          )
      );
    }
    else{
      return Container(
          child: Wrap(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onLongPress: (){
                      widget.customFunction(true);
                      setState(() {
                        _selectionMode = true;
                      });
                      print("long press detected");
                    },
                    onTap: (){
                      print("pressed");
                      //Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription(widget.folderName)));
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              HorizontalScrollWithDescription(widget.folderName)));
                    },

                    child: Container(
                      child: new Card(
                        elevation: 10.0,
                        child: new Column(

                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 5.0,
                            ),
                            new Image.asset("assets/Capture01.PNG",
                                height: 100.0, width: 100.0,fit: BoxFit.cover),
                            new SizedBox(
                              height: 5.0,
                            ),
                            new Text(widget.folderName, style: TextStyle(fontSize: 15.0),),


                          ],
                        ),
                      ),
                    ),
                  ),


                ),

              ]
          )
      );
    }
  }
}



