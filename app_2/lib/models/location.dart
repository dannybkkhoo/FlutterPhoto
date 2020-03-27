import 'package:flutter/material.dart';
import 'location_fact.dart';

class Location {
  final int id;
  String name;
  String imagePath;
  final List<LocationFact> facts;

  Location(this.id,this.name,this.imagePath,this.facts);

  static Location fetchByID(int locationID){
    List<Location> locations = Location.fetchAll();
    for (var i= 0; i< locations.length;i++){
      if(locations[i].id == locationID){
        return locations[i];
      }
    }
    return null;
  }

  static List<Location> fetchAll(){
    return [
      Location(1,'Solar','assets/images/solar.jpg',[
        LocationFact('Intro','Creator of Solarsido'),
        LocationFact('Description','Friend of Moonbyul'),
      ]),
      Location(2,'IU','assets/images/iu.png',[
        LocationFact('Intro','Goddess'),
        LocationFact('Description','3000 years old'),
      ]),
      Location(3,'Ah Bai','assets/images/zhewei.png',[
        LocationFact('Intro','Photographer'),
        LocationFact('Intro','Good good friend'),
      ]),
    ];
  }
}