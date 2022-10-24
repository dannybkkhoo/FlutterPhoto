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
import '../ui_components/searchBar.dart';

class Collection extends ConsumerStatefulWidget {
  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends ConsumerState<Collection> {
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

  void loadFolders(UserdataProvider userdataProvider, PagestatusProvider pagestatusProvider){
    final Map<String, Folderdata> folders = userdataProvider.userdata!.folders;
    final Map<String, String> folderNames = userdataProvider.foldernames; //folderid:foldername
    final Map<String, String> folderIds = userdataProvider.folderids;     //foldername:folderid
    List<String> nameList = [];
    List<Widget> list = [];
    listOfFolders = []; //reset the list

    //Filter according to search
    if(pagestatusProvider.isSearching) {
      final String searchKeyword = pagestatusProvider.searchKeyword;
      for(String name in folderNames.values) {  //search through folder name only
        if(name.toLowerCase().contains(searchKeyword.toLowerCase())){
          nameList.add(name);
        }
      }
    }
    else {
      nameList = folderNames.values.toList();
    }

    //Filter according to user selection (category/tag/date etc)

    //Sort according to name
    nameList = pagestatusProvider.sort(nameList);

    //Load and display all leftover folders
    for(String folderName in nameList) {
      list.add(FolderItem(id: folderIds[folderName]!));
    }
    listOfFolders = list;
  }

  SnackBar sortStatus(String text, {Duration duration = const Duration(seconds:1)}) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(text, style: Theme.of(context).textTheme.subtitle1,),
      duration: duration,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(13.0))
      ),
    );
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
            padding: const EdgeInsets.all(3.0),
            width: double.infinity,
          ),
          Container(
            child: Text(text,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            height: constraints.maxHeight*0.3,
            padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
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
          }
        ),
      ),
    );
  }

  PreferredSizeWidget? appBar(PagestatusProvider pageStatus, UserdataProvider userdata){
    final bool isSelecting = pageStatus.isSelecting;
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
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(isSelecting?
                    "${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''} selected"
                      :
                    "My Collections (${listOfFolders.length} folder${listOfFolders.length>1?'s':''})",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.start,
                    ),
                    height: constraints.maxHeight*0.4,
                    padding: const EdgeInsets.only(bottom: 6.0, left: 3.0),
                    width: constraints.maxWidth,
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: SearchBar(pageStatus: pageStatus),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                      borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    height: constraints.maxHeight*0.5,
                    padding: EdgeInsets.zero,
                    width: constraints.maxWidth,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userdata = ref.watch(userdataProvider);
    final pageStatus = ref.watch(pagestatusProvider);
    loadFolders(userdata,pageStatus);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(pageStatus, userdata),
        bottomNavigationBar: bottomNavigationBar(pageStatus, userdata),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints){
              if(listOfFolders.isNotEmpty) {
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
                        itemCount: listOfFolders.length,
                        crossAxisCount: 3,
                        mainAxisSpacing: 9.0,
                        crossAxisSpacing: 9.0,
                        itemBuilder: (context, index){
                          return listOfFolders[index];
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
                        Icon(Icons.folder_off, size: constraints.maxHeight*0.2),
                        SizedBox(height: constraints.maxHeight*0.02,),
                        Text("No Folder Found...", style: Theme.of(context).textTheme.headline6,)
                      ],
                    ),
                  ),
                );
              }
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
    Folderdata? folder = ref.watch(userdataProvider.select((userdata) => userdata.folders[_id]));
    String imagepath = "";

    if (folder == null || folder.imagelist.isEmpty) {
      imagepath = "assets/images/question_mark.png";
    }
    else {
      Imagedata image = ref.watch(userdataProvider.select((userdata) => userdata.images[folder!.imagelist[0]]!),);
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
                          child: folder != null && folder.imagelist.isEmpty?
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
                          child: Text(folder?.name??"?", style: Theme.of(context).textTheme.headline6,
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