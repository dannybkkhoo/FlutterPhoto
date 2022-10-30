import 'dart:async';
import 'package:app2/app_router.dart';
import 'package:app2/providers/pagestatus_provider.dart';
import 'package:flutter/material.dart';
import '../providers/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/userdata.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../providers/userdata_provider.dart';
import '../bloc/screen.dart';
import '../ui_components/confirmation_popup.dart';
import '../ui_components/searchBar.dart';
import '../ui_components/item_card.dart';
import '../app_router.dart';
import '../ui_components/styled_buttons.dart';

class FolderPage extends ConsumerStatefulWidget {
  late String folderid;

  FolderPage(this.folderid);

  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends ConsumerState<FolderPage> {
  String foldername = "?";
  List<Widget> listOfImages = [];
  Map<String,String> imageNames = {};
  Map<String,String> imageIds = {};

  void loadImages(UserdataProvider userdataProvider, PagestatusProvider pagestatusProvider){
    final Map<String, Imagedata> images = userdataProvider.userdata!.images;                    //map of all images under the user
    final List<String> imageList = userdataProvider.folderData(widget.folderid)?.imagelist??[]; //list of imageids under this folder
    List<String> nameList = [];
    List<Widget> list = [];
    listOfImages = [];  //reset the list
    imageNames = {};
    imageIds = {};

    for (String imageid in imageList) {
      if(images.containsKey(imageid)){
        listOfImages.add(ItemCard(id: imageid, type: ItemType.image,));
        imageNames[imageid] = images[imageid]?.name??"?"; //imageid:imagename
        imageIds[imageNames[imageid]!] = imageid;          //imagename:imageid
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

    //Load and display all leftover folders
    for(String imageName in nameList) {
      list.add(ItemCard(id: imageIds[imageName]!, type: ItemType.image,));
    }
    listOfImages = list;
  }

  SnackBar sortStatus(String text, {Duration duration = const Duration(seconds:1)}) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(text, style: Theme.of(context).textTheme.subtitle1,),
      duration: duration,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(13.0))
      ),
    );
  }

  PreferredSizeWidget? appBar(PagestatusProvider pageStatus, UserdataProvider userdata){
    final bool isSelecting = pageStatus.isSelecting;
    final Folderdata? folder = userdata.folderData(widget.folderid);
    return PreferredSize(
      preferredSize: Size(double.infinity ,MediaQuery.of(context).size.height*0.07*1.5),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.all(3.0),
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              ),
            );
          },
        ),
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
                if(!isSelecting) ... [
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.home_rounded,
                    onPressed: () {
                      //to fill in, return to home
                    },
                    text: "Home",
                  ),
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.add,
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.addFolderPage);
                    },
                    text: "Add Image",
                  ),
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.sort_by_alpha_rounded,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      pageStatus.sortType = pageStatus.sortType != SortType.AtoZ? SortType.AtoZ: SortType.ZtoA;
                      ScaffoldMessenger.of(context).showSnackBar(sortStatus("Sort folders by '${pageStatus.sortType == SortType.AtoZ?'A-Z':'Z-A'}'", duration: const Duration(milliseconds:500)));
                    },
                    text: "Sort",
                  ),
                ],
                if(isSelecting) ... [
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.storage,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      pageStatus.removeAllFolder();
                      for (String folderId in userdata.folders.keys) {
                        pageStatus.addSelectedFolder(folderId);
                      }
                    },
                    text: "Select All",
                  ),
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.delete,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if(await confirmationPopUp(context, content: "Are you sure you want to remove ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''}?")){
                        unawaited(userdata.deleteFolders(pageStatus.selectedFolders));
                        pageStatus.removeAllFolder();
                        pageStatus.isSelecting = false;
                      }
                    },
                    text: "Delete",
                  ),
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.cancel,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      pageStatus.removeAllFolder();
                      pageStatus.isSelecting = false;
                    },
                    text: "Cancel",
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Screen().portrait();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = ref.watch(userdataProvider);
    final pageStatus = ref.watch(pagestatusProvider);
    loadImages(userdata,pageStatus);
    return WillPopScope(
      onWillPop: () async {
        unawaited(Navigator.popAndPushNamed(context, AppRoutes.collectionsPage));
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(pageStatus, userdata),
        bottomNavigationBar: bottomNavigationBar(pageStatus, userdata),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints){
              if(listOfImages.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(3.0),
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: RawScrollbar(
                    child: InkWell(
                      radius: 13.0,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: AlignedGridView.count(
                        itemCount: listOfImages.length,
                        crossAxisCount: 3,
                        mainAxisSpacing: 9.0,
                        crossAxisSpacing: 9.0,
                        itemBuilder: (context, index){
                          return listOfImages[index];
                        },
                      ),
                    ),
                    radius: const Radius.circular(13.0),
                    thickness: 9.0,
                    thumbColor: Theme.of(context).colorScheme.secondary,
                  ),
                );
              }
              else {
                return Container(
                  padding: const EdgeInsets.all(3.0),
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.hide_image_rounded, size: constraints.maxHeight*0.2),
                        SizedBox(height: constraints.maxHeight*0.02,),
                        Text("No Image Found...", style: Theme.of(context).textTheme.headline6,)
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
