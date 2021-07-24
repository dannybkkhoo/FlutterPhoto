import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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
}

class CloudStorage2 with ChangeNotifier{
  final _cloudStorage = FirebaseStorage.instance;
  bool _isUploading = false;
  bool _isDownloading = false;
  Map<String, UploadTask> _uploadMap = {};

  FirebaseStorage get cloudStorage => _cloudStorage;
  bool get isUploading => _isUploading;
  bool get isDownloading => _isDownloading;
  Map<String, UploadTask> get uploadMap => _uploadMap;

  Future<void> uploadImage(String path, File file) async {
    _isUploading = true;
    notifyListeners();
    assert(file.existsSync());
    final String filename = basename(path);
    final String ext = file.path.split('.').last; //get extension of file
    final UploadTask uploadTask = _cloudStorage.ref().child(path).putFile(
        file,
        SettableMetadata(
          contentType: 'image/$ext',
        )
    );
    _uploadMap[filename] = uploadTask;
    notifyListeners();
    uploadTask.whenComplete((){
      _uploadMap.remove(filename);
      if(_uploadMap.isEmpty){_isUploading = false;}
      notifyListeners();
    });
  }
}

class uploadBox extends StatelessWidget{
  late  UploadTask _task;
  late String _taskName;
  double height;
  double width;
  uploadBox({Key? key, required String taskName, required UploadTask task, this.height = 30, this.width = 380}): super(key: key) {
    _taskName = taskName;
    _task = task;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0.2, 0.2, 0.2, 0.2),
      height: height,
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final maxWidth = constraints.maxWidth;
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryVariant,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: maxHeight,
            width: maxWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0,0.0,2.0,0.0),
                  height: maxHeight * 0.95,
                  width: maxWidth * 0.6,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_taskName, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis)
                  ),
                ),
                StreamBuilder<TaskSnapshot>(
                  stream: _task.snapshotEvents,
                  builder: (context1, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.active:
                      case ConnectionState.done: {
                        final String progressText;
                        final double progress;
                        progress = snapshot.data != null?((snapshot.data!.bytesTransferred/snapshot.data!.totalBytes)*100).roundToDouble():0;
                        progressText = "${progress.round()}%";
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              padding: EdgeInsets.fromLTRB(2.0, 0.0, 3.0, 0.0),
                              height: maxHeight * 0.5,
                              width: maxWidth * 0.2,
                              child: LinearProgressIndicator(
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onSurface),
                                value: progress/100,
                              )
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(3.0, 0.0, 1.0, 0.0),
                              height: maxHeight * 0.95,
                              width: maxWidth * 0.10,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(progressText, style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis)
                              )
                            )
                          ],
                        );
                      }
                      case ConnectionState.none:
                      default: {
                        return Container(
                          padding: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                          height: maxHeight * 0.95,
                          width: maxWidth * 0.3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Preparing...", style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis)
                          )
                        );
                      }
                    }
                  }
                )
              ],
            )
          );
        }
      ),
    );
  }
}