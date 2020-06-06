import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import 'last2layers.dart';



void main() => runApp(MyApp());
//Now use stateful Widget = Widget has properties which can be changed
class MainPage extends StatefulWidget {
  final String title;
  //Custom constructor, add property : title
  @override
  MainPage({this.title}) : super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();//Return a state object
  }
}
class MainPageState extends State<MainPage> {
  //State must have "build" => return Widget
  String parentString = 'Photoname';

  File _image;
  List<String> _imageList = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  List<Widget> photos = new List<Widget>();
  List<String> photonames = new List<String>();
  int num = 0;
  @override
  void initState() {
    super.initState();
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");
    _imageList.add("assets/Capture1.PNG");
    _imageList.add("assets/Capture2.PNG");
    _imageList.add("assets/Capture3.PNG");

  }
  void parentChange(newString) {
    setState(() {
      parentString = newString;
    });
  }
  void appendfoldernames(onValue){
    if(onValue != null) {
      setState(() {
        //photos.add(folder);
        photonames = List.from(photonames)..add(onValue);
        print(photonames);
        print(photonames.length);
      });
    }
  }
  void addPhotos (imagepath){
    if(imagepath != null) {
      setState(() {
        //photos.add(folder);
        _imageList = List.from(_imageList)..add(imagepath);
        print(_imageList);
      });
    }
  }



  void deletePhotos (imagepath){
    if(imagepath != null) {
      setState(() {
        _imageList = List.from(_imageList)..remove(imagepath);
        num--;
        print(num);
        print(_imageList);
      });
    }
  }
  @override
  void open_camera() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      _imageList.add(_image.path);
    });
  }
  void open_gallery() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _imageList.add(_image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttons = List();
    if (_selectionMode) {
      _buttons.add(
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _selectedIndexList.sort();
                print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
                for(var i = 0; i < _selectedIndexList.length; i++){
                  print("Currently deleting : ${_selectedIndexList[i]}");
                  _imageList = List.from(_imageList)..removeAt(_selectedIndexList[i]);

                }
                _changeSelection(enable: false, index: -1);
                print('Number of items in selected list: ${_selectedIndexList.length} items!');
                print(_imageList);
              });
              //_selectedIndexList.sort();

            }),

      );
       _buttons.add(
        FlatButton(
            child:Text('Cancel'),
            onPressed: () {
              setState(() {
                //_selectedIndexList.clear();
                //_changeSelection(enable: false, index: -1);
                _selectionMode =false;
                _selectedIndexList.clear();
              });
              //Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));

            }),

      );
    }
    else{
      _buttons.add(
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () {
            open_camera();
          },
        ),);

      _buttons.add(
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
          onPressed: () {
            print('sortyo');
            ShowSortOptions(context);
          },
        ),);
    }

    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: _buttons
        /*<Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print('sortyo');
            },
          ),
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              open_camera();
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              print('sortyo');
              ShowSortOptions(context);
            }
          ),
        ],*/
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
          open_gallery();
          },
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text("Import Photos"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.amberAccent,
        ),
        body:  SingleChildScrollView(
           child: Container(
                child:Column(
                  children: <Widget>[
                    SearchPhoto(),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text( _imageList.length != null ? '  Number of Photos = ${_imageList.length} ': '  Number of Photos = 0',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                        )

                    ),
                    _createBody(),
                    /*GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemBuilder: (_, index) =>  FlutterLogo(),//ShowPhotos("assets/Capture3.PNG",customFunction: parentChange),
                      itemCount: _imageList.length,
                      primary: false,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                    )*/
                    /*GridView.count(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children: <Widget>[
                        ShowPhotos("assets/Capture1.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture2.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture3.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture1.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture2.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture3.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture1.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture2.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture3.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture1.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture2.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture3.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture1.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture2.PNG",customFunction: parentChange),
                        ShowPhotos("assets/Capture3.PNG",customFunction: parentChange),
                      ],
                      //children: photos,
                    ),*/
                  ],
                )
            )
        )

    );

  }
  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemCount: _imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }
  GridTile getGridTile(int index) {
    if(_selectionMode){
      return GridTile(
          child: Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _changeSelection(enable: false, index: -1);
                          });
                        },
                        onTap: () {
                          setState(() {
                            if (_selectedIndexList.contains(index)) {
                              _selectedIndexList.remove(index);
                              print(_selectedIndexList);
                            } else {
                              _selectedIndexList.add(index);
                              print(_selectedIndexList);
                            }
                          });
                        },

                        child: Container(
                          child: new Card(
                            elevation: 10.0,
                            child: new Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Image.asset(_imageList[index],
                                    height: 90.0, width: 200.0, fit: BoxFit.fill),
                                //new Image.asset(widget.imagepath,
                                // height: 100.0, width: 200.0, fit: BoxFit.fill),
                                photoname(customFunction: parentChange)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                        color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                )

              ]
          )
      );

    }
    else{
      return GridTile(
          child: Wrap(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _changeSelection(enable: true, index: index);
                      });
                      print("long press detected");
                    },
                    onTap: () {
                      print("pressed");
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PhotoThing(parentString)));
                    },

                    child: Container(
                      child: new Card(
                        elevation: 10.0,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Image.asset(_imageList[index],
                                height: 90.0, width: 200.0, fit: BoxFit.fill),
                            //photoname(customFunction: parentChange)

                          ],
                        ),
                      ),
                    ),
                  ),


                ),
                photoname(customFunction: parentChange)
              ]
          )
      );
    }
  }
  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }
}



