import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../bloc/userdata.dart';
import '../bloc/firestore_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/strings.dart';
import 'package:random_string/random_string.dart';

enum SortType {
  AtoZ,
  ZtoA,
}

class PagestatusProvider with ChangeNotifier {
  bool _isSelecting = false;
  bool _isFolderDropdown = false;
  String _searchKeyword = "";         //searching keyword
  SortType _sortType = SortType.AtoZ;   //shared preferences
  List<String> _selectedFolders = [];
  List<String> _selectedImages = [];
  File? _imageFile;

  PagestatusProvider();

  bool get isSelecting => _isSelecting;
  bool get isSearching => _searchKeyword != "";
  bool get isFolderDropdown => _isFolderDropdown;
  bool get hasImageFile => _imageFile != null;
  String get searchKeyword => _searchKeyword;
  SortType get sortType => _sortType;
  List<String> get selectedFolders => _selectedFolders;
  List<String> get selectedImages => _selectedImages;
  File? get imageFile => _imageFile;

  set isSelecting(bool selectionmode){
    if(_isSelecting != selectionmode) {
      _isSelecting = selectionmode;
      _selectedFolders = [];
      _selectedImages = [];
      notifyListeners();
    }
  }

  set isFolderDropdown(bool dropdownmode){
    if(_isFolderDropdown != dropdownmode) {
      _isFolderDropdown = dropdownmode;
      notifyListeners();
    }
  }

  set searchKeyword(String keyword){
    if(_searchKeyword != keyword) {
      _searchKeyword = keyword;
      notifyListeners();
    }
  }

  set sortType(SortType sortType){
    if(_sortType != sortType) {
      _sortType = sortType;
      notifyListeners();
    }
  }

  set imageFile(File? image){
    if(_imageFile != image) {
      _imageFile = image;
      notifyListeners();
    }
  }

  void addSelectedFolder(String folderid){
    _selectedFolders.add(folderid);
    notifyListeners();
  }

  void addSelectedImage(String imageid){
    _selectedImages.add(imageid);
    notifyListeners();
  }

  void removeSelectedFolder(String folderid){
    _selectedFolders.remove(folderid);
    notifyListeners();
  }

  void removeSelectedImage(String imageid){
    _selectedImages.remove(imageid);
    notifyListeners();
  }

  void removeAllFolder(){
    _selectedFolders.clear();
    notifyListeners();
  }

  List<String> sortAZ(List<String> nameList) {
    nameList.sort((a,b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
    return nameList;
  }

  List<String> sortZA(List<String> nameList) {
    nameList.sort((a,b) => b.toString().toLowerCase().compareTo(a.toString().toLowerCase()));
    return nameList;
  }

  List<String> sort(List<String> nameList) {
    switch(_sortType) {
      case SortType.AtoZ: return sortAZ(nameList);
      case SortType.ZtoA: return sortZA(nameList);
    }
  }
}