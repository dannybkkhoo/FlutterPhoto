import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'authprovider.dart';
import 'dart:io';

class CloudStorage {
  File imageToUpload;
  String imageFilePath, imageFileName;
  CloudStorage(
    this.imageToUpload,
    this.imageFilePath,
    this.imageFileName,
  );

  Future<CloudStorageItem> uploadImage() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFilePath + "/" + imageFileName);
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    print("upload starts:" + DateTime.now().toString());
    final StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    final downloadURL = await storageSnapshot.ref.getDownloadURL();
    if(uploadTask.isComplete) {
      final imageURL = downloadURL.toString();
      print("Upload complete!" + DateTime.now().toString());
      return CloudStorageItem(imageURL, imageFilePath, imageFileName);
    }
    print("Upload failed:" + DateTime.now().toString());
    return null;
  }

  Future<void> deleteImage() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFilePath + "/" + imageFileName);
    try{
      await firebaseStorageRef.delete();
      print("Deletion complete!");
    }
    catch(e) {
      print("Error when deleting:");
      print(e.toString());
    }
  }
}

class CloudStorageItem{
  final String imageURL, imageFilePath, imageFileName;
  CloudStorageItem(this.imageURL,this.imageFilePath,this.imageFileName);
}