/*class PhotoSelectionList {
  PhotoSelectionList._();
  static int index =0;
  static var _photoselectedIndexList = [];
  static var PhotoNames = [];
  static void _photochangeSelection({int index}) {

    PhotoSelectionList._photoselectedIndexList.add(index);
    if (index == -1) {
      PhotoSelectionList._photoselectedIndexList.clear();
    }
  }


}*/

/*class ShowPhotos extends StatefulWidget {
  //final String Photoname;
  final customFunction;
  final imagepath;

  ShowPhotos(this.imagepath,{this.customFunction});
  //ShowPhotos(index,{this.customFunction});
  @override
  _ShowPhotosState createState() => _ShowPhotosState();
}


class _ShowPhotosState extends State<ShowPhotos> {
  String parentString = 'Photoname';
  bool __PselectionMode = false;

  void parentChange(newString) {
    setState(() {
      parentString = newString;
    });
  }
  @override

  //final imageName = index < 9 ?
 // 'assets/Capture${index + 1}.PNG' : 'assets/Capture${index + 1}.PNG';

  Widget build(BuildContext context) {
   if(__PselectionMode){
     return Container(
         child: Wrap(
             children: <Widget>[
               Stack(
                 children: <Widget>[
                   Container(
                     child: GestureDetector(
                       onLongPress: () {
                         widget.customFunction(true);
                         setState(() {
                           __PselectionMode = false;
                           PhotoSelectionList._photoselectedIndexList.clear();
                           PhotoSelectionList._photochangeSelection(index: 0);
                           print("Selection list after cancel =${PhotoSelectionList._photoselectedIndexList}");
                         });
                         print("long press detected");
                       },
                       onTap: () {
                         print("pressed");
                         setState(() {
                           if (PhotoSelectionList._photoselectedIndexList.contains(PhotoSelectionList.index)) {
                             PhotoSelectionList._photoselectedIndexList.remove(PhotoSelectionList.index);
                           } else {
                             PhotoSelectionList._photoselectedIndexList.add(PhotoSelectionList.index);
                           }
                           print(PhotoSelectionList._photoselectedIndexList);
                           print("Selection list after cancel =${PhotoSelectionList._photoselectedIndexList}");
                         });
                         // Navigator.push(context, MaterialPageRoute(
                         //   builder: (context) => PhotoThing(parentString)));
                       },

                       child: Container(
                         child: new Card(
                           elevation: 10.0,
                           child: new Column(
                             mainAxisSize: MainAxisSize.max,
                             children: <Widget>[
                               new Image.asset(widget.imagepath,
                                   height: 100.0, width: 200.0, fit: BoxFit.fill),
                               //new Image.asset(widget.imagepath,
                                  // height: 100.0, width: 200.0, fit: BoxFit.fill),
                               photoname(customFunction: parentChange)
                             ],
                           ),
                         ),
                       ),
                     ),
                   ),
                   Positioned(
                     top: 5,
                     right: 5,
                     child: Icon(
                       PhotoSelectionList._photoselectedIndexList.contains(PhotoSelectionList.index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                       color: PhotoSelectionList._photoselectedIndexList.contains(PhotoSelectionList.index) ? Colors.green : Colors.black,
                     ),
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
                   onLongPress: () {
                     widget.customFunction(true);
                     setState(() {
                       __PselectionMode = true;
                       PhotoSelectionList._photochangeSelection(index: PhotoSelectionList.index);
                     });
                     print("long press detected");
                   },
                   onTap: () {
                     print("pressed");
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context) => PhotoThing(parentString)));
                   },

                   child: Container(
                     child: new Card(
                       elevation: 10.0,
                       child: new Column(
                         mainAxisSize: MainAxisSize.max,
                         children: <Widget>[
                           new Image.asset(widget.imagepath,
                               height: 100.0, width: 200.0, fit: BoxFit.fill),
                           photoname(customFunction: parentChange)

                         ],
                       ),
                     ),
                   ),
                 ),


               )

             ]
         )
     );
   }
  }
}*/


