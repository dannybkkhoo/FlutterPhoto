import '../providers/userdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/top_level_providers.dart';
import '../bloc/userdata.dart';
import '../app_router.dart';
import '../screens/loading_page.dart';
import '../screens/error_page.dart';
import '../constants/strings.dart';
import '../constants/images.dart';
import '../bloc/screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../bloc/cloud_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum InitStatus {
  none,
  retrievingUserdata,
  downloadingImage,
  done,
  error,
}

class InitializationProvider with ChangeNotifier {
  late CloudStorageProvider _cloudprovider;
  late UserdataProvider _userprovider;
  InitStatus _status = InitStatus.none;
  double _percent = 0.00;
  int _totalNumOfFolders = 0;
  int _totalNumOfImages = 0;
  int _numOfFoldersCompleted = 0;
  int _numOfImagesCompleted = 0;
  int _numOfImagesInFolder = 0;
  int _numOfImagesCompletedInFolder = 0;

  InitializationProvider(this._cloudprovider,this._userprovider);

  InitStatus get status => _status;
  double get percent => _percent;
  int get totalNumOfFolders => _totalNumOfFolders;
  int get totalNumOfImages => _totalNumOfImages;
  int get numOfFoldersCompleted => _numOfFoldersCompleted;
  int get numOfImagesCompleted => _numOfImagesCompleted;
  int get numOfImagesCompletedInFolder => _numOfImagesCompletedInFolder;

  Future<bool> initializeAndLoad() async {
    _status = InitStatus.retrievingUserdata;
    notifyListeners();

    await _userprovider.Init();
    if(!_userprovider.hasRetrieved || (_userprovider.uid?.isEmpty ?? true) || (_userprovider.userdata == null)){
      _status = InitStatus.error;
      notifyListeners();
      return false;
    }
    try{
      _status = InitStatus.downloadingImage;
      notifyListeners();

      String uid = _userprovider.uid!;
      Userdata userdata = _userprovider.userdata!;
      Map<String,Folderdata> folders = userdata.folders;
      Map<String,Imagedata> images = userdata.images;
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = "";

      _totalNumOfFolders = _userprovider.numOfFolders;
      _totalNumOfImages = _userprovider.numOfImages;
      _numOfFoldersCompleted = 0;
      _numOfImagesCompleted = 0;
      _numOfImagesInFolder = 0;
      _numOfImagesCompletedInFolder = 0;

      for(String foldername in folders.keys) {
        _numOfImagesInFolder = folders[foldername]!.imagelist.length;
        _numOfImagesCompletedInFolder = 0;
        for(String imagename in folders[foldername]?.imagelist??[]) {
          path = uid + "/images/" + imagename + "." + images[imagename]!.ext;
          print(appDocDir.path + "/" + path);
          if(!File(appDocDir.path + "/" + path).existsSync()){
            await _cloudprovider.downloadImage(path);
          }
          _numOfImagesCompletedInFolder++;
          _numOfImagesCompleted++;
          _percent = double.parse((_numOfImagesCompleted/_totalNumOfImages).toStringAsFixed(2));
          notifyListeners();
        }
        _numOfFoldersCompleted++;
        notifyListeners();
      }
      _status = InitStatus.done;
      notifyListeners();
      return true;
    } on Exception catch (e){
      print(e);
      _status = InitStatus.error;
      notifyListeners();
      return false;
    }
  }
}