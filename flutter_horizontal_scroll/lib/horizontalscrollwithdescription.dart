import 'package:flutter/material.dart';
import 'package:flutterhorizontalscroll/multiplephoto.dart';
import 'package:intl/intl.dart';

import 'CreateFolder.dart';
void main() => runApp(MaterialApp(
    home:Scaffold(
            appBar: AppBar(
                  title: Text('FREAKS!'),
        centerTitle: true,
        backgroundColor: Colors.black,
        ),

        body:
        Container(
          child: Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 240,

                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    PhotoPreviewFunctionwithDes("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                    PhotoPreviewFunctionwithDes("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                    PhotoPreviewFunctionwithDes("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                    PhotoPreviewFunctionwithDes("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                    PhotoPreviewFunctionwithDes("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                    PhotoPreviewFunctionwithDes("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

                  ],
                ),
              ),
              DescriptionFolder(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

            ],
          ),
        )
        ),
        ));
class HorizontalScrollWithDescription extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        child: Wrap(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 240,

              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PhotoPreviewFunctionwithDes("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                  PhotoPreviewFunctionwithDes("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                  PhotoPreviewFunctionwithDes("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                  PhotoPreviewFunctionwithDes("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                  PhotoPreviewFunctionwithDes("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
                  PhotoPreviewFunctionwithDes("assets/Capture3.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

                ],
              ),
            ),
            DescriptionFolder(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

          ],
        ),
      )
    );
  }
}
class PhotoPreviewFunctionwithDes extends StatelessWidget{
  final _imagePath, _datetime;

  //PhotoPreviewFunctionwithDes();
  PhotoPreviewFunctionwithDes(this._imagePath, this._datetime);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350.0,
        height: 260.0,

        child: Card(
            child: Wrap(
                children: <Widget>[
                  Container(

                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => MainPage(title: "GridView of Images")));
                      },
                      child: Image.asset(_imagePath),
                    ),
                  ),

                ]
            )
        )



    );
  }
}
class DescriptionFolder extends StatelessWidget{
  final _datetime;

  //PhotoPreviewFunctionwithDes();
  DescriptionFolder(this._datetime);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,

      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text('Folder Name:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(

            decoration: new InputDecoration(
                hintText: "Give your folder a name!"
            ),
          ),
          new Text('Date: $_datetime', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.justify),

          new Text('Description:', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(
            decoration: new InputDecoration(
                hintText: "What's on your mind?"
            ),
          ),
          new Text('Link:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
          new TextField(
            decoration: new InputDecoration(
                hintText: "Where is this place?"
            ),
          ),
          SizedBox.fromSize(
            size: Size(56, 56), // button width and height
            child: ClipOval(
              child: Material(
                color: Colors.red, // button color
                child: InkWell(
                  splashColor: Colors.white, // splash color
                  onTap: () => print('Delete'), // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete), // icon
                      Text("Delete"), // text
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}







