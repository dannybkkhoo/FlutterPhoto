import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'horizontalcontainers.dart';

void main() => runApp(MaterialApp(
    home:Scaffold(
      appBar: AppBar(
        title: Text('FREAKS!'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body:
      Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 140,

        child: Column(
        children : [ ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
            PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
            PhotoPreviewFunction("assets/Capture3.PNG",  DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
            PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
            PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
            PhotoPreviewFunction("assets/Capture3.PNG",  DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 140,

          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture3.PNG",  DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture1.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture2.PNG", DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),
              PhotoPreviewFunction("assets/Capture3.PNG",  DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()),

            ],
          ),
        ),
        ]
      ),
      )


      /*body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin:EdgeInsets.only(left:20),
              child: Text("Favourites",style:TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30
                  ),
                ),
              ),
            ),


        ],
      )*/
    )


));