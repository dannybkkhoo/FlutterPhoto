import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSelector {
  Future<File> selectImage() async{
    return await ImagePicker.pickImage(source:ImageSource.gallery);
  }
}
