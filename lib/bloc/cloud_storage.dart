import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../utils.dart';

/*
The CloudStorage class is used to upload or download images to/from firebase
cloud storage, and allow the app to track the upload/download progress. Every
upload/download is treated as individual tasks, and each task is stored in a
map with the filename as its key. This means that the app can track the progress
of each individual task, and the user can retry or cancel a task if desired.

Note:
- The upload path (firebasePath) is structured below:
  user_id/images/image_id
- The download path (to user phone) is structured below:
  Android:
    appDocDir/user_id/images/image_id (check if other user can see image)
  iOS:
    undecided
- The reason why folder_id is not used for organizing the images, eg.
  user_id/folder_id/image_id, is because in the case where the user decides to
  move images from folder to folder, extra cost will be incurred due to the
  firebase charging plan policy, where each read/write/delete has a cost, thus,
  images are not organized under folder_id and instead kept under the "images"
  folder only. Instead, the folder structure for the images are stored in a
  document where the document itself it stored in firestore database. In this
  case, when the user decides to move images from folder to folder, the only
  cost incurred is a write to the document in firestore database, which is much
  simpler and cheaper than write/delete in cloud storage.
*/


// Reminder to check if thumbnail needed, check the performance/memory if using full image, compare how well it works
class CloudStorageProvider with ChangeNotifier{
  final _cloudStorage = FirebaseStorage.instance;
  bool _isUploading = false;
  bool _isDownloading = false;
  bool _isDeleting = false;
  Map<String, UploadTask> _uploadMap = {};
  Map<String, Map<String, dynamic>> _uploadParam = {};
  Map<String, Object?> _uploadException = {};
  Map<String, DownloadTask> _downloadMap = {};
  Map<String, Map<String, dynamic>> _downloadParam = {};
  Map<String, Object?> _downloadException = {};

  FirebaseStorage get cloudStorage => _cloudStorage;
  bool get isUploading => _isUploading;
  bool get isDownloading => _isDownloading;
  bool get isDeleting => _isDeleting;
  Map<String, UploadTask> get uploadMap => _uploadMap;
  Map<String, Map<String, dynamic>> get uploadParam => _uploadParam;
  Map<String, Object?> get uploadException => _uploadException;
  Map<String, DownloadTask> get downloadMap => _downloadMap;
  Map<String, Map<String, dynamic>> get downloadParam => _downloadParam;
  Map<String, Object?> get downloadException => _downloadException;

  Future<bool?> uploadImage(String firebasePath, File file, {bool sync = false}) async {  //firebasePath w/o extension, extract extension from file
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filename = basename(firebasePath); //get filename w/o extension and path
    final String ext = getFileExtension(file);   //get extension of file

    _isUploading = true;
    _uploadParam.remove(filename);      //reset
    _uploadException.remove(filename);  //reset
    notifyListeners();

    assert(file.existsSync(), "Provided file must exist already!");
    print("Uploading image to:" + firebasePath);
    final UploadTask uploadTask = _cloudStorage.ref().child("$firebasePath").putFile( //eg. 'uid123/images/' + 'imageid'
      file,
      SettableMetadata(
        contentType: 'image/$ext',      //eg. image/jpg
      )
    );
    _uploadMap[filename] = uploadTask;  //eg. {"testing":uploadTask}
    notifyListeners();

    if(sync) {
      bool uploadSuccess = false;
      await uploadTask
          .catchError((Object e){
        _uploadParam[filename] = {"firebasePath":firebasePath,"file":file};  //to retry if needed, also indicates error occurred
        _uploadException[filename] = e;   //to indicate failure and to check exception
        notifyListeners();
      })
          .whenComplete(() async {
        if(!_uploadParam.containsKey(filename)){          //if filename(key) is not in _uploadParam, this means that no error occurred when uploading this file
          _uploadMap.remove(filename);                    //then safe to remove task from list
          File("${appDocDir.path}/${firebasePath}").createSync(recursive:true); //eg. /data/user/0/com.fiftee.app2/app_flutter/user123/images/cat_image
          await file.copy("${appDocDir.path}/${firebasePath}"); //then move the uploaded file(original) to appDocDir for app safekeeping (same as download path)
        }
        if(_uploadMap.isEmpty){_isUploading = false;} //if all upload tasks are done, then trigger _isUploading = false
        notifyListeners();
        uploadSuccess = true;
      });
      return uploadSuccess;
    }
    else {
      unawaited(
        uploadTask
            .catchError((Object e){
          _uploadParam[filename] = {"firebasePath":firebasePath,"file":file};  //to retry if needed, also indicates error occurred
          _uploadException[filename] = e;   //to indicate failure and to check exception
          notifyListeners();
        })
            .whenComplete(() async {
          if(!_uploadParam.containsKey(filename)){        //if filename(key) is not in _uploadParam, this means that no error occurred when uploading this file
            _uploadMap.remove(filename);                  //then safe to remove task from list
            File("${appDocDir.path}/${firebasePath}").createSync(recursive:true); //eg. /data/user/0/com.fiftee.app2/app_flutter/user123/images/cat_image
            unawaited(file.copy("${appDocDir.path}/${firebasePath}")); //then move the uploaded file(original) to appDocDir for app safekeeping (same as download path)
          }
          if(_uploadMap.isEmpty){_isUploading = false;}   //if all upload tasks are done, then trigger _isUploading = false
          notifyListeners();
        }),
      );
    }
  }

