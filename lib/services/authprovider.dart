import 'package:flutter/material.dart';
import 'authenticator.dart';

class AuthProvider extends InheritedWidget {
  final Authenticator auth;
  const AuthProvider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }
}
