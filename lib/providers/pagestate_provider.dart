import 'package:flutter/foundation.dart';

enum PageStatus {
  normal,     //normal, default state
  selection,  //user wants to select items
}

class PagestateProvider with ChangeNotifier {
  PageStatus _pagestatus = PageStatus.normal;
  Map<String, String> _selectedFolders = {};
  Map<String, String> _selectedImages = {};

  PageStatus get pagestatus => _pagestatus;
  Map<String, String> get selectedFolders => _selectedFolders;
  Map<String, String> get selectedImages => _selectedImages;

  set pagestatus(PageStatus status){
    _pagestatus = status;
    notifyListeners();
  }
  set selectedFolders(Map<String,String> map){
    _selectedFolders = map;
    notifyListeners();
  }
  set selectedImages(Map<String,String> map){
    _selectedImages = map;
    notifyListeners();
  }
}