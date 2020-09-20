import 'dart:collection';
import 'dart:io';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutterhorizontalscroll/Page4.dart';
import 'package:flutterhorizontalscroll/Page2a.dart';



//void main() => runApp(MyApp());
//Now use stateful Widget = Widget has properties which can be changed
class MainPage extends StatefulWidget {

  List <Map> foldernamesmap = List();
  int index ;
  //Custom constructor, add property : title
  @override
  MainPage(this.foldernamesmap, this.index) : super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();//Return a state object
  }
}
class MainPageState extends State<MainPage> {
  //State must have "build" => return Widget


  File _image;
  //List<String> _imageList = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  bool _checker =false;
  //List<Widget> photos = new List<Widget>();
  //List<String> photonames = new List<String>();
  List<Map> maps = List();
  List<Map> duplicatemaps = List();
  List<Map> combineMap = List();
  ScrollController _controller = ScrollController();

  //int num = 0;
  @override
  void initState() {
    super.initState();
   /* _imageList.add("assets/Capture1.PNG");
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
    _imageList.add("assets/Capture3.PNG");*/

    maps = [
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},

      ];
    duplicatemaps = [
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath": "assets/Capture1.PNG", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"1.16 MB", "description": null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture2.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"203.68 KB", "description":null,},
      {"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'assets/Capture3.PNG', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"27.53 KB", "description":null,},
    ];

  }
 /* void parentChange(newString) {
    setState(() {
      parentString = newString;
    });
  }*/
  /*void appendphotonames(onValue){
    if(onValue != null) {
      setState(() {
        //photos.add(folder);
        photonames = List.from(photonames)..add(onValue);
        print(photonames);
        print(photonames.length);
      });
    }
  }*/



