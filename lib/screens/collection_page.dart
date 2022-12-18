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
import '../ui_components/styled_buttons.dart';
import '../ui_components/loading_popup.dart';
import '../bloc/cloud_storage.dart';

class CollectionPage extends ConsumerStatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  List<Widget> listOfFolders = [];

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
      list.add(ItemCard(id: folderIds[folderName]!, type: ItemType.folder));
    }
    listOfFolders = list;
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
                    text: "Add Folder",
                  ),
                  vIconButton(
                    context: context,
                    constraints: constraints,
                    icon: Icons.sort_by_alpha_rounded,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      pageStatus.sortType = pageStatus.sortType != SortType.AtoZ? SortType.AtoZ: SortType.ZtoA;
                      ScaffoldMessenger.of(context).showSnackBar(statusPopup("Sort folders by '${pageStatus.sortType == SortType.AtoZ?'A-Z':'Z-A'}'", duration: const Duration(milliseconds:500)));
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
                      if(await confirmationPopUp(context, content: "Are you sure you want to remove ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''} and all its contents inside?")){
                        bool deletedSuccessfully = false;
                        ScaffoldMessenger.of(context).showSnackBar(statusPopup("Deleting ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''}", duration: const Duration(milliseconds:500)));
                        unawaited(loadingPopUp(context, title: "Deleting ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''}"));
                        final CloudStorageProvider cloudStorage = ref.read(cloudStorageProvider);
                        deletedSuccessfully = await userdata.deleteFolders(cloudStorageProvider:cloudStorage, folderids:pageStatus.selectedFolders);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        if(deletedSuccessfully) {
                          ScaffoldMessenger.of(context).showSnackBar(statusPopup("Done deleting ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''}", duration: const Duration(milliseconds:500)));
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(statusPopup("Failed to delete ${pageStatus.selectedFolders.length} folder${pageStatus.selectedFolders.length>1?'s':''}", duration: const Duration(milliseconds:500)));
                        }
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
          }
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
                        Icon(Icons.folder_off_rounded, size: constraints.maxHeight*0.2),
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
