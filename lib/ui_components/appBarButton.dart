import 'package:flutter/material.dart';

class bottomBarButton extends StatelessWidget {
  late VoidCallback? _onPressed;  //the method to run when button pressed, private to prevent access of method detail outside class
  final Icon iconLogo;          //logo to show for the button
  final String iconText;

  bottomBarButton({
    Key? key,
    final VoidCallback? onPressed = null, //by default, no function attached, making the button disabled
    this.iconLogo = const Icon(Icons.warning_amber_rounded),
    this.iconText = "Unassigned",
  }) : super(key: key) {_onPressed = onPressed;}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;  //get full height of screen (including status bar etc)
    final screenWidth = MediaQuery.of(context).size.width;    //get full width of screen
    return Container(
        height: screenHeight * 0.1,  //fixed ratios on all screen, adaptive size
        width: screenWidth * 0.2,
        margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0), //to not stick with other ui_components
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(5.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
            ),
            onPressed: _onPressed, //null will disable the button, and also removes elevation
            child: LayoutBuilder(
                builder: (context, constraints) {  //to get the size of the container
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: iconLogo,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(iconText,
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  );
                }
            )
        )
    );
  }
}