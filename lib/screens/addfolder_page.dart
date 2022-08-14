import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/screen.dart';
import '../bloc/userdata.dart';
import '../providers/top_level_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/userdata_provider.dart';

//create addfolder page with tabs (for each detail for user to fill)

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
      padding: const EdgeInsets.fromLTRB(3.0,0.0,3.0,0.0),
      child: TextField(
        autofocus: true,
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

class AddFolder extends ConsumerStatefulWidget {
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends ConsumerState<AddFolder> {
  List<String> category = [];
  late ScrollController _scrollController;

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
        resizeToAvoidBottomInset: false,
        //appBar: reset button,
        //bottomNavigationBar: OK and cancel button,
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
                        labelText: "FOLDER NAME:",
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
                        labelText: "Country:",
                        hintText: "eg. Malaysia",
                        onChanged: (text) {
                          setState(() {
                            tempFolder.country = text;
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
                      )
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