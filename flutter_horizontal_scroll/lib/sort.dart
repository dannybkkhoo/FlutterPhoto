 import 'package:flutter/material.dart';


class SortMe extends StatefulWidget{
  List folderName;
  SortMe(this.folderName);
  @override
  State<StatefulWidget> createState() => SortMeState(); //this part is creating a "State" for the widget
}
class SortMeState extends State<SortMe> {

 /*List foldernames = [
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
    'Estonia',
    'Finland',
    'France',
    'Georgia',
    'Germany',
    'Greece',
    'Hungary',
    'Iceland',
    'Ireland',
    'Italy',
    'Kazakhstan',
    'Kosovo',
    'Latvia',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macedonia',
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
  ];*/
  @override
  bool isSort = true;

  void sort(List folders) {
    widget.folderName.sort((a, b) => isSort ? a.compareTo(b) : b.compareTo(a));
    isSort = !isSort;

  }

  List SortedFolders;
  @override
  void initState(){
    super.initState();
    sort(widget.folderName);
    SortedFolders = widget.folderName;
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

              setState(() {
                widget.folderName = SortedFolders;
              });
            },
          )
        ],
      ),
      body: Center(
          child: Container(
            width: 200,
            height: 200,
            child: Center(
              child: Text(widget.folderName.toString()), //names.toString()
            ),
          )
      ),
    );
  }
}