import 'package:app2/services/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class CloudStorage {
  final _storageReference = FirebaseStorage.instance;
  Future<imageRecord> uploadImage(String uid, imageRecord image, File imageFile) async {
    final StorageReference imageStorageRef = _storageReference.ref().child(uid + "/" + image.name);
    final StorageMetadata imageMeta = StorageMetadata(customMetadata: {"description":image.description});
    final StorageUploadTask uploadTask = imageStorageRef.putFile(imageFile,imageMeta);
    print("upload starts:" + DateTime.now().toString());
    final StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    final downloadURL = await storageSnapshot.ref.getDownloadURL();
    if(uploadTask.isComplete) {
      image.imageurl = downloadURL.toString();
      print("Upload complete!" + DateTime.now().toString());
      print("imageURL of " + image.name + " => " + image.imageurl);
      return image;
    }
    print("Upload failed:" + DateTime.now().toString());
    return null;
  }

  void deleteImage(String uid, String imagename) async {
    final StorageReference imageStorageRef = _storageReference.ref().child(uid + "/" + imagename);
    try{
      await imageStorageRef.delete();
      print("Deletion of " + imagename + " complete!");
    }
    catch(e) {
      print("Error when deleting " + imagename + ":");
      print(e.toString());
    }
  }

  void deleteFolder(String uid) async {
    var output = await _storageReference.ref().child('123/testing');
    var metadata = await output.getMetadata();
    print(metadata);
  }
}

class CloudStorageItem{
  final String imageURL, imageFilePath, imageFileName;
  CloudStorageItem(this.imageURL,this.imageFilePath,this.imageFileName);
}


Future getUrl(imageName) async {
  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("123");
  var output = await firebaseStorageRef.listAll();
  print(output);
}

Future getFile(imagePath, imageName){
  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(imagePath + imageName);
  final maxSize = 1024*1024;
  var output = firebaseStorageRef.getData(maxSize)
}