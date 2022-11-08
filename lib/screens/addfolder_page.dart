import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/screen.dart';
import '../bloc/userdata.dart';
import '../providers/top_level_providers.dart';
import '../ui_components/dropdown_button.dart';
import '../ui_components/confirmation_popup.dart';

//create addfolder page with tabs (for each detail for user to fill)
class AddFolderPage extends ConsumerStatefulWidget {
  @override
  _AddFolderPageState createState() => _AddFolderPageState();
}

class _AddFolderPageState extends ConsumerState<AddFolderPage> {
  final _formKey = GlobalKey<FormState>();
  late ScrollController _scrollController;
  Folderdata tempFolder = Folderdata(id:"",name:"",createdAt:"",updatedAt:"");

  SnackBar folderStatus(String text, {Duration duration = const Duration(seconds:1)}) {
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
        title: Text("Create new folder...", style: Theme.of(context).textTheme.headline6),
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
                        ScaffoldMessenger.of(context).showSnackBar(folderStatus("Creating new folder...", duration: const Duration(days: 365)));

                        final userdata = ref.watch(userdataProvider);
                        userdata.addFolderdata(tempFolder).then( (bool addSuccess) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          if(addSuccess) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(folderStatus("New folder '${tempFolder.name}' created!"));
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(folderStatus("Failed to create new folder, please try again..."));
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
                      if(await confirmationPopUp(context,content: "Stop creating new folder?")) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(folderStatus("Cancelled folder creation..."));
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
                        DropDownButton(
                          labelText: "Folder Name",
                          hintText: "eg. myFolder",
                          errorText: 'This folder already exists!',
                          enableDropdown: false,
                          required: true,
                          buttonHeight: tabHeight,
                          inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z0-9_]"), allow: true)],
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.name = text!;
                          },
                          validator: (String text) {
                            if(foldernames.containsValue(text)) {
                              return false;
                            }
                            else {
                              return true;
                            }
                          },
                        ),
                        DropDownButton(
                          labelText: "Category",
                          hintText: "eg. Coin",
                          errorText: 'Must be "Coin" or "Notes" only!',
                          required: true,
                          strict: true,
                          buttonHeight: tabHeight,
                          items: [
                            "Coin",
                            "Notes",
                          ],
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.category = [text!];  //to expand on functionality to have multiple categories together in a list
                          },
                        ),
                        DropDownButton(
                          labelText: "Country Grouping",
                          hintText: "eg. US",
                          errorText: 'Select from provided country grouping only',
                          strict: true,
                          buttonHeight: tabHeight,
                          items: [
                            "M",
                            "US",
                          ],
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.countrygroup = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Country Or Type",
                          hintText: "eg. US - Half Cents",
                          errorText: 'Select from provided country grouping only',
                          strict: true,
                          buttonHeight: tabHeight,
                          items: [
                            "M - Malaysia",
                            "US - Half Cents",
                            "US - Cents",
                            "US - Two Cents",
                          ],
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.countrytype = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Denomination",
                          hintText: "eg. 20C",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.denomination = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Mintage Year",
                          hintText: "eg. 1967",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.mintageYear = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Grade",
                          hintText: "eg. 72",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.grade = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Serial",
                          hintText: "eg. 110002020",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.serial = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Serial Link",
                          hintText: "eg. https://www.ngccoin.com/world/malaya-and-malaysia/sc-207/cent/",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.serialLink = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Purchase Price",
                          hintText: "eg. USD 100",
                          keyboardType: TextInputType.number,
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.purchasePrice = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Purchase Date",
                          hintText: "eg. 12/8/2021",
                          keyboardType: TextInputType.datetime,
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.purchaseDate = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Current Price/Sold Price",
                          hintText: "eg. USD 50",
                          keyboardType: TextInputType.number,
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.currentsoldprice = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Sold Date",
                          hintText: "eg. 12/8/2021",
                          keyboardType: TextInputType.datetime,
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.solddate = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Status",
                          hintText: "eg. Sold",
                          buttonHeight: tabHeight,
                          items: [
                            "Sold",
                            "Owned",
                            "In Process",
                            "Storage",
                          ],
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.status = text!;
                          },
                        ),
                        DropDownButton( //to be updated with functions
                          labelText: "Population Link",
                          hintText: "eg. eg. https://www.pmgnotes.com/population-report/malaya-and-malaysia/malaysia/1000-ringgit/",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.populationLink = text!;
                          },
                        ),
                        DropDownButton(
                          labelText: "Remarks",
                          hintText: "eg. To be sent out",
                          enableDropdown: false,
                          buttonHeight: tabHeight,
                          onSaved: (String? text) {
                            assert(text != null);
                            tempFolder.remarks = text!;
                          },
                        )
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
