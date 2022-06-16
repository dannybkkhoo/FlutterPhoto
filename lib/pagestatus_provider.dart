import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'userdata.dart';
import 'firestore_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'strings.dart';
import 'package:random_string/random_string.dart';

class PagestatusProvider with ChangeNotifier {
  bool _selectionMode = false;
  List<String> _selectedFolders = [];
  List<String> _selectedImages = [];
  String sorting = "A-Z";  //shared preferences

  PagestatusProvider();

  bool get selectionMode => _selectionMode;
  List<String> get selectedFolders => _selectedFolders;
  List<String> get selectedImages => _selectedImages;

  set selectionMode(bool selectionmode){
    _selectionMode = selectionmode;
    _selectedFolders = [];
    _selectedImages = [];
    notifyListeners();
  }

  void addSelectedFolder(String folderid){
    _selectedFolders.add(folderid);
    notifyListeners();
  }

  void addSelectedImage(String imageid){
    _selectedImages.add(imageid);
    notifyListeners();
  }

  void removeSelectedFolder(String folderid) {
    _selectedFolders.remove(folderid);
    notifyListeners();
  }

  void removeSelectedImage(String imageid){
    _selectedImages.remove(imageid);
    notifyListeners();
  }

}