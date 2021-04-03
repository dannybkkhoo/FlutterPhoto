import 'package:flutter/material.dart';

class LogInOption extends StatelessWidget {
  final Function loginMethod;
  final String logoAsset, loginText;
  LogInOption(this.loginMethod,this.logoAsset,this.loginText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 270.0,
      margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
      child: RaisedButton(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
        color: Colors.white,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
            side: BorderSide(color: Colors.white)
        ),
        onPressed: loginMethod,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image(
              image: AssetImage(logoAsset),
              height: 50.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                alignment: Alignment.center,
                child: Text(
                  loginText,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto-Medium"
                  ),
                )
              )
            ),
          ],
        )
      )
    );
  }
}