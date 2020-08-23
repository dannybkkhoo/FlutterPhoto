import 'package:app2/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:app2/services/authprovider.dart';
import 'package:app2/services/authenticator.dart';
import 'package:app2/services/dataprovider.dart';
import 'package:app2/services/userdata.dart';
import 'package:app2/screens/login_page/login_page.dart';
import 'package:app2/screens/login_page/image_page.dart';
import 'package:app2/screens/home_page/folder_page.dart';
import 'package:app2/services/utils.dart';
import 'package:app2/screens/home_page/horizontalscroll.dart';
import 'package:app2/screens/home_page/multiplephoto.dart';

const Folder_Page = "/";
const FolderDescription_Page = "/FolderDescription";
const File_Page= "/Files";
const FileDescription_Page = "/FileDescription";
const Test_Page = "/Test";

enum AuthStatus {
  notDetermined,
  notSignedIn,
  SignedIn,
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Authenticator auth = AuthProvider.of(context).auth;
    auth.getUID().then((String userID) {
      setState(() {
        authStatus = userID == null ? AuthStatus.notSignedIn : AuthStatus.SignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SignedIn;
    });
  }
  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return WaitingScreen(_signedOut);
        break;
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.SignedIn:
        return DataProvider(
          child: Navigator(
            onGenerateRoute: _HomeRoutes(),
          )
        );
//        return DataProvider(
//            child: MainPageFolder(
//              title: "Folder Page",
//              onSignedOut: _signedOut,
//            ),
//            child: ImagePage(
//              onSignedOut: _signedOut,
//            )
//        );
        break;
      default:
        return ErrorScreen(_signedOut);
    }
  }

  RouteFactory _HomeRoutes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch(settings.name){
        case Folder_Page:
          screen = MainPageFolder(title: "Home Page", onSignedOut: _signedOut,);break;
        case FolderDescription_Page:
          screen = DescriptionFolder(arguments['folder_id']);break;
        case File_Page:
          screen = MainPage(arguments['folder_id']);break;
        case Test_Page:
          screen = TestPage();break;
        default:
        //screen = RootPage();
          screen = HorizontalScroll("111");
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}