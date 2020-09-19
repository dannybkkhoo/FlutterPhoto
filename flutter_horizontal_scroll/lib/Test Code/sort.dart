 import 'package:flutter/material.dart';

 void main() {
   runApp(MaterialApp(home: SortMe()));
 }
class SortMe extends StatefulWidget{
  //List folderName;
  //SortMe(this.folderName);
  @override
  State<StatefulWidget> createState() => SortMeState(); //this part is creating a "State" for the widget
}
class SortMeState extends State<SortMe> {

 List folderName = [
    'Portugal',
   'Bosnia and Herzegovina',
    'Romania',
    'Russia',
    'San Marino',
    'Serbia',
    'Slovakia',
   'Bosnia and Herzegovina',
    'Slovenia',
    'Spain',
    'Sweden',
    'Switzerland',
    'Turkey',
   'Bosnia and Herzegovina',
    'Ukraine',
    'United Kingdom',
    'Vatican City',
    'Albania',
    'Andorra',
    'Armenia',
    'Austria',
    'Azerbaijan',
    'Belarus',
    'Belgium',
    'Bosnia and Herzegovina',
    'Bulgaria',
    'Croatia',
    'Cyprus',
    'Czech Republic',
    'Denmark',
   'Bosnia and Herzegovina',
    'Estonia',
    'Finland',
   'Bosnia and Herzegovina',
    'France',
    'Georgia',
    'Germany',
    'Greece',
    'Hungary',
    'Iceland',
    'Ireland',
   'Bosnia and Herzegovina',
   'Bosnia and Herzegovina',
    'Italy',
    'Kazakhstan',
    'Kosovo',
    'Latvia',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macedonia',
   'Bosnia and Herzegovina',
    'Malta',
    'Moldova',
    'Monaco',
    'Montenegro',
    'Netherlands',
    'Norway',
    'Poland',
    'Portugal',
    'Romania',
    'Russia',
    'San Marino',
    'Serbia',
    'Slovakia',
    'Slovenia',
    'Spain',
    'Sweden',
    'Switzerland',
    'Turkey',
    'Ukraine',
    'United Kingdom',
    'Vatican City'
  ];
  @override
  bool isSort = true;

  void sort(List folders) {
    folderName.sort((a, b) => isSort ? a.compareTo(b) : b.compareTo(a));
    isSort = !isSort;

  }

  List SortedFolders;
  @override
  void initState(){
    super.initState();
    //sort(folderName);
    SortedFolders = folderName;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhotoView'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              print('sortyo');
              sort(folderName);
              setState(() {
                folderName = SortedFolders;
              });
            },
          )
        ],
      ),
      body: Center(
          child: Container(
            width: 500,
            height: 500,
            child: Center(
              child: Text(folderName.toString()), //names.toString()
            ),
          )
      ),
    );
  }
}