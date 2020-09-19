import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child:
                Column(
                    children:[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        constraints: BoxConstraints.expand(height:80.0,width:350.0),
                        child: Text("REGISTRATION",style: TextStyle(fontSize: 40))
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        constraints: BoxConstraints.expand(height:40.0,width:200.0),
                        child: Text("E-mail"),
                      ),
                      Container(
                        constraints: BoxConstraints.expand(height:50.0,width:200.0),
                        child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:'Email here',
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        constraints: BoxConstraints.expand(height:40.0,width:200.0),
                        child: Text("Password"),
                      ),
                      Container(
                        constraints: BoxConstraints.expand(height:50.0,width:200.0),
                        child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:"Password here",
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        constraints: BoxConstraints.expand(height:40.0,width:200.0),
                        child: Text("Phone Number"),
                      ),
                      Container(
                        constraints: BoxConstraints.expand(height:50.0,width:200.0),
                        child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:"Phone Number here",
                            )
                        ),
                      ),
                      SizedBox(height:20.0),
                      RaisedButton(
                        onPressed: null,
                        child: Text("Register"),
                      )
                    ]
                )
            )
          ]
      ),
    );
  }
}

BoxDecoration BoxDeco(){
  return BoxDecoration(
    border: Border.all(),
  );
}