  Future<bool?> downloadImage(String firebasePath, {bool sync = false}) async {           //firebasePath w/o extension, eg. user123/images/cat_image
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filename = basename(firebasePath);                 //cat_image
    final File downloadToFile = File("${appDocDir.path}/${firebasePath}");  //eg. /data/user/0/com.fiftee.app2/app_flutter/user123/images/cat_image (no extension needed)
    downloadToFile.createSync(recursive:true);

    _isDownloading = true;
    _downloadParam.remove(filename);      //reset
    _downloadException.remove(filename);  //reset
    notifyListeners();

    final DownloadTask downloadTask = _cloudStorage.ref("${firebasePath}").writeToFile(downloadToFile);
    _downloadMap[filename] = downloadTask;
    notifyListeners();

    if(sync) {
      bool downloadSuccess = false;
      await downloadTask//.then((_) => throw(Exception("lol")))
          .catchError((Object e){
        _downloadParam[filename] = {"firebasePath":firebasePath};  //to retry if needed, indicates error occurred
        _downloadException[filename] = e;       //to indicate failure and to check exception
        downloadToFile.deleteSync();
        notifyListeners();
      })
          .whenComplete((){
        if(!_downloadParam.containsKey(filename)){_downloadMap.remove(filename);}
        if(_downloadMap.isEmpty){_isDownloading = false;}
        notifyListeners();
        downloadSuccess = true;
      });
      return downloadSuccess;
    }
    else {
      unawaited(
        downloadTask//.then((_) => throw(Exception("lol")))
            .catchError((Object e){
          _downloadParam[filename] = {"firebasePath":firebasePath};  //to retry if needed, indicates error occurred
          _downloadException[filename] = e;       //to indicate failure and to check exception
          downloadToFile.deleteSync();
          notifyListeners();
        })
            .whenComplete((){
          if(!_downloadParam.containsKey(filename)){_downloadMap.remove(filename);}
          if(_downloadMap.isEmpty){_isDownloading = false;}
          notifyListeners();
        }),
      );
    }
  }

  Future<bool?> deleteImage(String firebasePath, {bool sync = false}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filename = basename(firebasePath);                     //cat_image
    final File pathToFile = File("${appDocDir.path}/${firebasePath}");  //eg. /data/user/0/com.fiftee.app2/app_flutter/user123/images/cat_image (no extension needed)

    _isDeleting = true;
    notifyListeners();

    if(sync) {
      bool deleteSuccess = false;
      try {
        if(pathToFile.existsSync()) {
          pathToFile.deleteSync();
        }
        await _cloudStorage.ref("${firebasePath}").delete();
        deleteSuccess = true;
      } on Exception catch (e) {
        print("Failed to delete image: ${e}");
      }
      _isDeleting = false;
      notifyListeners();
      return deleteSuccess;
    }
    else {
      unawaited(pathToFile.delete());
      unawaited(_cloudStorage.ref("$firebasePath").delete().whenComplete(() {
       _isDeleting = false;
        notifyListeners();
      }),);
    }
  }

  bool cancelUpload(String filename){
    if(_uploadMap.containsKey(filename)){
      if(_uploadParam.containsKey(filename))
        _uploadParam.remove(filename);
      if(_uploadException.containsKey(filename))
        _uploadException.remove(filename);
      _uploadMap.remove(filename);
      if(_uploadMap.isEmpty){_isUploading = false;}
      notifyListeners();
      return true;
    }
    return false;
  }

  bool cancelDownload(String filename){
    if(_downloadMap.containsKey(filename)){
      if(_downloadParam.containsKey(filename))
        _downloadParam.remove(filename);
      if(_downloadException.containsKey(filename))
        _downloadException.remove(filename);
      _downloadMap.remove(filename);
      if(_downloadMap.isEmpty){_isDownloading = false;}
      notifyListeners();
      return true;
    }
    return false;
  }
}

/*
The taskBox class complements the CloudStorage class, where it is a UI that
displays the progress of either an upload/download task, and users can interact
with the task by deciding whether to cancel the task while it is in progress, or
retry (restart) the task if an error has occured or if the task was cancelled.
*/

class taskBox extends ConsumerWidget{
  late UploadTask? _utask = null;
  late DownloadTask? _dtask = null;
  late String _taskName;
  late String _mode;
  late CloudStorageProvider _ref;
  double height;
  double width;

  taskBox.upload({Key? key, required String taskName, required UploadTask task, required CloudStorageProvider ref, this.height = 30, this.width = 380}): super(key: key) {
    _taskName = taskName;
    _utask = task;
    _ref = ref;
    _mode = "Upload";
  }

  taskBox.download({Key? key, required String taskName, required DownloadTask task, required CloudStorageProvider ref, this.height = 30, this.width = 380}): super(key: key) {
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
  Widget build(BuildContext context, WidgetRef ref){
    final _cloudStorageProvider = ChangeNotifierProvider<CloudStorageProvider>((ref) => _ref);
    final cloud = ref.watch(_cloudStorageProvider);
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