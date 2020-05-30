import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'horizontalscrollwithdescription.dart';


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
  void deleteFolder(folder){
    if(folder != null) {
      setState(() {
        //folders.add(folder);
        folders = List.from(folders)..remove(folder);
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

  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print('sortyo');
                //new Directory('/data/user/0/com.dreams.flutterhorizontalscroll/app_flutter/$onValue/').delete(recursive: true);
                //print('Deleted folder $onValue');
                //deleteFolder(num.toString());
                //num--;
              },
            ),
            IconButton(
                icon: Icon(Icons.sort_by_alpha),
                onPressed: () {
                  print('sortyo');
                  ShowSortOptions(context);

                },
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                print('Sharings');
                ShowFolderOptions(context);
              },
            ),

          ],
        ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: ()  async {
              createAlertDialog(context).then((onValue) async {
                addFolder( await AppUtil.createFolderInAppDocDir(onValue));
                appendfoldernames(onValue);

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
                      child: Text('  Number of Folders = $num ',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
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
  final String folderName;
  ShowFolder(this.folderName);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}


class _ShowFolderState extends State<ShowFolder>{

  @override

  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Container(
            child: GestureDetector(
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

                    crossAxisAlignment: CrossAxisAlignment.center,
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
          )

        ]
        )
    );
  }
}

/*Widget CreateBody(BuildContext context) {
  return GridView.count(
    crossAxisCount: 3,
    scrollDirection: Axis.vertical,
    //maxCrossAxisExtent: 150.0,
    mainAxisSpacing: 5.0,
    crossAxisSpacing: 5.0,
    shrinkWrap: true,
    padding: const EdgeInsets.all(5.0),
    children: _buildGridTiles(17,context),
  );
}


List<Widget> _buildGridTiles(numberOfTiles, BuildContext context) {
  List<Container> containers = new List<Container>.generate(numberOfTiles,
          (int index) {
        //index = 0, 1, 2,...
        final imageName = index < 9 ?
        'assets/Capture0${index +1}.PNG' : 'assets/Capture${index +1}.PNG';
        return new Container(
          child: Wrap(
            children: <Widget>[

              Container(
                child: GestureDetector(
                  onTap: (){
                    print("pressed");
                    Navigator.push(context,MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription()));
                  },
                  onLongPress: (){
                    print('Got long press detected');
                    /*return GridTile(
                        header: GridTileBar(
                           leading: Icon(
                        Icons.check_circle_outline,
                             color: Colors.black,
                    ),
                    ),
                    );*/
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                            imageName,
                            fit: BoxFit.cover
                        ),

                      ),
                      Text("Foldername"),
                    ],
                  ),
                ),

              ),

            ],
          ),
        );
      });
  return containers;
}*/

class MyApp extends StatelessWidget {
  //Stateless = immutable =  cannot change object's properties
  //Every UI components are widgets
  @override
  Widget build(BuildContext context) {
    //Now we need multiple widgets into a parent = "Container" widget
    //build function returns a "Widget"
    return new MaterialApp(
        title: "",
        home: MainPageFolder(title: "My Gallery",)
    );
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
      return ShowFolder(folderName);
    }
  }
}

