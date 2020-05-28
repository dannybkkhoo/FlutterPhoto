import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:app2/services/cloud_storage.dart';

/*utility functions---------------------------------------------------------------------------------*/
Future<String> getPath() async {
  var direc = await getApplicationDocumentsDirectory();
  String path = direc.path;
  //print(path);
  return path;
}

String getDate(){
  final now = DateTime.now();
  final formatter = new DateFormat('dd/MM/yyyy');
  final String date = formatter.format(now);
  print(date);
  return date;
}

DateTime getDefaultDate() {
  return new DateFormat("dd/MM/yyyy HH:mm:ss").parse("01/01/2000 00:00:00");
}

Future<void> createDirectory(String path) async {
  final Directory directory = Directory(path);
  if(await directory.exists()){
    print("Directory already exists");
  }
  else{
    await directory.create(recursive: true);
    print("$directory created.");
  }
}

Future<void> deleteDirectory(String path) async {
  final Directory directory = Directory(path);
  if(await directory.exists()){
    directory.deleteSync(recursive:true);
    print("$directory deleted.");
  }
  else{
    print("Directory doesn't exist.");
  }
}

Future<void> deleteFile(String path) async {
  final File file = File(path);
  if(await file.exists()){
    file.deleteSync(recursive: true);
    print("$file deleted.");
  }
  else{
    print("File doesn't exist.");
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

/*screens widget functions--------------------------------------------------------------------------------*/
Widget WaitingScreen(Function cancelAction, {Widget waitingWidget = const CircularProgressIndicator(), String showText = ""}) {
  return Scaffold(
    body: Align(
      alignment:  Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          waitingWidget,
          showText != ""? paddedText(showText,fontsize: 24.0) : SizedBox(height:10), //if no text provided, return empty view
          Container(
            child: RaisedButton(
              child: Text("Cancel", style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
              onPressed: cancelAction,
            ),
          )
        ],
      )
    )
  );
}
Widget sizedWaitingScreen({Widget waitingWidget = const CircularProgressIndicator()}) {
  return Expanded(
    child: Scaffold(
        body: Align(
          alignment:  Alignment.center,
          child: waitingWidget,
        )
      )
  );
}
Widget ErrorScreen(Function backAction,{String errorText = ""}) {
  return Scaffold(
    body: Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          errorText != ""? paddedText(errorText,fontsize: 24.0):paddedText("Application Error...",fontsize: 24.0),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 5, 20),
            child: RaisedButton(
              child: Text('Back',style: TextStyle(fontSize: 24.0),textAlign: TextAlign.center,),
              onPressed: backAction,
            ),
          )
        ],
      )
    )
  );
}
Widget sizedErrorScreen(Function retryAction,{String errorText = ""}) {
  return Expanded(
    child: Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                errorText != ""? paddedText(errorText,fontsize: 24.0):paddedText("Application Error...",fontsize: 24.0),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 20),
                  child: RaisedButton(
                    child: Text('Back',style: TextStyle(fontSize: 24.0),textAlign: TextAlign.center,),
                    onPressed: retryAction,
                  ),
                )
              ],
            ),
          )
      )
  );
}
Widget paddedText(String text, {double fontsize = 24.0}){
  return Container(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    alignment: Alignment.center,
    child: Text(text,style:TextStyle(fontSize: fontsize),textAlign: TextAlign.center,),
  );
}
Widget NoImage(String filename){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
          alignment: Alignment.center,
          padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          height: 100.0,
          width: 100.0,
          child: Text("No Image")
      ),
      Text(filename, style: TextStyle(fontSize: 15.0),)
    ],
  );
}
/*end of screens widget functions--------------------------------------------------------------------------*/


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