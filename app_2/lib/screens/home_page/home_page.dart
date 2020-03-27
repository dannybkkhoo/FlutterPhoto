import 'package:flutter/material.dart';
import 'image_banner.dart';
import 'folder.dart';
import '../../services/authenticator.dart';
import '../../services/authprovider.dart';

class HomePage extends StatelessWidget{
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  Future<void> _signOut(BuildContext context) async {
    try{
      final Authenticator auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gallery'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            FlatButton(
              child: Text('Log out'),
              onPressed: () => _signOut(context),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              constraints: BoxConstraints.expand(height:40.0,width:200.0),
              child: Text("Recent"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageBanner("assets/images/solar.jpg"),
                ImageBanner("assets/images/solar.jpg"),
                ImageBanner("assets/images/solar.jpg"),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              constraints: BoxConstraints.expand(height:40.0,width:200.0),
              child: Text("1 Month Ago"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageBanner("assets/images/iu.png"),
                ImageBanner("assets/images/iu.png"),
                ImageBanner("assets/images/iu.png"),
              ],
            ),
            Folder("A Folder","22/3/2020",1010),
          ],
        )
    );
  }
}