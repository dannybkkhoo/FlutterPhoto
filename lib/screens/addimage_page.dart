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

//create addimage page with tabs (for each detail for user to fill)
class AddImagePage extends ConsumerStatefulWidget {
  late String folderid;
  late String imageid;

  AddImagePage(this.folderid, this.imageid);

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends ConsumerState<AddImagePage> {
  final _formKey = GlobalKey<FormState>();
  late ScrollController _scrollController;
  bool _enableDone = true;
  Imagedata tempImage = Imagedata(id:"",name:"",createdAt:"",ext:"");

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

  PreferredSizeWidget? appBar(){
    final foldername = ref.read(userdataProvider).foldername(widget.folderid);
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height*0.07 //same as bottom appbar (also same as constraints.maxHeight*0.07)
    ),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 10.0, //same as detailTab
        title: Text("Adding new image${foldername!=""?' to ${foldername}':''}...", style: Theme.of(context).textTheme.headline6),
        actions: [
          // Padding( //disabled for now, might enable in the future
          //   padding: EdgeInsets.all(10.0),  //make button slightly smaller than appbar
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Theme.of(context).colorScheme.tertiary,
          //       elevation: 10.0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(3.0)),
          //       )
          //     ),
          //     child: Text("Reset", style: Theme.of(context).textTheme.headline6),
          //     onPressed: () => print("Hello"),
          //   ),
          // )
        ]
      ),
    );
  }

  Future<void> cancelAndClose() async {
    if(await confirmationPopUp(context,content: "Stop adding new image?")) {
      ref.read(pagestatusProvider).imageFile = null;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(imageStatus("Cancelled adding image..."));
    };
  }

  BottomAppBar bottomAppBar(){
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight*0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),  //make button slightly smaller than appbar
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      elevation: 10.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                    ),
                    child: Text("Done", style: Theme.of(context).textTheme.headline6),
                    onPressed: !_enableDone?
                      null
                      :
                      () {
                        final pageStatus = ref.read(pagestatusProvider);
                        if (!pageStatus.hasImageFile) {
                          ScaffoldMessenger.of(context).showSnackBar(imageStatus("Please select an image from Gallery or Camera..."));
                        }

                        if (_formKey.currentState!.validate() && pageStatus.hasImageFile) {
                          setState(() {_enableDone = false;});

                          final UserdataProvider userdata = ref.read(userdataProvider);
                          final CloudStorageProvider cloudStorage = ref.read(cloudStorageProvider);

                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(imageStatus("Adding new image to ${userdata.foldername(widget.folderid)}...", duration: const Duration(days: 365)));

                          userdata.addImage(cloudStorageProvider: cloudStorage, imageFile: pageStatus.imageFile!, folderid: widget.folderid, name: tempImage.name, description: tempImage.description).then(
                            (bool addSuccess) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              if(addSuccess) {
                                ref.read(pagestatusProvider).imageFile = null;
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(imageStatus("New image '${tempImage.name}' added to '${userdata.foldername(widget.folderid)}'!"));
                              }
                              else {
                                setState(() {_enableDone = true;});
                                ScaffoldMessenger.of(context).showSnackBar(imageStatus("Failed to add new image, please try again..."));
                              }
                            }
                          );
                        }
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),  //make button slightly smaller than appbar
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      elevation: 10.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                    ),
                    child: Text("Cancel", style: Theme.of(context).textTheme.headline6),
                    onPressed: () async {
                      await cancelAndClose();
                    },
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Screen().portrait();
    _scrollController = ScrollController();
    _enableDone = true;
  }

   //resize when >5mb
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await cancelAndClose();
        return true;
      },
      child: Scaffold(
        appBar: appBar(),
        bottomNavigationBar: bottomAppBar(),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabHeight = constraints.maxHeight*0.1;
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                child: Form(
                  key: _formKey,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        ImageHolder(height: constraints.maxHeight*0.6,),
                        DropDownButton(
                          labelText: "Image Name",
                          hintText: "eg. myImage",
                          errorText: "This image name already exists in this folder!",
                          enableDropdown: false,
                          required: true,
                          buttonHeight: tabHeight,
                          inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z0-9_]"), allow: true)],
                          onSaved: (String? text) {
                            assert(text != null);
                            tempImage.name = text!;
                          },
                          validator: (String text) {
                            final imageNamesInFolder = ref.read(userdataProvider).imagesNameInFolder(widget.folderid);
                            if(imageNamesInFolder.containsValue(text)) {
                              return false;
                            }
                            else {
                              return true;
                            }
                          },
                        ),
                        DropDownButton(
                          labelText: "Description",
                          hintText: "eg. first image taken... (multiple line, max 300 char)",
                          enableDropdown: false,
                          multiline: true,
                          maxCharacters: 300,
                          required: false,
                          buttonHeight: constraints.maxHeight*0.4 - tabHeight - 12.0, //(to take up remaining space, 12.0 = 3.0 padding * 4),
                          onSaved: (String? text) {
                            assert(text != null);
                            tempImage.description = text!;
                          },
                        ),
                      ],
                    )
                  ),
                ),
              );
            },
          ),
        ),
      )
    );
  }
}
