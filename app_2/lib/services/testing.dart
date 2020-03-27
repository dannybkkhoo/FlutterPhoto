import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
void main() => runApp(MaterialApp());
class SimplePhotoViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Photo View'),
      ),
      body: PhotoView(
        imageProvider: AssetImage('assets/images/solar.jpg'),
        // Contained = the smallest possible size to fit one dimension of the screen
        minScale: PhotoViewComputedScale.contained * 0.8,
        // Covered = the smallest possible size to fit the whole screen
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
        // Set the background color to the "classic white"
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
      ),
    );
  }
}