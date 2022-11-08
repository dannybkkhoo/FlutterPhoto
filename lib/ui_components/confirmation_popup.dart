import 'package:flutter/material.dart';

Future<bool> confirmationPopUp(BuildContext context, {String? title, String? content}) async {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.surfaceTint,
    elevation: 10.0,
    padding: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(13.0))
    )
  );

  return showDialog<bool>(
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
                    actions: [
                      ElevatedButton(
                        style: flatButtonStyle,
                        child: Text("Yes", style: Theme.of(context).textTheme.headline6),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      ElevatedButton(
                        style: flatButtonStyle,
                        child: Text("No", style: Theme.of(context).textTheme.headline6),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    alignment: Alignment.center,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    buttonPadding: const EdgeInsets.only(left: 13.0, right: 13.0),
                    content: content !=null ? Center(child: Text(content, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),):null,
                    contentPadding: const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 0.0),
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
  ).then((bool? response) => response??false);
}