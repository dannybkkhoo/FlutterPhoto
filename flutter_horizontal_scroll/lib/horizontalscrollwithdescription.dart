import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterhorizontalscroll/multiplephoto.dart';
import 'package:intl/intl.dart';
import 'lauchurl.dart';
/*void main() => runApp(MaterialApp(
    home: HorizontalScrollWithDescription()
        ));*/
class HorizontalScrollWithDescription extends StatelessWidget{
  final _foldername;
  HorizontalScrollWithDescription(this._foldername);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
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
              DescriptionFolder(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(), _foldername),

            ],
          ),
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
class Desdetails {
   String _Des;
  String _link;


}

class DescriptionFolder extends StatefulWidget{
  final String _datetime, _foldername;
  DescriptionFolder(this._datetime, this._foldername);

  @override
  DescriptionFolderState createState() => new DescriptionFolderState();



}
class DescriptionFolderState extends State<DescriptionFolder>{

  final linkCon = new TextEditingController();
  //String _Des ;
  //var _link ;
  Desdetails detials = new Desdetails();
  final GlobalKey<DescriptionFolderState> _deskeyvalue = new GlobalKey<DescriptionFolderState>();
  @override

  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,

      child: new Column(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text('Folder Name: ${widget._foldername}',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),

          new Text('Date: ${widget._datetime}', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.justify),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                key: _deskeyvalue,
                child: Text(detials._Des != null? 'Description: ${detials._Des}':'Description: No Description', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
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
                              detials._Des = onValue;
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
                child: Text(detials._link != null? 'Link: ${detials._link}':'Link: No Link', textAlign: TextAlign.left,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),
              ),
              SizedBox.fromSize(
                size: Size(46, 56), // button width and height
                child: ClipRect(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        createAlertDialog(context, "Link").then((onValue) async {
                          if( onValue != null) {
                            setState(() {
                              detials._link = onValue;

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

          Row(
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

              /*SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.white, // splash color
                      onTap: () {
                        //_link = linkCon.text;
                        print('$_link');
                        Navigator.push(context,MaterialPageRoute(builder: (context) => URLPAGE(_link)));
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
              )*/
            ],
          )
        ],
      ),
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

            },
          )
        ],
      );
    });
  }
}



enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: const Text('No',
              style: TextStyle(
             color: Colors.blue,
            ),
             ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}