import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';

class CloudStorage {
  final _storageReference = FirebaseStorage.instance;
  /*Uploads an image file to firebase storage and place under UID folder*/
  void uploadImage(String uid, String image_id, File imageFile) async {
    final StorageReference imageStorageRef = _storageReference.ref().child(uid + "/" + image_id);
    final StorageUploadTask uploadTask = imageStorageRef.putFile(imageFile);
    print("upload starts:" + DateTime.now().toString());
    final StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    if(uploadTask.isComplete) {
      print("Upload complete!" + DateTime.now().toString());
      print("Image ID:" + image_id);
    }
    else {
      print("Upload failed." + DateTime.now().toString());
    }
  }
  /*Deletes an image file in firebase storage under UID folder*/
  void deleteImage(String uid, String image_id) async {
    final StorageReference imageStorageRef = _storageReference.ref().child(uid + "/" + image_id);
    try{
      await imageStorageRef.delete();
      print("Deletion of " + image_id + " complete!");
    }
    catch(e) {
      print("Error when deleting " + image_id + ":");
      print(e.toString());
    }
  }
  /*Deletes everything inside uid folder, which will then also delete uid folder*/
  /*Warning: Using this function will delete everything inside the uid folder and cannot be recovered!*/
  void deleteFolder(String uid) async {
    final StorageReference firebaseStorageRef = _storageReference.ref().child(uid);
    final Map raw_list = await firebaseStorageRef.listAll();
    final Map raw_folder_list = raw_list["items"];
    List folder_list = [];
    raw_folder_list.forEach((image_id,details) => folder_list.add(image_id)); //name of image should be image_id
    print("List of items in folder:");
    print(folder_list);
    folder_list.forEach((image_id) => deleteImage(uid,image_id));
    print("Folder delete for UID:" + uid + " done.");
  }
  /*Gets metadata object of image, then returns certain important details in Map format*/
  Future<Map> getMetadata(String uid, String image_id) async {
    final StorageReference imageStorageRef = _storageReference.ref().child(uid + "/" + image_id);
    final metadata = await imageStorageRef.getMetadata();
    final data = {
      "name" : metadata.name,
      "path" : metadata.path,
      "contentType" : metadata.contentType,
      "sizeBytes" : metadata.sizeBytes,
      "customMetadata" : metadata.customMetadata
    };
    print(data);
    return data;
  }
  /*Gets the image file from firebase storage, returns as uint8list data, written to file simultaneously created in provided with path*/
  Future<File> getFileToLocal(String uid, String image_id, String folder_path) async {
    final StorageReference firebaseStorageRef = _storageReference.ref().child(uid + "/" + image_id);
    final maxSize = 1024*1024;
    final image = await firebaseStorageRef.getData(maxSize);
    File local_image_file = await createImageLocalFile(uid, image_id, folder_path);  //creates directory and image file
    await local_image_file.writeAsBytes(image);
    await createImageGarFile(local_image_file.path,"Flutter Photo");
    print(local_image_file.path);
    return local_image_file;
  }
  Future<File> getFileToGallery(String uid, String image_id, String folder_path) async {
    final StorageReference firebaseStorageRef = _storageReference.ref().child(uid + "/" + image_id);
    int maxSize = 1024*1024*5;
    final image = await firebaseStorageRef.getData(maxSize);
    //File temp_image_file = File("/storage/emulated/0/Android/data/com.fiftee.app2/files/$image_id");//await createImageTempFile(uid, image_id);  //creates temp image file
    String uidpart = uid.substring(0,3);             //take first 4 digit of UID
//    File temp_image_file = File("IMG_$uidpart$image_id.jpg");
    File temp_image_file = await createImageTempFile(uid, image_id);
    await temp_image_file.writeAsBytes(image);                        //saves image data into file
    await createImageGarFile(temp_image_file.path,"Flutter Photo///TESTING");   //saves image file in gallery
    File tmb = await createLocalThumbnail(uid, image_id, folder_path, temp_image_file); //create & save thumbnail in appdocdir
    //temp_image_file.deleteSync(recursive: true);  //delete temp image file
    //imageCache.clear(); //clear cache, otherwise temp image file will persist
    //return tmb;
    return temp_image_file;
  }
  /*Gets image file from firebase storage, returns as http response, written to file simultaneously created in provided with path*/
  Future<File> getFileByURL(String uid, String image_id, String folder_path) async {
    final StorageReference firebaseStorageRef = _storageReference.ref().child(uid + "/" + image_id);
    final String url = await firebaseStorageRef.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    File image_file = await createImageLocalFile(uid, image_id, folder_path);  //creates directory and image file
    final StorageFileDownloadTask task = firebaseStorageRef.writeToFile(image_file);
    return image_file;
  }

}

