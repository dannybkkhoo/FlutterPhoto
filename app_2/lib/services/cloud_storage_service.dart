import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

Future<CloudStorageResult> uploadImage({
  @required File imageToUpload,
  @required String imageFilePath,
  @required String imageFileName,
}) async {
  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFilePath + "/" + imageFileName);
  StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
  StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
  var downloadURL = await storageSnapshot.ref.getDownloadURL();

  if(uploadTask.isComplete) {
    var imageURL = downloadURL.toString();
    return CloudStorageResult(imageURL, imageFilePath, imageFileName);
  }
  return null;
}

class CloudStorageResult{
  final String imageURL;
  final String imageFilePath;
  final String imageFileName;
  CloudStorageResult(this.imageURL,this.imageFilePath,this.imageFileName);
}