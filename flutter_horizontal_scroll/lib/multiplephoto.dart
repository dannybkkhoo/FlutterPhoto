import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'last2layers.dart';

//Define "root widget"
//void main() => runApp(new MyApp());//one-line function
void main() => runApp(new MyApp());
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
        body:  Container(
          child:Column(
            children: <Widget>[
              SearchPhoto(),
              GridView.extent(
                maxCrossAxisExtent: 150.0,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5.0),
                children: _buildGridTiles(3,context),
              ),
            ],
          )
        )

      /*body: Column(
        children: <Widget>[
          GridView.extent(
            maxCrossAxisExtent: 150.0,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            padding: const EdgeInsets.all(5.0),
            children: _buildGridTiles(3,context),
          ),

        ],
      )*/
      //SearchPhoto(),

    );
  }
}
List<Widget> _buildGridTiles(numberOfTiles, BuildContext context) {
  List<Container> containers = new List<Container>.generate(numberOfTiles,
          (int index) {
        //index = 0, 1, 2,...
        final imageName = index < 9 ?
        'assets/Capture${index +1}.PNG' : 'assets/Capture${index +1}.PNG';
        return new Container(
          child: Wrap(
            children: <Widget>[

              Container(
                child: GestureDetector(
                  onTap: (){
                    print("pressed");
                    Navigator.push(context,MaterialPageRoute(builder: (context) => PhotoThing()));
                  },
                  child: new Image.asset(
                      imageName,
                      fit: BoxFit.cover
                  ),
                ),

              ),

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
        home: new MainPage(title: "GridView of Images")
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
