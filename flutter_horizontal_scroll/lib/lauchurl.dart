import 'package:flutter/material.dart';
import 'package:flutterhorizontalscroll/deletebutoon.dart';
import 'package:url_launcher/url_launcher.dart';

class URLPAGE extends StatefulWidget{
  final url;
  URLPAGE(this.url);
 @override
  URLPAGEState createState() => URLPAGEState();
}

class URLPAGEState extends State<URLPAGE>{

  Future launchURL(String url) async{
    if( await canLaunch(url)){
      await launch(url, forceSafariVC: true, forceWebView: true);
    }
    else{
      _ackAlert(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
       appBar: AppBar(
           title: Text('Webview'),
        ),
      body: Center(
       child: Column(
          children: <Widget>[
           Container(
              padding: EdgeInsets.all(10.0),
             child: Text(widget.url),
              ),
            RaisedButton(
              child: Text('Open Link'),
              onPressed: (){
                launchURL(widget.url);
              },
            )
              ],
              )
              )
      );
    }
  }


Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('OPPS!'),
        content: const Text('The link is not available'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}