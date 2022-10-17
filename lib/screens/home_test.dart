import 'dart:async';
import 'package:app2/app_router.dart';
import 'package:app2/providers/pagestatus_provider.dart';
import 'package:flutter/material.dart';
import '../providers/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/userdata.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../providers/userdata_provider.dart';
import '../bloc/screen.dart';
import '../ui_components/confirmation_popup.dart';

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<Widget> listOfFolders = [];

  @override
  void initState() {
    super.initState();
    Screen().portrait();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void loadFolders(Map<String,Folderdata> folders, Map<String,String> folderNames){
    List<Widget> list = [];
    for(MapEntry<String,String> folder in folderNames.entries){
      list.add(FolderItem(id: folder.key));
    }
    listOfFolders = list;
  }

  List<Widget>? appBarButtons(PagestatusProvider pageStatus, UserdataProvider userdata){
    final bool isSelecting = pageStatus.isSelecting;
    List<Widget> buttons = [];
    if(isSelecting){
      //Delete button
      buttons.add(
        IconButton(
          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.inverseSurface,),
          onPressed: () {
            userdata.deleteFolders(pageStatus.selectedFolders);
            pageStatus.removeAllFolder();
            pageStatus.isSelecting = false;
          },
        )
      );
      //Share button
      buttons.add(
          IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).colorScheme.inverseSurface,),
            onPressed: () {

            },
          )
      );
      //Cancel button
      buttons.add(
          IconButton(
            icon: Icon(Icons.cancel_outlined, color: Theme.of(context).colorScheme.inverseSurface,),
            onPressed: () {
              pageStatus.removeAllFolder();
              pageStatus.isSelecting = false;
            },
          )
      );
    }
    if(!isSelecting){
      //Search button
      buttons.add(
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.inverseSurface,),
            onPressed: () {

            },
          )
      );
      //Sort button
      buttons.add(
          IconButton(
            icon: Icon(Icons.sort_by_alpha, color: Theme.of(context).colorScheme.inverseSurface,),
            onPressed: () {
              //print(userdata.folders.);
            },
          )
      );
    }
    return buttons;
  }

  Widget vIconButton({required BoxConstraints constraints, required IconData icon, required VoidCallback? onPressed, String text = "", }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(icon, color: Theme.of(context).colorScheme.inverseSurface, size: constraints.maxHeight*0.6),
              onPressed: onPressed,
            ),
            height: constraints.maxHeight*0.7,
            padding: EdgeInsets.all(3.0),
            width: double.infinity,
          ),
          Container(
            child: Text(text,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            height: constraints.maxHeight*0.3,
            padding: EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
            width: double.infinity,
          ),
        ],
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
                    constraints: constraints,
                    icon: Icons.home_rounded,
                    onPressed: () {
                      //to fill in, return to home
                    },
                    text: "Home",
                  ),
                  vIconButton(
                    constraints: constraints,
                    icon: Icons.add,
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.addFolderPage);
                    },
                    text: "Add Folder",
                  ),
                  vIconButton(
                    constraints: constraints,
                    icon: Icons.sort_by_alpha,
                    onPressed: () {
                      //to fill in, sort the files n setstate
                    },
                    text: "Sort",
                  ),
                ],
                if(isSelecting) ... [
                  vIconButton(
                    constraints: constraints,
                    icon: Icons.storage,
                    onPressed: () {
                      for (String folderId in userdata.folders.keys) {
                        pageStatus.addSelectedFolder(folderId);
                      }
                    },
                    text: "Select All",
                  ),
                  vIconButton(
                    constraints: constraints,
                    icon: Icons.delete,
                    onPressed: () async {
                      if(await confirmationPopUp(context, content: "Are you sure you want to remove ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''}?")){
                        unawaited(userdata.deleteFolders(pageStatus.selectedFolders));
                        pageStatus.removeAllFolder();
                        pageStatus.isSelecting = false;
                      }
                    },
                    text: "Delete",
                  ),
                  vIconButton(
                    constraints: constraints,
                    icon: Icons.cancel,
                    onPressed: () {
                      pageStatus.removeAllFolder();
                      pageStatus.isSelecting = false;
                    },
                    text: "Cancel",
                  ),
                ]
              ],
            );
          }
        ),
      ),
    );
  }

  Widget appBarTitle(PagestatusProvider pageStatus){
    bool isSelecting = pageStatus.isSelecting;
    if(isSelecting){
      return Text("${pageStatus.selectedFolders.length} folders selected", style: Theme.of(context).textTheme.headline6);
    }
    return Text("My Gallery", style: Theme.of(context).textTheme.headline6);
  }

  PreferredSizeWidget? appBar(PagestatusProvider pageStatus, UserdataProvider userdata){
    return AppBar(
      title: appBarTitle(pageStatus),
      actions: appBarButtons(pageStatus, userdata),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseAuthProvider);
    final uid = user.firebaseUser?.uid;
    final userdata = ref.watch(userdataProvider);
    Map<String,Folderdata> folders = userdata.userdata!.folders;
    final pageStatus = ref.watch(pagestatusProvider);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(pageStatus, userdata),
        bottomNavigationBar: bottomNavigationBar(pageStatus, userdata),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints){
              loadFolders(folders,userdata.foldernames);
              return Container(
                padding: const EdgeInsets.all(3.0),
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: RawScrollbar(
                  child: AlignedGridView.count(
                    itemCount: listOfFolders.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 9.0,
                    crossAxisSpacing: 9.0,
                    itemBuilder: (context, index){
                      return listOfFolders[index];
                    },
                  ),
                  radius: const Radius.circular(13.0),
                  thickness: 6.0,
                  thumbColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            }
          )
        )
      ),
    );
  }
}

class FolderItem extends ConsumerWidget {
  late String _id;
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

  FolderItem({
    Key? key,
    required String id,
  }):super(key:key){
    this._id = id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String uid = ref.watch(userdataProvider).uid??"";
    String appDocDir = ref.watch(userdataProvider).appDocDir??"";
    Folderdata folder = ref.watch(userdataProvider.select((userdata) => userdata.folders[_id] as Folderdata));
    String imagepath = "";
    if(folder.imagelist.isEmpty){
      imagepath = "assets/images/question_mark.png";
    }
    else{
      Imagedata image = ref.watch(userdataProvider.select((userdata) => userdata.images[folder.imagelist[0]] as Imagedata));
      imagepath = appDocDir + "/" + uid + "/images/" + image.id + "." + image.ext;
    }
    _isSelecting = ref.watch(pagestatusProvider).isSelecting;
    _isSelected = ref.watch(pagestatusProvider).selectedFolders.contains(_id);

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
                    ref.read(pagestatusProvider).addSelectedFolder(_id);
                  }
                },
                onTap: () {
                  if(_isSelecting) {
                    _isSelected ?
                    ref.read(pagestatusProvider).removeSelectedFolder(_id) :
                    ref.read(pagestatusProvider).addSelectedFolder(_id);
                  }
                  else{
                    //go into folder
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
                          child: folder.imagelist.isEmpty?
                          Image.asset(imagepath,fit: BoxFit.contain,):
                          Image.file(File(imagepath), fit: BoxFit.contain,),
                        )
                      ),
                      Container(
                        height: constraints.maxHeight*0.25,
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.0),
                          child: Text(folder.name, style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      )
                    ],
                  ),
                  color: Theme.of(context).colorScheme.tertiary,
                  elevation: 10.0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0)
                  ),
                )
              ),
            );
          }
        ),
      ),
    );
  }
}