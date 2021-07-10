import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  //Note: final variables (including String) are immutable once initialized, thus no need for private
  late VoidCallback? _loginMethod;    //the method to run when button pressed, private to prevent access of method detail outside class
  final String loginLogo;             //logo to show for the button
  final String loginText;             //text to show for the button

  SignInButton({
    Key? key,
    final VoidCallback? loginMethod = null,  //by default, no function attached, making the button disabled
    this.loginLogo = "assets/images/question_mark.png", //by default is a question mark picture
    this.loginText = "Unassigned"
    }) : super(key: key) {_loginMethod = loginMethod;}

  @override
  Widget build(BuildContext context) {
     final screenHeight = MediaQuery.of(context).size.height;  //get full height of screen (including status bar etc)
     final screenWidth = MediaQuery.of(context).size.width;    //get full width of screen
     return Container(
       height: screenHeight * 0.1,  //fixed ratios on all screen, adaptive size
       width: screenWidth * 0.7,
       margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0), //to not stick with other buttons
       child: ElevatedButton(
         style: ElevatedButton.styleFrom(
           padding: EdgeInsets.all(5.0),
           elevation: 5.0,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(13.0),
           ),
         ),
         onPressed: _loginMethod, //null will disable the button, and also removes elevation
         child: LayoutBuilder(
           builder: (context, constraints) {  //to get the size of the container
             return Row(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(left: 5.0, right: 2.5),
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(13.0),
                     child: Image.asset(
                       loginLogo,
                       height: constraints.maxHeight * 0.95,
                       width: constraints.maxHeight * 0.95,
                       fit: BoxFit.cover,
                     ),
                   ),
                 ),
                 Expanded(  //take up the remaining space on the right side of icon
                   child: Container(
                     padding: EdgeInsets.only(left: 2.5, right: 5.0), //to not stick to icon
                     alignment: Alignment.center,
                     child: Text(
                       loginText,
                       overflow: TextOverflow.ellipsis, //prevents text that are too long, eg, Longggggg...
                       style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center,
                     )
                   )
                 ),
               ],
             );
           }
         )
       )
     );
  }
}