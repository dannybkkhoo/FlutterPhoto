import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CloudStorage with ChangeNotifier{
  final _cloudStorage = FirebaseStorage.instance;
  bool _isUploading = false;
  bool _isDownloading = false;
  Map<String, UploadTask> _uploadMap = {};
  Map<String, Map<String, dynamic>> _uploadParam = {};
  Map<String, Object?> _uploadException = {};
  Map<String, DownloadTask> _downloadMap = {};
  Map<String, Map<String, dynamic>> _downloadParam = {};
  Map<String, Object?> _downloadException = {};

  FirebaseStorage get cloudStorage => _cloudStorage;
  bool get isUploading => _isUploading;
  bool get isDownloading => _isDownloading;
  Map<String, UploadTask> get uploadMap => _uploadMap;
  Map<String, Map<String, dynamic>> get uploadParam => _uploadParam;
  Map<String, Object?> get uploadException => _uploadException;
  Map<String, DownloadTask> get downloadMap => _downloadMap;
  Map<String, Map<String, dynamic>> get downloadParam => _downloadParam;
  Map<String, Object?> get downloadException => _downloadException;

  Future<void> uploadImage(String firebasePath, File file) async {  //firebasePath w/o extension, extract extension from file
    final String filename = basename(firebasePath); //get filename w/o extension and path
    final String ext = file.path.split('.').last;   //get extension of file

    _isUploading = true;
    _uploadParam.remove(filename);       //reset
    _uploadException.remove(filename);  //reset
    notifyListeners();

    assert(file.existsSync());
    final UploadTask uploadTask = _cloudStorage.ref().child("$firebasePath").putFile( //eg. uid123/photos/testing
        file,
        SettableMetadata(
          contentType: 'image/$ext',  //eg. image/jpg
        )
    );
    _uploadMap[filename] = uploadTask;  //eg. {"testing":uploadTask}
    notifyListeners();

    uploadTask
      .catchError((Object e){
      _uploadParam[filename] = {"firebasePath":firebasePath,"file":file};  //to retry if needed
      _uploadException[filename] = e;       //to indicate failure and to check exception
      notifyListeners();
    })
      .whenComplete((){
      if(!_uploadParam.containsKey(filename)){_uploadMap.remove(filename);}
      if(_uploadMap.isEmpty){_isUploading = false;}
      notifyListeners();
    });
  }

  Future<void> downloadImage(String firebasePath) async {   //firebasePath w/o extension
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filename = basename(firebasePath);
    File downloadToFile = File("${appDocDir.path}/$filename");  //eg. /data/user/0/com.fiftee.app2/app_flutter/testing

    _isDownloading = true;
    _downloadParam.remove(filename);       //reset
    _downloadException.remove(filename);  //reset
    notifyListeners();

    final DownloadTask downloadTask = _cloudStorage.ref("$firebasePath").writeToFile(downloadToFile);
    _downloadMap[filename] = downloadTask;
    notifyListeners();

    downloadTask.then((_) => throw(Exception("lol")))
      .catchError((Object e){
      _downloadParam[filename] = {"firebasePath":firebasePath};  //to retry if needed
      _downloadException[filename] = e;       //to indicate failure and to check exception
      notifyListeners();
    })
      .whenComplete((){
      if(!_downloadParam.containsKey(filename)){_downloadMap.remove(filename);}
      if(_downloadMap.isEmpty){_isDownloading = false;}
      notifyListeners();
    });
  }
}

class taskBox extends ConsumerWidget{
  late UploadTask? _utask = null;
  late DownloadTask? _dtask = null;
  late String _taskName;
  late String _mode;
  late CloudStorage _ref;
  double height;
  double width;
  taskBox.upload({Key? key, required String taskName, required UploadTask task, required CloudStorage ref, this.height = 30, this.width = 380}): super(key: key) {
    _taskName = taskName;
    _utask = task;
    _ref = ref;
    _mode = "Upload";
  }
  taskBox.download({Key? key, required String taskName, required DownloadTask task, required CloudStorage ref, this.height = 30, this.width = 380}): super(key: key) {
    _taskName = taskName;
    _dtask = task;
    _ref = ref;
    _mode = "Download";
  }



  @override
  Widget build(BuildContext context, ScopedReader watch){
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
                  stream: _utask != null? _utask!.snapshotEvents:_dtask!.snapshotEvents,
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
                            if((_mode == "Upload" && _ref._uploadException.containsKey(_taskName)) || (_mode == "Download" && _ref._downloadException.containsKey(_taskName)))
                              Container(
                                  padding: EdgeInsets.fromLTRB(3.0, 0.0, 1.0, 0.0),
                                  height: maxHeight * 0.95,
                                  width: maxWidth * 0.10,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                      //child: Text(progressText, style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis)
                                    child: Row(
                                      children:[
                                        Container(
                                          height: maxHeight*0.95,
                                          width: maxWidth*0.05,
                                          child: ElevatedButton(
                                            onPressed: () => print("LOL"),
                                            child: Text("Retry", style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Container(
                                          height: maxHeight*0.95,
                                          width: maxWidth*0.05,
                                          child: ElevatedButton(
                                            onPressed: () => print("LOL"),
                                            child: Text("Cancel", style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis),
                                          ),
                                        )
                                      ]
                                    )
                                  )
                              )
                            else
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