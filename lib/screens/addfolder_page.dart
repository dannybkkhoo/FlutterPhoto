import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/screen.dart';
import '../bloc/userdata.dart';
import '../providers/top_level_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/userdata_provider.dart';
import '../ui_components/dropdown_button2.dart';

//create addfolder page with tabs (for each detail for user to fill)



class AddFolder extends ConsumerStatefulWidget {
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends ConsumerState<AddFolder> {
  List<String> category = [];
  late ScrollController _scrollController;
  String temp = "A";

  PreferredSizeWidget? appBar(){
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height*0.07 //same as bottom appbar (also same as constraints.maxHeight*0.07)
      ),
      child: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10.0, //same as detailTab
          title: Text("Create new folder...", style: Theme.of(context).textTheme.headline6),
          actions: [
            Padding(
              padding: EdgeInsets.all(10.0),  //make button slightly smaller than appbar
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).dividerColor,
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

  Widget detailTab({required BuildContext context, required String labelText, required String hintText, String? errorText = null, List<TextInputFormatter>? inputFormatters = null, Function(String)? onChanged}) {

    final TextTheme hintStyle = Theme.of(context).textTheme.copyWith(
      subtitle2: TextStyle(color: Color(0xFFCCCCCC)),
    );
    final TextTheme errorStyle = Theme.of(context).textTheme.copyWith(
      subtitle2: TextStyle(color: Colors.red),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: MediaQuery.of(context).size.height*0.07,
        padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
        child: TextField(
          autofocus: false,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.subtitle1,
            hintText: hintText,
            hintStyle: hintStyle.subtitle2,
            errorText: errorText,
            errorStyle: errorStyle.subtitle2,
          ),
          inputFormatters: inputFormatters,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget dropdownTab({required BuildContext context, required String labelText, required String hintText, String? errorText = null, String? value = "", List<TextInputFormatter>? inputFormatters = null, Function(String)? onChanged, List<dynamic>? items = null}) {
    final TextTheme hintStyle = Theme.of(context).textTheme.copyWith(
      subtitle2: TextStyle(color: Color(0xFFCCCCCC)),
    );
    final TextTheme errorStyle = Theme.of(context).textTheme.copyWith(
      subtitle2: TextStyle(color: Colors.red),
    );

    return Container(
      color: Colors.white,
      child: DropDownField(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.subtitle1,
        hintText: hintText,
        hintStyle: hintStyle.subtitle2,
        errorText: errorText,
        errorStyle: errorStyle.subtitle2,
        initialValue: value,
        items: items,
      ),
    );
  }

  BottomAppBar bottomAppBar(){
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
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
                      primary: Theme.of(context).dividerColor,
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
                      primary: Theme.of(context).dividerColor,
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
    final Map<String,String> foldernames = userdata.foldernames;
    Folderdata tempFolder = Folderdata(id:"",name:"",createdAt:"",updatedAt:"");
    bool tapped = false, validated = false;
    String errormsg = "";
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
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Scrollbar(
                  thumbVisibility: false,
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      detailTab(
                        context: context,
                        labelText: "Folder Name:",
                        hintText: "eg. myFolder",
                        errorText: (tapped & !validated) ? errormsg: null,
                        inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z0-9_]"), allow: true)],
                        onChanged: (text) {
                          if (foldernames.containsValue(text)) {
                            setState((){
                              tapped = true;
                              validated = false;
                              tempFolder.name = text;
                              errormsg = tempFolder.name + " already exists";
                            });
                          }
                          else {
                            setState((){
                              tapped = true;
                              validated = true;
                              tempFolder.name = text;
                              errormsg = "";
                            });
                          }
                        },
                      ),
                      detailTab(
                        context: context,
                        labelText: "Country Grouping:",
                        hintText: "eg. Malaysia",
                        onChanged: (text) {
                          setState(() {
                            tempFolder.country = text;
                          });
                        }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Country Or Type:",
                          hintText: "eg. US-Half Cents",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.country = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Denomination:",
                          hintText: "eg. CENT",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                        context: context,
                        labelText: "Mintage Year:",
                        hintText: "eg. 1998",
                        onChanged: (text) {
                          setState(() {
                            tempFolder.mintageYear = text;
                          });
                        }
                      ),
                      detailTab(
                        context: context,
                        labelText: "Grade:",
                        hintText: "eg. 72",
                        onChanged: (text) {
                          setState(() {
                            tempFolder.grade = text;
                          });
                        }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Serial:",
                          hintText: "eg. 110002020",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Serial Link:",
                          hintText: "eg. https://www.ngccoin.com/world/malaya-and-malaysia/sc-207/cent/",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Purchase Price:",
                          hintText: "eg. USD 100",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Purchase Date",
                          hintText: "eg. 12/8/2021",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Current Price/Sold Price:",
                          hintText: "eg. USD 200",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Sold Date:",
                          hintText: "eg. 31/8/2021",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Status:",
                          hintText: "eg. Owned",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Storage:",
                          hintText: "eg. Where it is stored (in Safe)",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Population Link:",
                          hintText: "eg. https://www.pmgnotes.com/population-report/malaya-and-malaysia/malaysia/1000-ringgit/",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      detailTab(
                          context: context,
                          labelText: "Remarks:",
                          hintText: "eg. To be sent out",
                          onChanged: (text) {
                            setState(() {
                              tempFolder.mintageYear = text;
                            });
                          }
                      ),
                      dropdownTab(
                        context: context,
                        labelText: "Category",
                        hintText: "eg. Coin",
                        items: <String>[
                          "Coin",
                          "Notes",
                          "Others"
                        ]
                      ),
                      dropdownTab(
                        context: context,
                        labelText: "Country Grouping",
                        hintText: "eg. M, US",
                        value: "M",
                        items: <String>[
                          "M",
                          "US",
                        ]
                      )
                      // Container(
                      //   height: constraints.maxHeight*0.07,
                      //   width: constraints.maxWidth,
                      //   child: Row(
                      //     children: [
                      //       detailTab(
                      //           context: context,
                      //           labelText: "Testing:",
                      //           hintText: "Testing also",
                      //           onChanged: (text) {
                      //             setState(() {
                      //
                      //             });
                      //           }
                      //       ),
                      //       Container(
                      //         height: constraints.maxHeight*0.07,
                      //         width: constraints.maxWidth*0.07,
                      //         child: DropdownButton<String>(
                      //           isExpanded: true,
                      //           icon: Icon(Icons.arrow_drop_down),
                      //           value: temp,
                      //           items: [
                      //             DropdownMenuItem(child: Text("A"), value: "A"),
                      //             DropdownMenuItem(child: Text("B"), value: "B"),
                      //             DropdownMenuItem(child: Text("C"), value: "C")
                      //           ],
                      //             onChanged: (String? selection) {
                      //               setState(() {
                      //
                      //               });
                      //             }
                      //         ),
                      //       )
                      //     ]
                      //   ),
                      // ),
                    ]
                  )
                ),
              );
            }
          ),
        )
      )
    );
    throw UnimplementedError();
  }
}