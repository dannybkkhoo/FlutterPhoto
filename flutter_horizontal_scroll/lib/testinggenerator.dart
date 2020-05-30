import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'horizontalscrollwithdescription.dart';
import 'Showfolder.dart';


void main() => runApp(MaterialApp(

  initialRoute: '/Page1',
  routes: <String, WidgetBuilder>{
    '/Page1': (context) => MainPageFolder(title: "My Gallery",),

  },
));


//Now use stateful Widget = Widget has properties which can be changed
class MainPageFolder extends StatefulWidget {
  //MainPageFolder({Key key}) : super(key:key);

  final String title;
  //Custom constructor, add property : title
  @override
  MainPageFolder({this.title}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageFolderState();//Return a state object
  }
}
class MainPageFolderState extends State<MainPageFolder> {
  //State must have "build" => return Widget
  List<Widget> folders = new List<Widget>();
  List<String> foldernames = new List<String>();
  bool _selectionMode = false;
  void parentChange(newbool) {
    setState(() {
      _selectionMode = newbool;
    });
  }

  int num = 0;
  void appendfoldernames(onValue){
    if(onValue != null) {
      setState(() {
        //folders.add(folder);
        foldernames = List.from(foldernames)..add(onValue);
        print(foldernames);
        print(foldernames.length);
      });
    }
  }
  void addFolder(ShowFolder folder){

    if(folder != null) {
      setState(() {
        //folders.add(folder);
        folders = List.from(folders)..add(folder);
        print(folders);
      });
    }
  }



  void deleteFolder(ShowFolder folder){
    if(folder != null) {
      setState(() {
       folders = List.from(folders)..remove(folder);
       num--;
       print(num);
        print(folders);
      });
    }
  }

  Future<String> createAlertDialog(BuildContext context){
    TextEditingController foldernameController = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Folder Name?"),
        content: TextField(
          controller: foldernameController ,
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
              Navigator.of(context).pop(foldernameController.text.toString());
              num++;

            },
          )
        ],
      );
    });
  }


  @override
  bool isSort = true;

  void sort(List folders) {
    foldernames.sort((a, b) => isSort ? a.compareTo(b) : b.compareTo(a));
    isSort = !isSort;

  }


  List SortedFolders;
  @override
  void initState(){
    super.initState();
    SortedFolders = foldernames;
  }

  Widget build(BuildContext context) {
    List<Widget> _buttons = List();
    if (_selectionMode) {
      _buttons.add(
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                print('delete button pressed');
                createAlertDialog(context).then((onValue) async {
                  AppUtil.deletefolderInAppDocDir(onValue);
                  deleteFolder(ShowFolder(onValue,customFunction: parentChange));
                  SelectionList._selectedIndexList.sort();
                  //SelectionList._changeSelection(index: -1);
                });
              });

            }),

      );
      _buttons.add(
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            print('Sharings');
            ShowFolderOptions(context);
          },
        ),);
      /*_buttons.add(
        FlatButton(
            child:Text('Cancel'),
            onPressed: () {
              setState(() {
                SelectionList._selectedIndexList.clear();
                SelectionList._changeSelection(index: -1);
                _selectionMode =false;

                print("Selection list after cancel =${SelectionList._selectedIndexList}");
              });
              //Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));

            }),

      );*/
    }
    else{
      _buttons.add(
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
        onPressed: () {
          //ShowSortOptions(context);
          sort(foldernames);
          setState(() {
            foldernames = SortedFolders;
          });
          print('Sorted list = $foldernames');
          print("From class A: $_selectionMode");
        },
      ),);

    }
    // TODO: implement build
    return new Scaffold(

        appBar: new AppBar(
          title: new Text(widget.title),
          actions: _buttons,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()  async {
            createAlertDialog(context).then((onValue) async {
              if(onValue != null){
                AppUtil.createFolderInAppDocDir(onValue);

                if(foldernames.contains(onValue)){
                  print('Nope');
                  print(foldernames);
                  return null;
                }
                else{
                  appendfoldernames(onValue);
                  addFolder(ShowFolder(onValue,customFunction: parentChange));
                }

              }

            });
            //addFolder( await AppUtil.createFolderInAppDocDir(num.toString()));

          },
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text("New Folder"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.amberAccent,
        ),
        body: SingleChildScrollView(
          child: Container(
              child:Column(
                children: <Widget>[
                  SearchFolder(),
                  Container(

                      alignment: Alignment.topLeft,
                      child: Text('  Number of Folders = ${folders.length} ',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                      )

                  ),

                  GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: folders,
                  ),

                ],
              )
          ),
        )

    );
  }
}
class ShowFolder extends StatefulWidget {
  String folderName;
  final customFunction;
  ShowFolder(this.folderName, {this.customFunction});
  @override
  _ShowFolderState createState() => _ShowFolderState();
}