  @override
  void open_camera() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var imgsize;
    setState(() {
      _image = image;
      getImage(_image.path).then((value){
        print('imge_path =${_image.path}');
        imgsize = value;
        print('Imagesizeatopencamera = $imgsize');
        maps.add({"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":"${_image.path}", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"${imgsize}", "description":null,});
        duplicatemaps.add({"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":"${_image.path}", "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"${imgsize}", "description":null,});
      });
      //_imageList.add(_image.path);


    });
  }
  void open_gallery() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var imgsize;
    setState(() {
      _image = image;
      getImage(_image.path).then((value){
        imgsize = value;
        maps.add({"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'${_image.path}', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"${imgsize}","description":null,});
        duplicatemaps.add({"Foldername": "${widget.foldernamesmap[widget.index]["foldername"]}","imagepath":'${_image.path}', "name" : 'Photoname',"date" : DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"imagesize":"${imgsize}","description":null,});
        //print('Imagesize = $imgsize');
        //print('mapseheheh = $maps');
        //print('duplimapseheheh = $duplicatemaps');
      });
      //_imageList.add(_image.path);

    });
  }
  @override
  bool isSort = true;
  bool isSortdate = true;
  bool Tick = false;
  bool isSearching =false;

  void sort(List map, duplicatemaps) {
    maps.sort((a, b) => isSort ? a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()) : b['name'].toString().toLowerCase().compareTo(a['name'].toString().toLowerCase()));
    duplicatemaps.sort((a, b) => isSort ? a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()) : b['name'].toString().toLowerCase().compareTo(a['name'].toString().toLowerCase()));
    isSort = !isSort;
    /*List temp = [];
    List tempphoto = [];
    for(int x =0; x < maps.length; x++){
      if (maps[x]["name"] == "Photoname"){
        tempphoto = List.from(tempphoto)..add(maps[x]["name"]);
      }  else{
        temp = List.from(temp)..add(maps[x]["name"]);
      }

    }
    print("list for temp = $temp");
    print("list for tempphoto = $tempphoto");*/
  }
  void sortdate(List map, duplicatemaps) {
    maps.sort((a, b) => isSortdate ? a['date'].compareTo(b['date']) : b['date'].compareTo(a['date']));
    duplicatemaps.sort((a, b) => isSortdate ? a['date'].compareTo(b['date']) : b['date'].compareTo(a['date']));
    isSortdate = !isSortdate;

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
                _selectedIndexList.sort((b, a) => a.compareTo(b));
                print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
                for(int i = 0; i < _selectedIndexList.length; i++){
                  print("Currently deleting : ${_selectedIndexList[i]}");
                  maps = List.from(maps)..removeAt(_selectedIndexList[i]);
                  duplicatemaps = List.from(maps)..removeAt(_selectedIndexList[i]);
                }
                _changeSelection(enable: false, index: -1);
                print('Number of items in selected list: ${_selectedIndexList.length} items!');
               // print(maps[index]['imagepath']);
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
      if(isSearching){
        _buttons.add(
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                this.isSearching = false;
                maps.clear();
                maps.addAll(duplicatemaps);

              });

            },
          ),);
      }
      else{

        _buttons.add(
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showChoiceDialog(context);
            },
          ),);
        _buttons.add(
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                this.isSearching = true;
              });

            },
          ),);
        _buttons.add(
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              _showChoiceDialogForSort(context);
            },
          ),);

      }
    }

    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
          appBar: new AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    combineMap.clear();
                    combineMap.addAll(widget.foldernamesmap);
                    if(maps.length>0){
                      combineMap.addAll(maps);
                    }
                  });

                  //print("combine maps = $combineMap");
                  Navigator.pop(context,combineMap);
                },

              ),
              title: !isSearching?  Text(_selectedIndexList.length < 1
                  ? "Gridview of Images"
                  : "${_selectedIndexList.length} item selected")
                  :TextField(
                onChanged: (text) {
                  filterSearchResults(text);
                  print('Current on change text is $text');
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Folder",
                    hintStyle: TextStyle(color: Colors.white)),

              ),
              bottom: TabBar(tabs: [
                Tab(child: Text('Photos', style: TextStyle(fontSize: 20),)),
                Tab(child: Text('Folder Info', style: TextStyle(fontSize: 20),)),
              ]),
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
          /*floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
          open_gallery();
          },
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text("Import Photos"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.amberAccent,
        ),*/
          body: TabBarView(children: <Widget>[
            DraggableScrollbar.semicircle(
              controller: _controller,
              labelTextBuilder: (offset) {
                final int currentItem = _controller.hasClients
                    ? (_controller.offset /
                    _controller.position.maxScrollExtent *
                    maps.length)
                    .floor()
                    : 0;

                return Text("$currentItem");
              },
              child:  _createBody(),
            ),
            DescriptionFolder(context,widget.foldernamesmap[widget.index]),
          ],)


        /*  SingleChildScrollView(
            child: Container(
                child:Column(
                  children: <Widget>[
                    DescriptionFolder(context,widget.foldernamesmap[widget.index]),
                    SearchPhoto(context),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text( Tick != false ? '  No Photos Found':
                        '  Number of Photos = ${maps.length} '
                        ,style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
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
        )*/

      ),
    );

  }
  Future getImage(String imageAssetPath) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    final baseSizeImage = assetImageByteData.buffer.lengthInBytes;
    final standardize = filesize(baseSizeImage);
    //final baseSizeImage = assetImageByteData.buffer.asUint8List();
    print('baseSizeImage = $baseSizeImage');
    print("assetImagebyetedata = $assetImageByteData");
    print('standardize = $standardize');
    return standardize;
  }
  Future <void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Import Photo'),
        contentPadding: EdgeInsets.only(top: 12.0),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  print('Gallery');
                  open_gallery();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.add_photo_alternate),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Gallery',style: TextStyle(fontSize: 20.0)),

                  ],
                ),

              ),

              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                onTap: (){
                  print('detected');
                  open_camera();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.add_a_photo),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Camera',style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),),
            ],
          ),
        ),
      );
    },
    );
  }
  void filterSearchResults(String text) {
    List<Map> dummySearchList = List<Map>();
    dummySearchList.addAll(duplicatemaps);
    if(text.isNotEmpty && text.length > 0) {
      List<Map> dummyListData = List<Map>();
     for(int i=0; i<duplicatemaps.length; i++){
       if(duplicatemaps[i]["name"].toLowerCase().contains(text.toLowerCase()) ||
           duplicatemaps[i]["name"].contains(text.toLowerCase())) {
         dummyListData.add(duplicatemaps[i]);

       }
     };
      setState(() {
        maps.clear();
        maps.addAll(dummyListData);
        if(dummyListData.length > 0){
          Tick = false;
        }
        else{
          Tick = true;
        }
      });

      return;
    }
    else {
      Tick = false;
      setState(() {
        maps.clear();
        maps.addAll(duplicatemaps);
      });
    }
  }
  Widget SearchPhoto(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10,top: 20),
      child: TextField(
        onChanged:(text){
          filterSearchResults(text);
          print('Current on change text is $text');
        },
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
  Widget _photonames(index) {
    // String name;
    //var imag;
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          color: Colors.grey,
          textColor: Colors.black,

          padding: EdgeInsets.all(4.0),
          child: Text(maps[index]["name"]),
          onPressed: (){
            createAlertDialog(context, "Photoname").then((onValue) async {
              if( onValue != null && onValue.isNotEmpty) {
                //widget.customFunction(onValue);
                print("old value = ${maps[index]["name"]}");
                print("maps [0]= ${maps[0]}");
                print("maps length = ${maps.length}");
                for (int j = 0; j < maps.length; j++){
                  if(maps[j]["name"] == onValue){
                    print('This Photoname exsits');
                    NameExistdialog(context,"Photoname Exist","Please try another photoname");
                    setState(() {
                      _checker = true;
                    });
                  }
                }
                if(!_checker){
                  setState(() {
                    maps[index]["name"]= onValue;
                    duplicatemaps[index]["name"]= onValue;
                    print("updated value =${maps[index]["name"]}");

                    //addPhotos(_imageList);
                    //appendphotonames(name);
                    /*var imag = imageRecord(
                    image_path: "$_imageList",
                    name: "$name",
                  );*/
                    //print("image data = ${imag.dat()}");
                    print('Map = $maps');
                  });
                }
                else{
                  setState(() {
                    _checker = false;
                  });
                }

              }
              if(onValue?.isEmpty?? false){
                NameExistdialog(context,'Photoname not given', 'Please enter a photoname to create new folder');
                return;
              }

            });
          },
        ),
      ],
    );
  }
  Future <void> NameExistdialog(BuildContext context, title,content){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions:[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.keyboard_return),
                  Text('Back')
                ],
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ]
      );
    },
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
  Future <void> _showChoiceDialogForSort(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Sort By'),
        contentPadding: EdgeInsets.only(top: 12.0),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  sort(maps, duplicatemaps);
                  setState(() {
                    maps = maps;
                    duplicatemaps = duplicatemaps;
                  });
                  print('Sorted by name');
                  Navigator.pop(context);

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),

                    Icon(isSort != true? Icons.arrow_upward : Icons.arrow_downward),
                    Icon(Icons.sort_by_alpha),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Name',style: TextStyle(fontSize: 20.0)),

                  ],
                ),

              ),

              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                onTap: (){
                  print('Sorted by Date');
                  sortdate(maps, duplicatemaps);
                  setState(() {
                    maps = maps;
                    duplicatemaps= duplicatemaps;
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(isSortdate != true? Icons.arrow_upward : Icons.arrow_downward),
                    Icon(Icons.date_range),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Date',style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),),
            ],
          ),
        ),
      );
    },
    );
  }
  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      controller: _controller,
      crossAxisCount: 3,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
