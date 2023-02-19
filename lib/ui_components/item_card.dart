import 'package:flutter/material.dart';
import '../providers/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/userdata.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../app_router.dart';

enum ItemType {
  folder,
  image
}

class ItemCard extends ConsumerWidget {
  late String _id;
  late String _folderid;  //only used when ItemCard is an image
  late ItemType _type;
  bool _isSelecting = false;
  bool _isSelected = false;

  Widget selectionIcon({required bool isSelected}){
    return Container(
      padding: const EdgeInsets.fromLTRB(6.0, 6.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: isSelected? Colors.green: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  ItemCard({
    Key? key,
    required String id,
    required ItemType type,
    String folderid = "",
  }):super(key:key){
    this._id = id;
    this._type = type;
    this._folderid = folderid;  //only used when ItemCard is an image
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget cardImage;
    String name = "?";
    String imagepath = "assets/images/question_mark.png"; //default image, a question mark
    final String uid = ref.watch(userdataProvider).uid??"";
    final String appDocDir = ref.watch(userdataProvider).appDocDir??"";
    final Object? item = ref.watch(userdataProvider.select((userdata) =>  _type == ItemType.folder?userdata.folders[_id]:userdata.images[_id]));  //Folderdata/Imagedata depending on the _type

    _isSelecting = ref.watch(pagestatusProvider).isSelecting;

    if(_type == ItemType.folder) {
      _isSelected = ref.watch(pagestatusProvider).selectedFolders.contains(_id);
      Folderdata? folder = item as Folderdata?;
      if (folder != null) {
        name = folder.name;
        if (folder.imagelist.isNotEmpty) {
          Imagedata image = ref.watch(userdataProvider.select((userdata) => userdata.images[folder.imagelist[0]]!),);
          imagepath = appDocDir + "/" + uid + "/images/" + image.id;
        }
      }
    }
    else{
      _isSelected = ref.watch(pagestatusProvider).selectedImages.contains(_id);
      Imagedata? image = item as Imagedata?;
      if (image != null) {
        name = image.name;
        imagepath = appDocDir + "/" + uid + "/images/" + image.id;// + "." + image.ext; no need to add extension to filename/path, when uploaded to firebase, it auto detect the file type, same as local storage through metadata
      }
    }

    if (File(imagepath).existsSync()) {
      cardImage = Image.file(File(imagepath), fit: BoxFit.scaleDown,);
    }
    else {
      imagepath = "assets/images/question_mark.png";
      cardImage = Image.asset(imagepath,fit: BoxFit.scaleDown,);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridTile(
              header: _isSelecting?selectionIcon(isSelected: _isSelected):null,
              child: GestureDetector(
                onLongPress: () {
                  if(_isSelecting){
                    ref.read(pagestatusProvider).isSelecting = false;
                  }
                  else {
                    ref.read(pagestatusProvider).isSelecting = true;
                    if (_type == ItemType.folder) {
                      ref.read(pagestatusProvider).addSelectedFolder(_id);
                    }
                    else {
                      ref.read(pagestatusProvider).addSelectedImage(_id);
                    }
                  }
                },
                onTap: () {
                  if(_isSelecting) {
                    if (_type == ItemType.folder) {
                      _isSelected ?
                      ref.read(pagestatusProvider).removeSelectedFolder(_id) :
                      ref.read(pagestatusProvider).addSelectedFolder(_id);
                    }
                    else {
                      _isSelected ?
                      ref.read(pagestatusProvider).removeSelectedImage(_id) :
                      ref.read(pagestatusProvider).addSelectedImage(_id);
                    }
                  }
                  else{
                    //go into folder
                    if (_type == ItemType.folder) {
                      Navigator.of(context).popAndPushNamed(AppRoutes.folderPage, arguments: {"folderid":_id});
                    }
                    else {
                      Navigator.of(context).popAndPushNamed(AppRoutes.imagePage, arguments: {"folderid":_folderid, "initial_imageid":_id});
                    }
                  }
                },
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: constraints.maxHeight*0.75,
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.0),
                          child: ColoredBox(
                            color: Theme.of(context).colorScheme.surface,
                            child: cardImage,
                          ),
                        ),
                      ),
                      Container(
                        height: constraints.maxHeight*0.25,
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.0),
                          child: Text(name, style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                  color: Theme.of(context).colorScheme.tertiary,
                  elevation: 10.0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