class SelectionList {
  SelectionList._();
  static var _selectedIndexList = [];
  /*static void _changeSelection({int index}) {

    SelectionList._selectedIndexList.add(index);
    if (index == -1) {
      SelectionList._selectedIndexList.clear();
    }
  }*/


}
class _ShowFolderState extends State<ShowFolder>{
  @override
  //int index = 0;
  bool _FselectionMode = false;

  Widget build(BuildContext context) {
    if (_FselectionMode){
      return Container(
          child: Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[

                    Container(
                      child: GestureDetector(
                        onLongPress: (){
                          widget.customFunction(false);
                          setState(() {
                            _FselectionMode = false;
                            SelectionList._selectedIndexList.clear();
                            //SelectionList._changeSelection(index: 0);
                            print("Selection list after cancel =${SelectionList._selectedIndexList}");
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
                          setState(() {
                            if (SelectionList._selectedIndexList.contains(widget.folderName)) {
                              SelectionList._selectedIndexList.remove(widget.folderName);
                            } else {
                              SelectionList._selectedIndexList.add(widget.folderName);
                            }
                            print(SelectionList._selectedIndexList);
                          });
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
                      child: Icon(
                        SelectionList._selectedIndexList.contains(widget.folderName) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                        color: SelectionList._selectedIndexList.contains(widget.folderName) ? Colors.green : Colors.black,
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
                    onLongPress: (){
                      widget.customFunction(true);
                      setState(() {
                        _FselectionMode = true;
                        //SelectionList._changeSelection(index: index);
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

class SearchFolder extends StatelessWidget{
  //final _imagepath;
  SearchFolder();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10,top: 20),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search Folder",
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

void ShowFolderOptions(BuildContext context) async{
  final items = <MultiSelectDialogItem<int>>[
    MultiSelectDialogItem(1, 'Name'),
    MultiSelectDialogItem(2, 'Date'),
    MultiSelectDialogItem(3, 'Description'),
    MultiSelectDialogItem(4, 'Link'),
  ];

  final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context){
        return MultiSelectDialog(
          items: items,
          //initialSelectedValues: [1].toSet(),
        );
      }
  );
}
class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
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
      title: Text('Sharing Options'),
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

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
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

class AppUtil{
  static Future<ShowFolder> createFolderInAppDocDir(String folderName) async {
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');

    if(await _appDocDirFolder.exists()){
      print("Already Created Folder in: $_appDocDirFolder");
      return null;
    }
    else{
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive:true);
      print("Created new folder: $_appDocDirFolder");
      //return ShowFolder(folderName, customFunction: parentChange);
    }
  }
  static Future<ShowFolder> deletefolderInAppDocDir(String folderName) async{
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');
    if(await _appDocDirFolder.exists()){
      final Directory _appDocDirNewFolder = await _appDocDirFolder.delete(recursive:true);
      print("Deleted Folder $folderName in: $_appDocDirFolder");
      //return ShowFolder(folderName);;
    }
    else{
      print("Folder does not exist ");
      return null;
    }
  }
}