//      physics: ScrollPhysics(),
//      shrinkWrap: true,
//      primary: false,
      itemCount: maps.length,
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
                                new Image.asset(maps[index]['imagepath'],
                                    height: 90.0, width: 200.0, fit: BoxFit.fill),
                                _photonames(index),
                                //photoname(_imageList[index],customFunction: parentChange)
                                //new Image.asset(widget.imagepath,
                                // height: 100.0, width: 200.0, fit: BoxFit.fill),
                                //photoname(customFunction: parentChange)
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
                      print("maps = $maps");
                    },
                    /*onTap: () {
                      print("pressed");
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PhotoThing(parentString)));
                    },*/

                    child: Container(
                      child: new Card(
                        elevation: 10.0,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Image.asset(maps[index]['imagepath'],
                                height: 90.0, width: 200.0, fit: BoxFit.fill),
                            //photoname(_imageList[index])
                            //photoname(_imageList[index],customFunction: parentChange)
                            _photonames(index),

                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      print("pressed");
                      Navigator.push(context,
                        new MaterialPageRoute(builder: (context) =>PhotoPreviewFunction(maps,index)),
                      )
                          .then((value) {
                        setState(() {
                          maps = value;
                          print('Recieved maps = $maps');
                          print('Recoeved map length = ${maps.length}');
                        });
                      });
                      //Navigator.push(context, MaterialPageRoute(
                           //builder: (context) => PhotoPreviewFunction(maps)));



                      //builder: (context) => PhotoThing(parentString)));
                    },
                  ),


                ),
                // photoname(_imageList[index],customFunction: parentChange)
                // photoname(customFunction: parentChange)
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

  Widget DescriptionFolder(BuildContext context, foldernamesmap) {

    return Container(
      width: 400,
      //height: 250,

      child: new Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: new Text('Folder Name: ${foldernamesmap["foldername"]}',textAlign: TextAlign.left, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        createAlertDialog(context,"Folder Name").then((onValue) async {
                          if( onValue != null) {
                            setState(() {
                              foldernamesmap["foldername"] = onValue;
                            });
                          }

                        });

                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.edit), // icon
                          Text("Edit"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Text('Date: ${foldernamesmap["folderdate"]}', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.left),
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(foldernamesmap["folderdescription"] != null? 'Description: ${foldernamesmap["folderdescription"]}':'Description: No Description', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        createAlertDialog(context,"Description").then((onValue) async {
                          if( onValue != null) {
                            setState(() {
                              foldernamesmap["folderdescription"] = onValue;
                            });
                          }

                        });

                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.edit), // icon
                          Text("Edit"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(foldernamesmap["folderlink"] != null? 'Link: ${foldernamesmap["folderlink"]}':'Link: No Link', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        folderAlertDialog(context, "Link").then((onValue) async {
                          if( onValue != null && onValue.isNotEmpty) {

                            setState(() {
                              foldernamesmap["folderlink"] = onValue;

                            });
                          }
                          else{
                            setState(() {
                              foldernamesmap["folderlink"] = "No Link";

                            });
                          }

                        });

                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.edit), // icon
                          Text("Edit"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        if(foldernamesmap["folderlink"] !=null ) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => URLPAGE(foldernamesmap["folderlink"])));
                        }
                        else{
                          _Nolinkdialog(context);
                        }

                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.launch), // icon
                          Text("Link"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          /*new Text('Description:', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(
            decoration: new InputDecoration(
                hintText: "What's on your mind?"
            ),
          ),
          new Text('Link:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(
            controller: linkCon,
            decoration: new InputDecoration(
                hintText: "Put your link here!"
            ),
          ),*/

          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        Navigator.pop(context);
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => new MainPageFolder(title: "My Gallery",)));
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.keyboard_return), // icon
                          Text("Back"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        // _link = linkCon.text;
                        // print('$_link');
                        if(_link !=null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => URLPAGE(_link)));
                        }
                        else{
                          _Nolinkdialog(context);
                        }
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.launch), // icon
                          Text("Link"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )*/
        ],
      ),
    );
  }
  Future <void> _Nolinkdialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
          title: Text("No Link Available"),
          content: Text("Please fill in the link"),
          actions:[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.keyboard_return),
                  Text('Back')
                ],
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ]
      );
    },
    );
  }
  Future<String> folderAlertDialog(BuildContext context, title){
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

            },
          )
        ],
      );
    });
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
/*class photoname extends StatefulWidget{

  final customFunction;
  final imagepath;
  photoname(this.imagepath,{this.customFunction});
  //photoname(this.imagepath,{this.customFunction});
  @override
  photonameState createState() => new photonameState();
}

class photonameState extends State<photoname>{
  String name;
  List imagedatalist;
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
                  var imag = imageRecord(
                    image_path: "${widget.imagepath}",
                    name: "$name",
                  );
                  imagedatalist = List.from(imagedatalist)..add(imag.dat());
                  print("image data = ${imag.dat()}");
                  print("imagedatalist = $imagedatalist");
                });
              }
              return PhotoThing(name);
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
}*/

/*class MyApp extends StatelessWidget {
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
}*/

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
class imageRecord {
  String image_path, name;

  imageRecord({
    @required this.image_path,
    @required this.name,

  });

  Map<String, dynamic> dat() {
    return {
      "image_path": image_path,
      "name": name,
    };
  }

}