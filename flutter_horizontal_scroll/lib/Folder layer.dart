import 'package:flutter/material.dart';
import 'horizontalscrollwithdescription.dart';
import 'main.dart';
void main() => runApp(new MyApp());
//Now use stateful Widget = Widget has properties which can be changed
class MainPageFolder extends StatefulWidget {
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
            onPressed: () async {
              //addFolder( await AppUtil.createFolderInAppDocDir(a));
              //addFolder( await AppUtil.createFolderInAppDocDir(b));
              //num++;
            },
            icon: Icon(Icons.add, color: Colors.black,),
            label: Text("New Folder"),
            foregroundColor: Colors.black,
            backgroundColor: Colors.amberAccent,
          ),
        body:  Container(
            child:Column(
              children: <Widget>[
                SearchFolder(),
                Container(
                    alignment: Alignment.topLeft,
                   child: Text('  Number of Folders = ',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                          )

                ),
                CreateBody(context),
              ],
            )
        )


    );
  }
}

Widget CreateBody(BuildContext context) {
  return GridView.extent(
    maxCrossAxisExtent: 150.0,
    mainAxisSpacing: 5.0,
    crossAxisSpacing: 5.0,
    shrinkWrap: true,
    padding: const EdgeInsets.all(5.0),
    children: _buildGridTiles(9,context),
  );
}
List<Widget> _buildGridTiles(numberOfTiles, BuildContext context) {
  List<Container> containers = new List<Container>.generate(numberOfTiles,
          (int index) {
        //index = 0, 1, 2,...
        final imageName = index < 9 ?
        'assets/Capture0${index +1}.PNG' : 'assets/Capture0${index +1}.PNG';
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
                  /*child: new Image.asset(
                      imageName,
                      fit: BoxFit.cover
                  ),*/
                ),

              ),
              /*Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Foldername",
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),*/
            ],
          ),
        );
      });
  return containers;
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
        home: new MainPageFolder(title: "My Gallery",)
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

