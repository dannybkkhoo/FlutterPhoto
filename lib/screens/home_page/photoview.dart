import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class SimplePhotoViewPage extends StatelessWidget {
  final String _imagePath,_date;
  SimplePhotoViewPage(this._imagePath, this._date);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhotoView'),
      ),
      body: PhotoView(
        imageProvider: FileImage(File(_imagePath)),
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
            child: Wrap(
              children: <Widget>[
                Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                  ),
                ),
                ListTile(
                  title: Text('Description'),
                  subtitle: Text(_date, style: TextStyle(fontSize: 10),),
                )
              ],
            )

        ),
      ),
    );
  }
}