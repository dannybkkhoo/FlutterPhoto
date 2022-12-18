import 'package:flutter/material.dart';

Future<void> loadingPopUp(BuildContext context, {String? title, String? content}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext showdialogContext) {
      return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(false); //return false by default if user press "back" button
          return Future.value(false);       //to allow back press
        },
        child: StatefulBuilder(
          builder: (stfulContext, setState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AlertDialog(
                    alignment: Alignment.center,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    content: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.1,
                          width: MediaQuery.of(context).size.width*0.1,
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).colorScheme.background,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 6.0,
                          ),
                        ),
                        if(content != null) ... [
                          Center(child: Text(content, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),)
                        ]
                      ],
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 13.0),
                    elevation: 10.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                    ),
                    title: title !=null ? Text(title, style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,):null,
                    titlePadding: const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 0.0),
                  ),
                ],
              ),
            );
          }
        ),
      );
    }
  );
}