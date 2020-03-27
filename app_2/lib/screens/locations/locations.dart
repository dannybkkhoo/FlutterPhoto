import 'package:app2/screens/main.dart';
import 'package:flutter/material.dart';
import '../../models/location.dart';

class Locations extends StatelessWidget{
  Widget build(BuildContext context){
    final locations = Location.fetchAll();
    return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: ListView(
          children: locations
              .map((location)=>GestureDetector(
                child: Text(location.name),
                onTap: () => _onLocationTap(context, location.id),
          )).toList(),
        )
    );
  }

  _onLocationTap(BuildContext context, int locationID){
    Navigator.pushNamed(context, LocationDetailRoute, arguments: {"id": locationID});
  }
}