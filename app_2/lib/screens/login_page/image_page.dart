import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../services/cloud_storage_service.dart';
import '../../services/authprovider.dart';
import '../../services/authenticator.dart';
import 'dart:io';

class ImagePage extends StatefulWidget{
  const ImagePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>{
  GlobalKey<_ImageHolderState> key = GlobalKey();

  Future<void> _signOut(BuildContext context) async {
    try{
      final Authenticator auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Gallery"),
        leading: Icon(Icons.menu),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right:20.0),
            child: GestureDetector(
              onTap: () async => await _signOut(context),
              child: Icon(Icons.exit_to_app,size: 26.0),
            )
          )
        ],
      ),
      floatingActionButton: SpeedDialButton([
        SpeedButtonProperties(() async => key.currentState.getCameraImage(),"Camera",Icon(Icons.add_a_photo)),
        SpeedButtonProperties(() async => key.currentState.getGalleryImage(),"Gallery",Icon(Icons.add_photo_alternate)),
        SpeedButtonProperties(() async => await CloudStorage(key.currentState._image,"123",DateTime.now().toString()).uploadImage(),"Upload",Icon(Icons.arrow_upward))
      ]),
      body: ImageHolder(key: key),  //key passed to class so that parent can change variable state of that class
    );
  }
}

class ImageHolder extends StatefulWidget{
  ImageHolder({Key key}) : super(key:key);  //acccess the _image of _ImageHolderState, allow parent to access methods.
  @override
  State<StatefulWidget> createState() => _ImageHolderState();
}

class _ImageHolderState extends State<ImageHolder>{
  File _image;
  @override

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