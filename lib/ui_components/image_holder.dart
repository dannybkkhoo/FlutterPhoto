import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/top_level_providers.dart';
import '../ui_components/confirmation_popup.dart';
import '../ui_components/styled_buttons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

//To add feature to allow user zoom into image after tapping image

class ImageHolder extends ConsumerStatefulWidget {
  late double height;
  late String imagePath;
  late bool removeable;

  ImageHolder({required this.height, this.imagePath = "", this.removeable = true});

  @override
  _ImageHolderState createState() => _ImageHolderState();
}

class _ImageHolderState extends ConsumerState<ImageHolder> {
  File? _imageFile;
  int _imageSize = 0; //in bytes

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.imagePath != "") {
      File imageFile = File(widget.imagePath);
      if(imageFile.existsSync()) {
        setState(() {
          _imageFile = File(widget.imagePath);
        });
      }
      else {
        setState(() {
          _imageFile = File("assets/images/question_mark.png");
        });
      }
    }
    final pageStatus = ref.watch(pagestatusProvider);
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
        borderRadius: const BorderRadius.all(Radius.circular(13.0)),
        color: Theme.of(context).colorScheme.surface,
      ),
      margin: const EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                if(_imageFile == null) ... [
                  Text("No image selected...", style: Theme.of(context).textTheme.headline6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      roundedIconButton(
                        context: context,
                        constraints: constraints,
                        icon: Icons.image_outlined,
                        text: "Gallery",
                        onPressed: () async {
                          final XFile? tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(tempImage != null) {
                            setState(() {
                              _imageFile = File(tempImage.path);
                              _imageSize = _imageFile!.readAsBytesSync().lengthInBytes;
                            });
                            pageStatus.imageFile = _imageFile;
                          }
                        },
                      ),
                      roundedIconButton(
                        context: context,
                        constraints: constraints,
                        icon: Icons.camera_alt_outlined,
                        text: "Camera",
                        onPressed: () async {
                          final XFile? tempImage = await ImagePicker().pickImage(source: ImageSource.camera);
                          if(tempImage != null) {
                            setState(() {
                              _imageFile = File(tempImage.path);
                              _imageSize = _imageFile!.readAsBytesSync().lengthInBytes;
                            });
                            pageStatus.imageFile = _imageFile;
                          }
                        },
                      )
                    ],
                  )
                ],
                if(_imageFile != null) ... [
                  Container(
                    height: constraints.maxHeight*0.9,
                    width: constraints.maxWidth,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(13.0),
                      ),
                      child: Image.file(_imageFile!, fit: BoxFit.scaleDown,), //not sure which is best
                    ),
                  ),
                  if(widget.removeable) ... [
                    Container(
                      height: constraints.maxHeight*0.1,
                      width: constraints.maxWidth,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(13.0),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromWidth(constraints.maxWidth),
                          ),
                          child: Text("Remove Image (${(_imageSize<1000000?_imageSize/1024:_imageSize/1024/1024).ceilToDouble()} ${_imageSize<1000000?'kb':'mb'})", style: Theme.of(context).textTheme.headline6,),
                          onPressed: () async {
                            if(await confirmationPopUp(context,content: "Remove image?")) {
                              setState(() {
                                _imageFile = null;
                                _imageSize = 0;
                              });
                              pageStatus.imageFile = null;
                            };
                          },
                        ),
                      ),
                    ),
                  ]
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
