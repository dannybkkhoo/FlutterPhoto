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

//create addfolder page with tabs (for each detail for user to fill)
class AddImagePage extends ConsumerStatefulWidget {
  late String folderid;

  AddImagePage(this.folderid);

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends ConsumerState<AddImagePage> {
  final _formKey = GlobalKey<FormState>();
  late ScrollController _scrollController;
  Folderdata tempFolder = Folderdata(id:"",name:"",createdAt:"",updatedAt:"");

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
    return PreferredSize(
      preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height*0.07 //same as bottom appbar (also same as constraints.maxHeight*0.07)
      ),
      child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          titleSpacing: 10.0, //same as detailTab
          title: Text("Adding new image...", style: Theme.of(context).textTheme.headline6),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(imageStatus("Adding new image...", duration: const Duration(days: 365)));

                          final userdata = ref.watch(userdataProvider);
                          userdata.addFolderdata(tempFolder).then( (bool addSuccess) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            if(addSuccess) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(imageStatus("New image '${tempFolder.name}' added!"));
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(imageStatus("Failed to add new image, please try again..."));
                            }
                          });
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
                        if(await confirmationPopUp(context,content: "Stop adding new image?")) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(imageStatus("Cancelled adding image..."));
                        };
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
  }



   //resize when >5mb
  @override
  Widget build(BuildContext context) {
    final userdata = ref.watch(userdataProvider);
    final Map<String,String> foldernames = userdata.foldernames;

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(true);
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
                                  errorText: "This image already exists in this folder!",
                                  enableDropdown: false,
                                  required: true,
                                  buttonHeight: tabHeight,
                                  inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z0-9_]"), allow: true)],
                                ),
                                DropDownButton(
                                  labelText: "Description",
                                  hintText: "eg. first image taken...",
                                  enableDropdown: false,
                                  required: false,
                                  buttonHeight: tabHeight,
                                ),
                              ],
                            )
                        ),
                      ),
                    );
                  }
              ),
            )
        )
    );
  }
}
