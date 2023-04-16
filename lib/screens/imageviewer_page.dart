import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

//currently a simple class, might have additional features in the future
class ImageViewerPage extends ConsumerStatefulWidget {
  late String imagePath;

  ImageViewerPage(this.imagePath);

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends ConsumerState<ImageViewerPage> {
  File? _imageFile;

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
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                if(_imageFile != null) ... [
                  InteractiveViewer(
                    maxScale: double.infinity,
                    minScale: 0.1,
                    child: Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Image.file(_imageFile!, fit: BoxFit.scaleDown,), //not sure which is best
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
