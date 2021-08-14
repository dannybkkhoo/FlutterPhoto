import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    _uploadParam.remove(filename);      //reset
    _uploadException.remove(filename);  //reset
    notifyListeners();

    assert(file.existsSync());
    final UploadTask uploadTask = _cloudStorage.ref().child("$firebasePath").putFile( //eg. uid123/photos/testing
        file,
        SettableMetadata(
          contentType: 'image/$ext',    //eg. image/jpg
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

    downloadTask//.then((_) => throw(Exception("lol")))
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

  void cancelUpload(String filename){
    if(_uploadMap.containsKey(filename)){
      if(_uploadParam.containsKey(filename))
        _uploadParam.remove(filename);
      if(_uploadException.containsKey(filename))
        _uploadException.remove(filename);
      _uploadMap.remove(filename);
      if(_uploadMap.isEmpty){_isUploading = false;}
      notifyListeners();
    }
  }

  void cancelDownload(String filename){
    if(_downloadMap.containsKey(filename)){
      if(_downloadParam.containsKey(filename))
        _downloadParam.remove(filename);
      if(_downloadException.containsKey(filename))
        _downloadException.remove(filename);
      _downloadMap.remove(filename);
      if(_downloadMap.isEmpty){_isDownloading = false;}
      notifyListeners();
    }
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

  void _uploadImage(){
    if(_ref.uploadParam.containsKey(_taskName) && _ref.uploadParam[_taskName] != null)
      _ref.uploadImage(_ref.uploadParam[_taskName]!["firebasePath"],_ref.uploadParam[_taskName]!["file"]);
  }

  void _downloadImage(){
    if(_ref.downloadParam.containsKey(_taskName) && _ref.downloadParam[_taskName] != null)
      _ref.downloadImage(_ref.downloadParam[_taskName]!["firebasePath"]);
  }

  void _cancelUpload(){
    _ref.cancelUpload(_taskName);
  }

  void _cancelDownload(){
    _ref.cancelDownload(_taskName);
  }

  @override
  Widget build(BuildContext context, ScopedReader watch){
    final _cloudStorageProvider = ChangeNotifierProvider<CloudStorage>((ref) => _ref);
    final cloud = watch(_cloudStorageProvider);
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5.0,0.0,0.0,0.0),
                  height: maxHeight * 0.95,
                  width: maxWidth * 0.08,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      _mode == "Upload"? Icons.file_upload:Icons.file_download,
                      color: Theme.of(context).colorScheme.surface,
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0,0.0,1.0,0.0),
                  height: maxHeight * 0.95,
                  width: maxWidth * 0.47,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_taskName, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis)
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(1.0,0.0,2.0,0.0),
                  height: maxHeight * 0.95,
                  width: maxWidth * 0.45,
                  child: Align(
                    alignment:  Alignment.centerRight,
                    child: StreamBuilder<TaskSnapshot>(
                      stream: _utask != null? _utask!.snapshotEvents:_dtask!.snapshotEvents,
                      builder: (context1, snapshot){
                        final String progressText;
                        final double progress;
                        progress = snapshot.data != null?((snapshot.data!.bytesTransferred/snapshot.data!.totalBytes)*100).roundToDouble():0;
                        progressText = "${progress.round()}%";
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting:
                          case ConnectionState.active: {
                            if(progress != 100){  //before done
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if( !( (_mode == "Upload" && cloud._uploadException.containsKey(_taskName)) || (_mode == "Download" && cloud._downloadException.containsKey(_taskName)) ) ) //if no error
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 2.0, 0.0),
                                          height: maxHeight * 0.2,
                                          width: maxWidth * 0.23,
                                          child: LinearProgressIndicator(
                                            backgroundColor: Theme.of(context).colorScheme.surface,
                                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onSurface),
                                            value: progress/100,
                                          ),
                                        )
                                      ),
                                    )
                                  else  //if error occured
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 2.0, 0.0),
                                      height: maxHeight * 0.5,
                                      width: maxWidth * 0.23,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text("Failed", style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis)
                                      )
                                    ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                                    height: maxHeight * 0.95,
                                    width: maxWidth * 0.2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        Container(
                                          height: maxHeight*0.95,
                                          width: maxWidth*0.095,
                                          child: IconButton(
                                            color: Theme.of(context).colorScheme.surface,
                                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 2.0, 0.0),
                                            constraints: BoxConstraints(),
                                            icon: const Icon(Icons.refresh_sharp),
                                            onPressed: _mode == "Upload"? _uploadImage:_downloadImage,
                                            tooltip: "Retry",
                                          ),
                                        ),
                                        Container(
                                          height: maxHeight*0.95,
                                          width: maxWidth*0.095,
                                          child: IconButton(
                                            color: Theme.of(context).colorScheme.surface,
                                            padding: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                                            constraints: BoxConstraints(),
                                            icon: const Icon(Icons.cancel_outlined),
                                            onPressed: _mode == "Upload"? _cancelUpload:_cancelDownload,
                                            tooltip: "Cancel",
                                          ),
                                        )
                                      ]
                                    )
                                  )
                                ],
                              );
                            }
                            else{ //done upload/download (most likely wont come in here, since task will be removed once done
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5.0,0.0,0.0,0.0),
                                    height: maxHeight * 0.95,
                                    width: maxWidth * 0.08,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        _mode == "Upload"? Icons.cloud_done_sharp:Icons.file_download_done,
                                        color: Theme.of(context).colorScheme.surface,
                                      )
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                                    height: maxHeight * 0.95,
                                    width: maxWidth * 0.12,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Done", style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis)
                                    )
                                  )
                                ],
                              );
                            }
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
                    ),
                  ),
                )
              ],
            )
          );
        }
      ),
    );
  }
}