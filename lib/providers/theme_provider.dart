import '../themes/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeType _type;
  ThemeData _theme = ThemeData();         //initialize as normal ThemeData just to avoid _theme == null

  ThemeProvider([this._type = ThemeType.LightPurple]){
    _theme = AppTheme.fromType(_type).toThemeData();
  }

  ThemeData get theme => _theme;

  void changeTheme(ThemeType t){
    _theme = AppTheme.fromType(t).toThemeData();
    notifyListeners();
  }

  void setTheme(ThemeData theme){
    _theme = theme;
    notifyListeners();
  }
}