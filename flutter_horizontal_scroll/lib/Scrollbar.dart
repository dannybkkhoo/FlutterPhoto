import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DraggableScrollBarDemo(
    title: 'Draggable Scroll Bar Demo',
  ));
}

class DraggableScrollBarDemo extends StatelessWidget {
  final String title;

  const DraggableScrollBarDemo({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
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
  ScrollController _semicircleController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title)) ,
        body: SemicircleDemo(controller: _semicircleController),

      );

  }
}

class SemicircleDemo extends StatelessWidget {
  static int numItems = 1000;
  final ScrollController controller;
  const SemicircleDemo({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar.semicircle(
      labelTextBuilder: (offset) {
        final int currentItem = controller.hasClients
            ? (controller.offset /
            controller.position.maxScrollExtent *
            numItems)
            .floor()
            : 0;

        return Text("$currentItem");
      },
      labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
      controller: controller,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        controller: controller,
        padding: EdgeInsets.zero,
        itemCount: numItems,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2.0),
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}

Widget SearchFolder(BuildContext context) {
  return Container(

    margin: EdgeInsets.only(left: 10, right: 10,top: 20),
    child: TextField(
      onChanged:(text){
        filterSearchResults(text);
        print('Current on change text is $text');
      },
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

