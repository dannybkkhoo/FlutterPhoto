import 'package:flutter/material.dart';
import 'login_page.dart';
import '../home_page/folder_page.dart';
import '../home_page/horizontalscroll.dart';
import '../home_page/last2layers.dart';
import '../home_page/multiplephoto.dart';
import '../../services/authprovider.dart';
import '../../services/authenticator.dart';
import '../../services/dataprovider.dart';
import '../../services/utils.dart';

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
          screen = MainPageFolder(title: "Home Page", onSignedOut: _signedOut);break;
        case FolderDescription_Page:
          screen = DescriptionFolder(arguments['folder_id']);break;
        case File_Page:
          screen = MainPage(arguments['folder_id']);break;
        case Photo_Page:
          screen = PhotoThing(arguments['folder_id']);break;
        case Test_Page:
          screen = TestPage();break;
        default:
          screen = LoginPage(onSignedIn: _signedIn);
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}