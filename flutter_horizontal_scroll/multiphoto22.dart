import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterhorizontalscroll/horizontalscrollwithdescription.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Gridview of Images'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _imageList = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

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
                _imageList.remove(_selectedIndexList);
                _changeSelection(enable: false, index: -1);
              });
              //_selectedIndexList.sort();
              print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
            }),

      );
      _buttons.add(
        FlatButton(
            child:Text('Cancel'),
            onPressed: () {
              setState(() {
                _selectedIndexList.clear();
                _changeSelection(enable: false, index: -1);
              });
              //Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));

            }),

      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _buttons,
      ),
      body: _createBody(),

    );
  }

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
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
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
    if (_selectionMode) {
      return GridTile(

          header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
            ),
          ),
          child: GestureDetector(
            child: Wrap(
              children: <Widget>[
                Container(

                  //decoration: BoxDecoration(border: Border.all(color: Colors.blue[50], width: 30.0)),
                  child: Image.asset(
                    _imageList[index],
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Text("Foldername"),
                )
              ],
            ),
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
          ));
    } else {
      return GridTile(
        child: GestureDetector(
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    _imageList[index],
                    fit: BoxFit.cover,
                  ),

                ),
                  Container(
                    child: Text("Foldername"),
                )

              ],
            ),
          /*child: Image.asset(
            _imageList[index],
            fit: BoxFit.cover,
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
          onTap: (){
            print("pressed");
            Navigator.push(context,MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription('test')));
          },*/
            onLongPress: () {
              setState(() {
              _changeSelection(enable: true, index: index);
              });
              },
        onTap: (){
          print("pressed");
          Navigator.push(context,MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription('test')));
        },
        ),
      );
    }
  }
}