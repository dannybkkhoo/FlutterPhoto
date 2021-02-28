import 'package:flutter/material.dart';
import '../layer_2/login_page.dart';
import '../layer_3/loading_page.dart';
import '../layer_4/folder_page.dart';
import '../layer_5/multiplephoto.dart';
import '../layer_6/last2layers.dart';
import '../unused/horizontalscroll.dart';
import '../../services/utils.dart';
import '../../services/authentication/authprovider.dart';
import '../../services/authentication/authenticator.dart';
import '../../services/local_storage/dataprovider.dart';

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
        return Navigator(
            onGenerateRoute: _HomeRoutes(),
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
        case Loading_Page:
          screen = LoadingPage();break;
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