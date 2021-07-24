import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';

class CloudStorage with ChangeNotifier{
  final _cloudStorage = FirebaseStorage.instance;
  bool _isUploading = false;
  bool _isDownloading = false;
  String? _error = null;
  int _bytesTransferred = 0;
  int _totalTransferring = 0;
  

  FirebaseStorage get cloudStorage => _cloudStorage;
  bool get isUploading => _isUploading;
  bool get isDOwnloading => _isDownloading;
  String? get error => _error;
  int get bytesTransferred => _bytesTransferred;
  int get totalTransferring => _totalTransferring;

  Future<void> uploadImage(String path, File file) async {
    try {
      _isUploading = true;
      _error = null;
      notifyListeners();
      assert(file.existsSync());  //make sure the file exists
      final String ext = file.path.split('.').last; //get extension of file
      final UploadTask uploadTask = _cloudStorage.ref().child(path).putFile(
        file,
        SettableMetadata(
          contentType: 'image/$ext',
        )
      );
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        _bytesTransferred = snapshot.bytesTransferred;
        _totalTransferring = snapshot.totalBytes;
        notifyListeners();
        print("Uploading: ${file.path.split('/').last}(${((snapshot.bytesTransferred/snapshot.totalBytes)*100).toStringAsFixed(2)})%");
      });
      await uploadTask;
    }
    catch (e) {
      _error = e.toString();
      print(e);
    }
    _isUploading = false;
    notifyListeners();
  }

  Future<File> downloadImage(String path) async {
    try{

    }
  }
}