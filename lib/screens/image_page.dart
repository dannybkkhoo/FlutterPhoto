import 'package:app2/bloc/cloud_storage.dart';
import 'package:app2/providers/pagestatus_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/screen.dart';
import '../bloc/userdata.dart';
import '../providers/top_level_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/userdata_provider.dart';
import '../ui_components/dropdown_button.dart';
import '../ui_components/confirmation_popup.dart';
import '../ui_components/image_holder.dart';
import '../app_router.dart';
import 'dart:async';
import '../ui_components/styled_buttons.dart';
import 'dart:io';
import '../ui_components/loading_popup.dart';

//create addfolder page with tabs (for each detail for user to fill)
class ImagePage extends ConsumerStatefulWidget {
  late String folderid;
  late String initial_imageid;

  ImagePage(this.folderid, this.initial_imageid);

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends ConsumerState<ImagePage> {
  late ScrollController _scrollController;
  bool showDetails = false;
  Imagedata tempImage = Imagedata(id:"",name:"",createdAt:"",ext:"");

  late String _cursorImageid;
  List<String> _imageList = [];
  Map<String,String> imageNames = {}; //keep a map of imageid:imagename existing in this folder to ease development
  Map<String,String> imageIds = {};

  SnackBar imageStatus(String text, {Duration duration = const Duration(seconds:1)}) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(text, style: Theme.of(context).textTheme.subtitle1,),
      duration: duration,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(13.0)),
      ),
    );
  }

  SnackBar statusPopup(String text, {Duration duration = const Duration(seconds:1)}) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(text, style: Theme.of(context).textTheme.subtitle1,),
      duration: duration,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(13.0))
      ),
    );
  }

  Widget bottomNavigationBar(PagestatusProvider pageStatus, UserdataProvider userdata) {
    final bool isSelecting = pageStatus.isSelecting;
    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: MediaQuery.of(context).size.height*0.07,  //same as height for appBar from flutter package
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                vIconButton(
                  context: context,
                  constraints: constraints,
                  icon: Icons.arrow_back,
                  onPressed: () {
                    unawaited(Navigator.of(context).popAndPushNamed(AppRoutes.folderPage, arguments: {"folderid":widget.folderid}));
                  },
                  text: "Back",
                ),
                vIconButton(
                  context: context,
                  constraints: constraints,
                  icon: Icons.edit,
                  onPressed: () {
                    ref.read(pagestatusProvider).imageFile = null;
                    Navigator.of(context).pushNamed(AppRoutes.addImagePage, arguments: {"folderid":widget.folderid, "imageid":tempImage.id});
                  },
                  text: "Edit Photo",
                ),
                vIconButton(
                  context: context,
                  constraints: constraints,
                  icon: Icons.delete,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if(await confirmationPopUp(context, content: "Are you sure you want to remove this image?")){
                      String deleteImageid = _cursorImageid;
                      String deleteImagename = tempImage.name;

                      //Need to fix here, when deleting, image not found, have to pop first or go to another image, but will lead to another problem
                      if(_imageList.length == 1) {  //if only 1 image exists in folder, then pop out 1 level to folder page before deleting
                        unawaited(Navigator.of(context).popAndPushNamed(AppRoutes.folderPage, arguments: {"folderid":widget.folderid}));
                      }
                      else {
                        final currentImageIndex = _imageList.indexOf(deleteImageid);
                        setState(() {
                          _cursorImageid = _imageList[currentImageIndex - (currentImageIndex!=0?1:-1)]; //index-1 if not first image, index+1 if first image
                        });
                      }

                      bool deletedSuccessfully = false;
                      ScaffoldMessenger.of(context).showSnackBar(statusPopup("Deleting ${deleteImagename}", duration: const Duration(milliseconds:500)));
                      unawaited(loadingPopUp(context, title: "Deleting ${deleteImagename}"));
                      final CloudStorageProvider cloudStorage = ref.read(cloudStorageProvider);
                      deletedSuccessfully = await userdata.deleteImage(cloudStorageProvider: cloudStorage, folderid: widget.folderid, imageid: deleteImageid);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      if(deletedSuccessfully) {
                        ScaffoldMessenger.of(context).showSnackBar(statusPopup("Done deleting ${deleteImagename}", duration: const Duration(milliseconds:500)));
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(statusPopup("Failed to delete ${deleteImagename}", duration: const Duration(milliseconds:500)));
                      }
                    }
                  },
                  text: "Delete Photo",
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void loadImage(UserdataProvider userdataProvider, PagestatusProvider pagestatusProvider){
    final Map<String, Imagedata> images = userdataProvider.userdata!.images;                    //map of all images under the user
    final List<String> imageList = userdataProvider.folderData(widget.folderid)?.imagelist??[]; //list of imageids under this folder
    List<String> nameList = [];
    imageNames = {};
    imageIds = {};

    _imageList = [];

    for (String imageid in imageList) {
      if(images.containsKey(imageid)) {
        imageNames[imageid] = images[imageid]?.name ?? "?"; //imageid:imagename
        imageIds[imageNames[imageid]!] = imageid;           //imagename:imageid
      }
    }

    //Filter according to search
    if(pagestatusProvider.isSearching) {
      final String searchKeyword = pagestatusProvider.searchKeyword;
      for(String name in imageNames.values) {  //search through image name only
        if(name.toLowerCase().contains(searchKeyword.toLowerCase())){
          nameList.add(name);
        }
      }
    }
    else {
      nameList = imageNames.values.toList();
    }

    //Filter according to user selection (category/tag/date etc)

    //Sort according to name
    nameList = pagestatusProvider.sort(nameList);

    //Load and display all leftover images
    for(String imageName in nameList) {
      _imageList.add(imageIds[imageName]!);
    }

    tempImage = images[_cursorImageid]!;
  }

  void previousImage() {
    final prevImageIndex = _imageList.indexOf(_cursorImageid) - 1;
    if(prevImageIndex >=0) {
      setState(() {
        _cursorImageid = _imageList[prevImageIndex];
      });
    }
  }

  void nextImage() {
    final nextImageIndex = _imageList.indexOf(_cursorImageid) + 1;
    if(nextImageIndex < _imageList.length){
      setState(() {
        _cursorImageid = _imageList[nextImageIndex];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Screen().portrait();
    _scrollController = ScrollController();
    _cursorImageid = widget.initial_imageid;
    showDetails = false;
  }

  //resize when >5mb
  @override
  Widget build(BuildContext context) {
    final userdata = ref.watch(userdataProvider);
    final pageStatus = ref.watch(pagestatusProvider);
    final String uid = userdata.uid??"";
    final String appDocDir = userdata.appDocDir??"";
    final String imagePath = "${appDocDir}/${uid}/images/${_cursorImageid}";
    int imageSize = 0;

    if(File(imagePath).existsSync()) {
      imageSize = File(imagePath).readAsBytesSync().lengthInBytes;
    };

    loadImage(userdata, pageStatus);
    return WillPopScope(
      onWillPop: () async {
        unawaited(Navigator.of(context).popAndPushNamed(AppRoutes.folderPage, arguments: {"folderid":widget.folderid}));
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar(pageStatus, userdata),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                child: Column(
                  children: [
                    Container(
                      height: constraints.maxHeight*0.6 - 3 - 3 - 1 - 1,
                      width: constraints.maxWidth,
                      child: GestureDetector(
                        onHorizontalDragEnd: (dragDetail) {
                          if(dragDetail.velocity.pixelsPerSecond.dx < 1) {  //swipe right to left
                            if(_imageList.indexOf(_cursorImageid) != (_imageList.length - 1)) {
                              nextImage();
                            }
                          } else {
                            if(_imageList.indexOf(_cursorImageid) != 0) { //swipe left to right
                              previousImage();
                            }
                          }
                        },
                        child: Stack(
                          children: [
                            ImageHolder(height: constraints.maxHeight*0.6, imagePath: imagePath, removeable: false,),
                            if(_imageList.indexOf(_cursorImageid) != 0) ...[  //if not the first image in this folder
                              Positioned(
                                height: constraints.maxWidth*0.09,
                                width: constraints.maxWidth*0.03,
                                left: constraints.maxWidth*0.05,
                                top: constraints.maxHeight*0.3 - constraints.maxWidth*0.03, //to position it at the center of imageholder, centerposition - height
                                child: ClipPath(
                                  clipper: LeftTriangleButton(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      previousImage();
                                    },
                                    child: null,
                                  )
                                ),
                              ),
                            ],
                            if(_imageList.indexOf(_cursorImageid) != (_imageList.length - 1)) ...[  //if not the last image in this folder
                              Positioned(
                                height: constraints.maxWidth*0.09,
                                width: constraints.maxWidth*0.03,
                                left: constraints.maxWidth*0.95 - constraints.maxWidth*0.03,
                                top: constraints.maxHeight*0.3 - constraints.maxWidth*0.03, //to position it at the center of imageholder, centerposition - height
                                child: ClipPath(
                                  clipper: RightTriangleButton(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      nextImage();
                                    },
                                    child: null,
                                    )
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: constraints.maxHeight*0.4,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                        borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      margin: const EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),  //follow imageholder margin
                      child: Container(
                        margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.03, 0.0, constraints.maxWidth*0.03, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: constraints.maxHeight*0.06,
                                  width: (constraints.maxWidth - 3.0*2 - constraints.maxWidth*0.03*2) - constraints.maxHeight*0.06 - 5,
                                  child: Text("Name: ${tempImage.name}", style: Theme.of(context).textTheme.headline6),
                                ),
                                Container(
                                  height: constraints.maxHeight*0.06,
                                  width: constraints.maxHeight*0.06,  //same as height to make it square
                                  child: IconButton(
                                    color: Theme.of(context).colorScheme.inverseSurface,
                                    icon: const Icon(Icons.arrow_drop_down, size: 30.0),
                                    onPressed: () {
                                      setState(() {
                                        showDetails = !showDetails;
                                      });
                                    },
                                  )
                                )
                              ],
                            ),
                            if(showDetails)...[
                              Container(
                                alignment: Alignment.centerLeft,
                                height: constraints.maxHeight*0.06,
                                width: (constraints.maxWidth - 3.0*2 - constraints.maxWidth*0.03*2),
                                child: Text("Date: ${tempImage.createdAt}", style: Theme.of(context).textTheme.headline6),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: constraints.maxHeight*0.06,
                                width: (constraints.maxWidth - 3.0*2 - constraints.maxWidth*0.03*2),
                                child: Text("Size: ${(imageSize<1000000?imageSize/1024:imageSize/1024/1024).ceilToDouble()} ${imageSize<1000000?'kb':'mb'}", style: Theme.of(context).textTheme.headline6),
                              ),
                            ],
                            Container(
                              alignment: Alignment.centerLeft,
                              height: constraints.maxHeight*0.06,
                              width: (constraints.maxWidth - 3.0*2 - constraints.maxWidth*0.03*2),
                              child: Text("Description:", style: Theme.of(context).textTheme.headline6),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: constraints.maxHeight*0.4 - constraints.maxHeight*0.06*(showDetails?4:2) - 2,
                              width: (constraints.maxWidth - 3.0*2 - constraints.maxWidth*0.03*2),
                              padding: EdgeInsets.only(left: constraints.maxWidth*0.03),
                              child: Scrollbar(
                                controller: _scrollController,
                                child: ListView(
                                  cacheExtent: 0.0,
                                  children: [
                                    Text("${tempImage.description}", style: Theme.of(context).textTheme.headline6)
                                  ],
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      )
    );
  }
}