/*List<Widget> _buildGridTiles(numberOfTiles, BuildContext context) {

  List<Container> containers = new List<Container>.generate(numberOfTiles,
          (int index) {
        //index = 0, 1, 2,...
        final imageName = index < 9 ?
        'assets/Capture${index +1}.PNG' : 'assets/Capture${index +1}.PNG';
        Photodetails updatedetails = new Photodetails();
        var PHOTONAME = updatedetails.Photoname;

        return new Container(
            child: Wrap(
                children: <Widget>[
                  Container(
                    child: GestureDetector(
                      onTap: (){
                        print("pressed");
                        Navigator.push(context,MaterialPageRoute(builder: (context) => PhotoThing(PHOTONAME)));

                      },
                      child: Container(
                        child: new Card(
                          elevation: 10.0,
                          child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Image.asset(imageName,
                                  height: 90.0, width: 200.0,fit: BoxFit.fill),
                              new Text(widget.)
                             /*new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Photoname"
                                ),
                                controller: photonameCon,
                              ),*/

                            ],
                          ),
                        ),
                      ),
                    ),
                  )

                ]
            )
        );
      });
  return containers;
}*/
/*class Photodetails {

  String Photoname;

  Photodetails({this.Photoname});


}*/
class photoname extends StatefulWidget{

  final customFunction;
  photoname({this.customFunction});
  @override
  photonameState createState() => new photonameState();
}

class photonameState extends State<photoname>{
  String name;
  //Photodetails detials = new Photodetails();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      FlatButton(
      color: Colors.grey,
        textColor: Colors.black,
        splashColor: Colors.white,

        padding: EdgeInsets.all(4.0),
        child: Text(name != null? name:'Photoname'),
        onPressed: (){
          createAlertDialog(context, "Photoname").then((onValue) async {
            if( onValue != null) {
              widget.customFunction(onValue);
              setState(() {
                name = onValue;
                print("Name is $name");
                // PhotoSelectionList.PhotoNames.add(onValue);
              });
            }

          });
        },
      ),
      ],
    );
  }
  Future<String> createAlertDialog(BuildContext context, title){
    TextEditingController DescriptionCon = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: DescriptionCon ,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
            onPressed: (){
              Navigator.of(context).pop(DescriptionCon.text.toString());
              print("Submitted : ${DescriptionCon.text.toString()}");
            },
          )
        ],
      );
    });
  }
}

class MyApp extends StatelessWidget {
  //Stateless = immutable = cannot change object's properties
  //Every UI components are widgets
  @override
  Widget build(BuildContext context) {
    //Now we need multiple widgets into a parent = "Container" widget
    //build function returns a "Widget"
    return new MaterialApp(
        title: "",
        home: new MainPage(title: "Gridview of Images")
    );
  }
}
class SearchPhoto extends StatelessWidget{
  //final _imagepath;
  SearchPhoto();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10,top: 20),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search Photo",
            border: InputBorder.none,
            fillColor: Colors.grey,
            icon: Icon(Icons.search)
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )
      ),
    );
  }
}
void ShowSortOptions(BuildContext context) async{
  final items = <MultiSelectDialogSortItem<int>>[
    MultiSelectDialogSortItem(1, 'Name'),
    MultiSelectDialogSortItem(2, 'Date'),

  ];

  final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context){
        return MultiSelectDialogSort(
          items: items,
          //initialSelectedValues: [1].toSet(),
        );
      }
  );
}
class MultiSelectDialogSortItem<V> {
  const MultiSelectDialogSortItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialogSort<V> extends StatefulWidget {
  MultiSelectDialogSort({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogSortItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogStateSort<V>();
}

class _MultiSelectDialogStateSort<V> extends State<MultiSelectDialogSort<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sort By'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogSortItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}