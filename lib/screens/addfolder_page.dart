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

//create addfolder page with tabs (for each detail for user to fill)
class AddFolder extends ConsumerStatefulWidget {
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends ConsumerState<AddFolder> {
  List<String> category = [];
  late ScrollController _scrollController;
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
          Padding(
            padding: EdgeInsets.all(10.0),  //make button slightly smaller than appbar
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.tertiary,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                )
              ),
              child: Text("Reset", style: Theme.of(context).textTheme.headline6),
              onPressed: () => print("Hello"),
            ),
          )
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
                  padding: EdgeInsets.all(10.0),  //make button slightly smaller than appbar
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.tertiary,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0))
                      )
                    ),
                    child: Text("Done", style: Theme.of(context).textTheme.headline6),
                    onPressed: () => print("Hello"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),  //make button slightly smaller than appbar
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.tertiary,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0))
                      )
                    ),
                    child: Text("Cancel", style: Theme.of(context).textTheme.headline6),
                    onPressed: () => print("Hello"),
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
    final user = ref.watch(firebaseAuthProvider);
    final uid = user.firebaseUser?.uid;
    final userdata = ref.watch(userdataProvider);
    final _formKey = GlobalKey<FormState>();
    final Map<String,String> foldernames = userdata.foldernames;
    Folderdata tempFolder = Folderdata(id:"",name:"",createdAt:"",updatedAt:"");
    String _errormsg = "";

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: appBar(),
        bottomNavigationBar: bottomAppBar(),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final _tabHeight = constraints.maxHeight*0.1;
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                child: Form(
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
                          // errorText: _errormsg,
                          enableDropdown: false,
                          required: true,
                          buttonHeight: _tabHeight,
                          inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z0-9_]"), allow: true)],
                          validator: (String text) {
                            if(foldernames.containsValue(text)) {
                              // _errormsg = "${text} already exists!";
                              return false;
                            }
                            else {
                              // _errormsg = "";
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
                          buttonHeight: _tabHeight,
                          items: [
                            "Coin",
                            "Notes",
                          ],
                        ),
                        DropDownButton(
                          labelText: "Country Grouping",
                          hintText: "eg. US",
                          errorText: 'Select from provided country grouping only',
                          strict: true,
                          buttonHeight: _tabHeight,
                          items: [
                            "M",
                            "US",
                          ]
                        ),
                        DropDownButton(
                          labelText: "Country Or Type",
                          hintText: "eg. US - Half Cents",
                          errorText: 'Select from provided country grouping only',
                          strict: true,
                          buttonHeight: _tabHeight,
                          items: [
                            "M - Malaysia",
                            "US - Half Cents",
                            "US - Cents",
                            "US - Two Cents",
                          ],
                        ),
                        DropDownButton(
                          labelText: "Denomination",
                          hintText: "eg. 20C",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Mintage Year",
                          hintText: "eg. 1967",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Grade",
                          hintText: "eg. 72",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Serial",
                          hintText: "eg. 110002020",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Serial Link",
                          hintText: "eg. https://www.ngccoin.com/world/malaya-and-malaysia/sc-207/cent/",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Purchase Price",
                          hintText: "eg. USD 100",
                          keyboardType: TextInputType.number,
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Purchase Date",
                          hintText: "eg. 12/8/2021",
                          keyboardType: TextInputType.datetime,
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Current Price/Sold Price",
                          hintText: "eg. USD 50",
                          keyboardType: TextInputType.number,
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Sold Date",
                          hintText: "eg. 12/8/2021",
                          keyboardType: TextInputType.datetime,
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Status",
                          hintText: "eg. Sold",
                          buttonHeight: _tabHeight,
                          items: [
                            "Sold",
                            "Owned",
                            "In Process",
                            "Storage",
                          ],
                        ),
                        DropDownButton( //to be updated with functions
                          labelText: "Population Link",
                          hintText: "eg. eg. https://www.pmgnotes.com/population-report/malaya-and-malaysia/malaysia/1000-ringgit/",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
                        ),
                        DropDownButton(
                          labelText: "Remarks",
                          hintText: "eg. To be sent out",
                          enableDropdown: false,
                          buttonHeight: _tabHeight,
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
