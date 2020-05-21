import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app2/services/cloud_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

/*utility functions---------------------------------------------------------------------------------*/
Future<String> getPath() async {
  var direc = await getApplicationDocumentsDirectory();
  String path = direc.path;
  print(path);
  return path;
}

void createDirectory(String path) async {
  final Directory directory = Directory(path);
  if(await directory.exists()){
    print("Directory already exists");
  }
  else{
    await directory.create(recursive: true);
    print("$directory created.");
  }
}

Future<File> createImageFile(String uid, String image_id, String folder_path) async {
  final appDocDir = await getPath();                  //all files stored under appDocDirectory/uid
  var directory_path;
  if(folder_path != "") {                             //if folder_path is specified
    directory_path = "$appDocDir/$uid/$folder_path/";
  }
  else{
    directory_path = "$appDocDir/$uid/";              //if no folder_path is specified, recommended to specify
  }
  await createDirectory(directory_path);              //checks if directory exists, if not exists, then create all paths
  return File(directory_path + image_id + ".jpg"); //create file to store image
}
/*end of utility functions--------------------------------------------------------------------------------*/

/*Speed Dial Button Class---------------------------------------------------------------------------------*/
class SpeedDialButton extends StatelessWidget{
  List<SpeedButtonProperties> buttons;
  SpeedDialButton(this.buttons);

  SpeedDialChild _createDial (Function function, String label, Icon icon){
    return SpeedDialChild(
      child: icon,
      backgroundColor: Colors.blue,
      label: label,
      labelStyle: TextStyle(fontSize: 18.0),
      onTap: function,
    );
  }

  List<SpeedDialChild> _createDialList(){
    return buttons.map((data) => _createDial(data._function,data._label,data._icon)).toList();
  }

  Widget build(BuildContext context){
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      onOpen: () => print("Opening Dial"),
      onClose: () => print("Closing Dial"),
      tooltip: "Speed Dial",
      heroTag: "Speed Dial Hero Tag",
      elevation: 5.0,
      shape: CircleBorder(),
      children: _createDialList(),
    );
  }
}

class SpeedButtonProperties {
  Function _function;
  String _label;
  Icon _icon;
  SpeedButtonProperties(this._function,this._label,this._icon);
}
/*end of Speed Dial Button Class---------------------------------------------------------------------------------*/

/*ImageHolder Class----------------------------------------------------------------------------------------------*/
class ImageHolder extends StatefulWidget{
  ImageHolder({Key key}) : super(key:key);  //acccess the _image of _ImageHolderState, allow parent to access methods.
  @override
  State<StatefulWidget> createState() => ImageHolderState();
}

class ImageHolderState extends State<ImageHolder>{
  var _image;//File _image;
  @override

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  File returnImage() {
    return _image;
  }

  void getImageFromFirebase(String uid,String image_id, String folder_path) async {
    var image = await CloudStorage().getFile(uid,image_id,folder_path);
    setState(() {
      _image = image;
    });
  }

  Future<void> getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future<void> getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        child: Center(
            child: _image == null? Text("No images...") : Image.file(_image)
        ),
      ),
    );
  }
}
/*End of ImageHolder Class--------------------------------------------------------------------------------------*/