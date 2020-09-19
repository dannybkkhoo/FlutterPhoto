import 'dart:io';
import 'dart:async';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterhorizontalscroll/Page3.dart';
import 'dart:math';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'GeneratePDF.dart';
void main() => runApp(MaterialApp(

  initialRoute: '/Page1',
  routes: <String, WidgetBuilder>{
    '/Page1': (context) => MainPageFolder(title: "My Gallery",),

  },
));


//Now use stateful Widget = Widget has properties which can be changed
class MainPageFolder extends StatefulWidget {
  //MainPageFolder({Key key}) : super(key:key);

  final String title;
  //Custom constructor, add property : title
  @override
  MainPageFolder({this.title}) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageFolderState();//Return a state object
  }
}
class MainPageFolderState extends State<MainPageFolder> {
  //State must have "build" => return Widget

  List<Widget> folders = new List<Widget>();
  List<Map> foldernames = List();
  final pdf = pw.Document();
  List<pw.Widget> items = new List<pw.Widget>();
  List<pw.Widget> photo = new List<pw.Widget>();
  List<PdfImage> images = new List<PdfImage>();

  //List<String> folderdates = List();
  bool _selectionMode = false;
  bool _checker = false;
  Directory _downloadsDirectory;
  List<int> _selectedIndexList = List();
  List<Map> duplicatefoldernames = List();
  List<Map> Tempfolder = List();
  List<Map> Tempmaps = List();
  ScrollController _controller = ScrollController();
  int num = 0;
  void appendfoldernames(onValue){
    if(onValue != null) {
      setState(() {
        //folders.add(folder);
        foldernames.add({"foldername":"$onValue", "folderdate": DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"folderdescription": null,"folderlink": null});
        //foldernames = List.from(foldernames)..add(onValue);
        //duplicatefoldernames = List.from(duplicatefoldernames)..add(onValue);
        duplicatefoldernames.add({"foldername":"$onValue", "folderdate": DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString(),"folderdescription": null,"folderlink": null});
        print(foldernames);
        print(foldernames.length);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    initDownloadsDirectoryState();
  }
  Future<void> initDownloadsDirectoryState() async {
    Directory downloadsDirectory;

    try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }

    if (!mounted) return;

    setState(() {
      _downloadsDirectory = downloadsDirectory;
      print('Got _downloadsDirectory= $_downloadsDirectory');
    });
  }
 /* void appendfolderdates(){
    setState(() {
      folderdates = List.from(folderdates)..add(DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString());
      print(folderdates);
      print(folderdates.length);
    });

  }*/
  /*void addFolder(folder){

    if(folder != null) {
      setState(() {
        //folders.add(folder);
        folders = List.from(folders)..add(folder);
        print(folders);
      });
    }
  }*/



  /*void deleteFolder(ShowFolder folder){
    if(folder != null) {
      setState(() {
        folders = List.from(folders)..remove(folder);
        num--;
        print(num);
        print(folders);
      });
    }
  }*/

  Future<String> createAlertDialog(BuildContext context){
    TextEditingController foldernameController = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Folder Name?"),
        content: TextField(
          controller: foldernameController ,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();

            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
            onPressed: (){
              Navigator.of(context).pop(foldernameController.text.toString());
              num++;

            },
          )
        ],
      );
    });
  }



  @override
  bool isSortfolder = true;
  bool isSortDate = true;
  bool Tick = false;

  void sortdate(List foldernames, duplicatefoldernames) {
    foldernames.sort((a, b) =>  isSortDate ?  a['folderdate'].compareTo(b['folderdate']) : b['folderdate'].compareTo(a['folderdate']));
    duplicatefoldernames.sort((a, b) =>  isSortDate ?  a['folderdate'].compareTo(b['folderdate']) : b['folderdate'].compareTo(a['folderdate']));
    isSortDate = !isSortDate;

  }
  void sortfolder(List folders, duplicatefolder) {
    //foldernames.sort((a, b) => isSortfolder ? a.compareTo(b.toString().toLowerCase()) : b.compareTo(a.toString().toLowerCase()));
    foldernames.sort((a, b) => isSortfolder ? a['foldername'].toString().toLowerCase().compareTo(b['foldername'].toString().toLowerCase()) : b['foldername'].toString().toLowerCase().compareTo(a['foldername'].toString().toLowerCase()));
    duplicatefoldernames.sort((a, b) => isSortfolder ? a['foldername'].toString().toLowerCase().compareTo(b['foldername'].toString().toLowerCase()) : b['foldername'].toString().toLowerCase().compareTo(a['foldername'].toString().toLowerCase()));
    isSortfolder = !isSortfolder;

  }


  @override


  Widget build(BuildContext context) {
    List<Widget> _buttons = List();
    if (_selectionMode) {
      _buttons.add(
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _selectedIndexList.sort((b, a) => a.compareTo(b));
                print('Going to delete ${_selectedIndexList.length} items! Item index: ${_selectedIndexList.toString()}');
                //for(int i = 0; i < _selectedIndexList.length; i++){
                for(int i = 0; i < _selectedIndexList.length; i++){
                  var dirdelete = foldernames.elementAt(_selectedIndexList[i])["foldername"];
                  AppUtil.deletefolderInAppDocDir(dirdelete);
                  foldernames.removeAt(_selectedIndexList[i]);
                  duplicatefoldernames.clear();
                  duplicatefoldernames.addAll(foldernames);
                }
                _changeSelection(enable: false, index: -1);
                print('Number of items in selected list: ${_selectedIndexList.length} items!');
                print(foldernames);
              });

            }),

      );
      _buttons.add(
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            print('Sharings');
            ShowFolderOptions(context);
          },
        ),
      );
      _buttons.add(
        FlatButton(
            child:Text('Cancel'),
            onPressed: () {
              setState(() {
                //_selectedIndexList.clear();
                //_changeSelection(enable: false, index: -1);
                _selectionMode =false;
                _selectedIndexList.clear();
              });
              //Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));

            }),

      );
      /*_buttons.add(
        FlatButton(
            child:Text('Cancel'),
            onPressed: () {
              setState(() {
                SelectionList._selectedIndexList.clear();
                SelectionList._changeSelection(index: -1);
                _selectionMode =false;

                print("Selection list after cancel =${SelectionList._selectedIndexList}");
              });
              //Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));

            }),

      );*/
    }
    else{
      _buttons.add(
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
          onPressed: () {
            _showChoiceDialogForSort(context);
            print('Sorted');

          },
        ),);
      _buttons.add(
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _showChoiceDialog(context);
          },
        ),
      );

    }

    // TODO: implement build
    return new Scaffold(

        appBar: new AppBar(
          title: Text(_selectedIndexList.length < 1
              ? "My Gallery"
              : "${_selectedIndexList.length} item selected"),
          actions: _buttons,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()  async {
            createAlertDialog(context).then((onValue) async {
              print('OnnnnnValuee = $onValue');
              if(onValue != null && onValue.isNotEmpty){
                print('foldernames.length = ${foldernames.length}');

                  if(foldernames.length == 0)
                    {
                      AppUtil.createFolderInAppDocDir(onValue);
                      appendfoldernames(onValue);
                    }
                  else{
                    for (int j = 0; j < foldernames.length; j++){
                      if(foldernames[j]["foldername"] == onValue){
                        print('This foldername exsits');
                        FolderExistdialog(context,"Foldername Exist","Please try another Folder Name");
                        setState(() {
                          _checker = true;
                        });
                      }
                    }
                    if(!_checker){
                      AppUtil.createFolderInAppDocDir(onValue);
                      appendfoldernames(onValue);
                      //appendfolderdates();


                      print("Current foldernames has: $foldernames");
                      //addFolder(onValue);
                    }
                    else{
                      setState(() {
                        _checker = false;
                      });
                    }
                  }


              }

              if(onValue?.isEmpty?? false){
                FolderExistdialog(context,'Folder Name not given', 'Please enter a Folder Name to create new folder');
                print('No Foldername given, Folder not created');
                print(foldernames);
                return ;
              }


            });
            //addFolder( await AppUtil.createFolderInAppDocDir(num.toString()));

          },
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text("New Folder"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.amberAccent,
        ),
        body: /*Container(
          child: DraggableScrollbar.semicircle(
            controller: _controller,
            child:  _createBody(),

          ),
        )*/


      SingleChildScrollView(
          child: Container(
              child:Column(
                children: <Widget>[
                  SearchFolder(context),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(Tick != false? 'No folders found':'  Number of Folders = ${foldernames.length} ',style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                      )

                  ),
                  DraggableScrollbar.semicircle(
                    controller: _controller,
                    child: _createBody(),
                  )
                  /*GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: folders,
                  ),*/

                ],
              )
          ),
        )

    );
  }
  Future <void> FolderExistdialog(BuildContext context, title,content){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions:[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.keyboard_return),
                  Text('Back')
                ],
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ]
      );
    },
    );
  }
  Future <void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Settings'),
        contentPadding: EdgeInsets.only(top: 12.0),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  print('Logging out');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.lock_outline),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Log Out',style: TextStyle(fontSize: 20.0)),

                  ],
                ),

              ),

              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                onTap: (){
                  print('detected');
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          FormScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.contact_mail),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Contact Us',style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                onTap: ()async{
                  writeOnPdf(foldernames,Tempmaps)
                  //savePdf()
                      .then((value){
                    print('Path passed: $value');
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PdfPreviewScreen(value)
                    ));
                  });

                  //Directory documentDirectory = await getApplicationDocumentsDirectory();

                  //String documentPath = documentDirectory.path;

                  //String fullPath = "$documentPath/example.pdf";


                  print('PDF pressed');

                 /* Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MyApp()
                  ));*/

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.picture_as_pdf),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Generate PDF',style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),),
            ],
          ),
        ),
      );
    },
    );
  }

  Future writeOnPdf(foldernames,Tempmaps) async{

    /*PdfImage logoImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: AssetImage('assets/Capture1.PNG'),
    );
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(logoImage),
            ); // Center
          }

      ),
    );*/
    /*PdfImageassetImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image:  AssetImage('assets/Capture1.PNG'),
    );*/

    /*for(int i = 0; i < 5; i++)
    {
      items.add(
        pw.Row(
            children: [
              pw.Paragraph(
                text: "Relatório de Visita:",
              ),
              pw.Paragraph(
                text: "Relatório de Visita:",
              ),
              pw.Paragraph(
                text: "Relatório de Visita:",
              ),

            ]
        ),
      );
      print("Items inside = $items");
    }*/



    /*pdf.addPage(pw.MultiPage(
        build: (pw.Context context) {
          return Wrap(
            children: List<Widget>.generate(
              exteriorImgNotifier.exteriorImgList.length,
                  (int n) {
                var imag = PdfImage.file(
                  pdf.document,
                  bytes: File(exteriorImgNotifier
                      .exteriorImgList[i].imagesfloor.path)
                      .readAsBytesSync(),
                );

                return pw.Container(
                    height: 200, width: 200, child: pw.Image(imag));
              },
            ),
          )
          ,
        }
        ));*/

    pw.Widget getphotos(BuildContext context, mapsname,image) {

      return pw.Row(
        children: <pw.Widget>[
            pw.Container(
                child: pw.Column(
                children: <pw.Widget>[
                  //height: 150,width: 130,fit:pw.BoxFit.fill
                    pw.Image(image,height: 100,width: 90,fit:pw.BoxFit.fill),
                    pw.Text("$mapsname",style: pw.TextStyle(fontSize: 20))]
                       )),

        ]

      );
    }
    for(int i =0; i<Tempmaps.length;i++){
      PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: AssetImage('${Tempmaps[i]['imagepath']}'));
      //PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: AssetImage('assets/Capture3.PNG'));
      //var imageProvider =  AssetImage('assets/Capture3.PNG');
      //PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: imageProvider);

      setState(() {

        photo = List.from(photo)..add(getphotos(context,Tempmaps[i]['name'],image));
      });
      print("num of photo now =  ${photo.length}");

    }
    pw.Widget getfolderset(BuildContext context,folderdename,maps) {
      return pw.Container(
        child: pw.Column(
            children: <pw.Widget>[
              pw.Text("$folderdename",style: pw.TextStyle(fontSize: 30, decoration: pw.TextDecoration.underline, )),
              pw.GridView(
                crossAxisCount: 4,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio:1.3 ,
                children: photo

              ),
              /*pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),

                  ]
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),

                  ]
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),
                    pw.Column(
                        children: <pw.Widget>[
                          pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                          pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                        ]
                    ),

                  ]
              )*/


              //child: pw.Image(image),
              //pw.Text("TESTTTT",style: pw.TextStyle(fontSize: 40)),
            ]//10.17pm working
        ),


      );
    }
    for(int i =0; i<foldernames.length;i++){
      //var imageProvider =  AssetImage('assets/Capture3.PNG');
      //PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: imageProvider);

        setState(() {
          items = List.from(items)..add(getfolderset(context,foldernames[i]["foldername"],Tempmaps));
        });
        print("num of items now =  ${items.length}");

    }
   /* for(int i =0; i<Tempmaps.length;i++){
      PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: AssetImage('${Tempmaps[i]['imagepath']}'));
      images = List.from(images)..add(image);
      print('Images = $images');

    }*/
   // PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: AssetImage('${Tempmaps[i]['imagepath']}'));


    /*for(int i = 0; i < foldernames.length; i++)
      //foldernames.length
        {
      setState(() {
        items = List.from(items)..add(getfolderset(context,foldernames[i]["foldername"]));
      });
      print('items = $items');
      for(int j = 0; j < Tempmaps.length; j++)
        //foldernames.length
          {
           if(Tempmaps[j]["foldername"]==foldernames[i]["foldername"]) {
             var imageProvider =  AssetImage(Tempmaps[i]['imagepath']);
             PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: imageProvider);
             print('Tempmaps here = $Tempmaps');
             setState(() {
               photo = List.from(photo)..add(getphotos(context,Tempmaps[j]['name'],image));
             });
             print('photo = $photo');
           }
      }
    }*/


    pdf.addPage(pw.MultiPage(
        build: (context) => items));
    /*Directory downloadsDirectory;
    try {
      Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');   }


    if (!mounted) return;

    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });
  }*/
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
   // String downloaddocumentPath = downloadsDirectory.path;
    print("Path PDF: $documentPath");
   // print("downloaddocumentPath PDF: $downloaddocumentPath");
    print("File is going to created");
    final file = await File("${documentPath}/example.pdf").create(recursive:true);
    print("File created, going to save");
    file.writeAsBytesSync(pdf.save());
    print("File saved");
    String fullPath = "$documentPath/example.pdf";
    bool check = await File(fullPath).exists();
    if(check){
      print('Fullpath exist= $fullPath');
    }
    else{
      print('Cannot find pdf');
    }
    return fullPath;
    /*pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Wrap(
              children: <pw.Widget>[
            pw.Column(
                children: <pw.Widget>[
                 pw.Text("${foldernames[0]['foldername']}",style: pw.TextStyle(fontSize: 30, decoration: pw.TextDecoration.underline, )),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Column(
                          children: <pw.Widget>[
                            pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                            pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                          ]
                      ),
                      pw.Column(
                          children: <pw.Widget>[
                            pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                            pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                          ]
                      ),
                      pw.Column(
                          children: <pw.Widget>[
                            pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                            pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                          ]
                      ),
                      pw.Column(
                          children: <pw.Widget>[
                            pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                            pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                          ]
                      ),

                    ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: <pw.Widget>[
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),

                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: <pw.Widget>[
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),
                        pw.Column(
                            children: <pw.Widget>[
                              pw.Image(image,height: 150,width: 130,fit:pw.BoxFit.fill),
                              pw.Text("Photoname",style: pw.TextStyle(fontSize: 20))
                            ]
                        ),

                      ]
                  )


            //child: pw.Image(image),
            //pw.Text("TESTTTT",style: pw.TextStyle(fontSize: 40)),
            ]//10.17pm working
          ),

                ]
          ); // Center
        }));*/ /////
    //const imageProvider2 = const AssetImage('assets/Capture2.PNG');
    //final PdfImage image2 = await pdfImageFromImageProvider(pdf: pdf.document, image: imageProvider2);
    /*pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: <pw.Widget>[
              pw.Text("Image 1",style:pw.TextStyle(fontSize:40)),
              pw.Image(image),
              //pw.Text("Image 2",style:pw.TextStyle(fontSize:40)),
              //pw.Image(image2),
            ]
          ); // Center
        }));*/ // Page// Page
    /*pdf.addPage(pw.MultiPage(
        build: (pw.Context context) {
          return <pw.Widget>  [
            pw.Center(
              child: pw.Container(
                  child: pw.Text("TESTTTT",style: pw.TextStyle(fontSize: 40)),
          )
            )
          ]; // Center
        }));*/
    /*pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a5,
          margin: pw.EdgeInsets.all(32),

          build: (pw.Context context){
            return <pw.Widget>  [
              pw.Header(
                  level: 0,
                  child: pw.Text("Foldername")
              ),


              pw.Paragraph(
                  text: "Photoname"
              ),

              pw.Header(
                  level: 1,
                  child: pw.Text("Foldername")
              ),

              pw.Paragraph(
                  text: "Photoname"
              ),
              pw.Header(
                  level: 1,
                  child: pw.Text("Foldername")
              ),

              pw.Paragraph(
                  text: "Photoname"
              ),

            ];
          },


        )
    );*/
  }

  Future savePdf() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    Directory TempdocumentDirectory = await getTemporaryDirectory();
    final Externaldirectory = (await getExternalStorageDirectory()).path;
    print("Tempdocument directory = ${TempdocumentDirectory.path}");
    print("Externaldirectory = $Externaldirectory");
    String documentPath = documentDirectory.path;
    print("Path PDF: $documentPath");
    print("File is going to created");
    final file = await File("${documentPath}/example.pdf").create(recursive:true);
    //File file = await File('/storage/emulated/0/Documents/example.pdf').create();
    print("File created, going to save");
    //file.createSync();
    file.writeAsBytesSync(pdf.save());
    print("File saved");
    String fullPath = "$documentPath/example.pdf";
    bool check = await File(fullPath).exists();
    if(check){
      print('Fullpath exist= $fullPath');
    }
    else{
      print('Cannot find pdf');
    }
    return fullPath;
  }

  Future <void> _showChoiceDialogForSort(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Sort By'),
        contentPadding: EdgeInsets.only(top: 12.0),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  sortfolder(foldernames,duplicatefoldernames);
                  setState(() {
                    foldernames = foldernames;
                  });
                  print('Sorted by name');
                  Navigator.pop(context);

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),

                    Icon(isSortfolder != true? Icons.arrow_upward : Icons.arrow_downward),
                    Icon(Icons.sort_by_alpha),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Name',style: TextStyle(fontSize: 20.0)),

                  ],
                ),

              ),

              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                onTap: (){
                  print('Sorted by Date');
                  sortdate(foldernames,duplicatefoldernames);
                  setState(() {
                    foldernames = foldernames;
                    duplicatefoldernames =duplicatefoldernames;
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 10.0,
                    ),
                    Icon(isSortDate != true? Icons.arrow_upward : Icons.arrow_downward),
                    Icon(Icons.date_range),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Text('Date',style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),),
            ],
          ),
        ),
      );
    },
    );
  }

  void filterSearchResults(String text) {
    List<Map> dummySearchList = List<Map>();
    dummySearchList.addAll(duplicatefoldernames);
    //List<String> dummySearchList = List<String>();
    //dummySearchList.addAll(duplicatefoldernames);
    if(text.isNotEmpty && text.length > 0) {
      List<Map> dummyListData = List<Map>();
      for(int i=0; i<duplicatefoldernames.length; i++){
        if(duplicatefoldernames[i]["foldername"].toLowerCase().contains(text.toLowerCase()) ||
            duplicatefoldernames[i]["foldername"].contains(text.toLowerCase())) {
          dummyListData.add(duplicatefoldernames[i]);

        }
      };
      //List<String> dummyListData = List<String>();
      /*dummySearchList.forEach((item) {
        if(item.toLowerCase().contains(text.toLowerCase()) || item.contains(text.toLowerCase())) {
          dummyListData.add(item);

        }


      });*/
      setState(() {
        foldernames.clear();
        foldernames.addAll(dummyListData);
        if(dummyListData.length > 0){
          Tick = false;
        }
        else{
          Tick = true;
        }
      });

      return;
    }
    else {
      Tick = false;
      setState(() {
        foldernames.clear();
        foldernames.addAll(duplicatefoldernames);
      });
    }
  }
  Widget SearchFolder(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(left: 10, right: 10,top: 20),
      child: TextField(
        onChanged:(text){
          filterSearchResults(text);
          print('Current on change text is $text');
        },
        decoration: InputDecoration(
            hintText: "Search Folder",
            border: InputBorder.none,
            fillColor: Colors.grey,
            icon: Icon(Icons.search)
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )
      ),
    );
  }
  Widget _createBody() {
    return StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: foldernames.length,
        itemBuilder: (BuildContext context, int index) {
          return getGridTile(index);
        },
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
        padding: const EdgeInsets.all(4.0),
      );

  }
  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }
  GridTile getGridTile(int index) {
    if (_selectionMode){
      return GridTile(
          child: Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[

                    Container(
                      child: GestureDetector(
                        onLongPress: (){
                          //widget.customFunction(false);
                          setState(() {
                            _changeSelection(enable: false, index: -1);
                            print("Selection list after cancel =${_selectedIndexList}");
                          });
                          print("long press detected");
                        },
                        onTap: (){
                          print("pressed");
                          setState(() {
                            if (_selectedIndexList.contains(index)) {
                              _selectedIndexList.remove(index);
                            } else {
                              _selectedIndexList.add(index);
                            }
                            print(_selectedIndexList);
                          });
                        },

                        child: Container(
                          child: new Card(
                            elevation: 10.0,
                            child: new Column(

                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new SizedBox(
                                  height: 5.0,
                                ),
                                new Image.asset("assets/Capture01.PNG",
                                    height: 90.0, width: 100.0,fit: BoxFit.cover),
                                new SizedBox(
                                  height: 5.0,
                                ),
                                new Text(foldernames[index]['foldername'].toString().isNotEmpty? foldernames[index]['foldername']: 'Foldername', style: TextStyle(fontSize: 15.0),),


                              ],
                            ),
                          ),
                        ),
                      ),


                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                        color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                )

              ]
          )
      );
    }
    else{
      return GridTile(
          child: Wrap(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onLongPress: (){
                      setState(() {
                        _changeSelection(enable: true, index: index);
                      });
                      print("long press detected");
                    },
                    onTap: (){

                      print("pressed");
                      print("foldernames map list got = ${foldernames}");
                      print("Current index = $index");
                      //Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription(widget.folderName)));
                     /*Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              MainPage(foldernames,index)));*/
                      Navigator.push(context,
                        new MaterialPageRoute(builder: (context) =>MainPage(foldernames, index)),
                      )
                          .then((value) {
                            //now it returns as combine map and can split into two
                        //smaller map but the maps return is only that folder de maps
                        //need to find a way to combine all maps sot that pdf can generate
                        //or maybe do a map just for folder and maps
                        //maybe can try all foldername in maps add another key-value pair
                        //save to directory in file manager
                            //print('Recieved value = $value');
                            //print('value length = ${value.length}');
                            Tempfolder.clear();
                            Tempmaps.clear();
                            for(int i =0; i<duplicatefoldernames.length;i++){

                              Tempfolder.add(value[i]);
                            }
                            for(int i =duplicatefoldernames.length; i<value.length;i++){

                              Tempmaps.add(value[i]);
                            }

                        setState(() {
                          foldernames = Tempfolder;
                          Tempmaps = Tempmaps;
                         // print('foldernamesnoww =$foldernames');
                         // print('foldernamesnoww =$foldernames');
                         // print('Tempmapsnoww =$Tempmaps');
                         // print('foldernamesnoww =$foldernames');

                        });
                      });
                      //Navigator.push(context, MaterialPageRoute(
                         // builder: (context) =>  new MainPage(foldernames, index)));

                    },

                    child: Container(
                      child: new Card(
                        elevation: 10.0,
                        child: new Column(

                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 5.0,
                            ),
                            new Image.asset("assets/Capture01.PNG",
                                height: 90.0, width: 100.0,fit: BoxFit.cover),
                            new SizedBox(
                              height: 5.0,
                            ),
                            new Text(foldernames[index]['foldername'].toString().isNotEmpty? foldernames[index]['foldername']: 'Foldername', style: TextStyle(fontSize: 15.0),),


                          ],
                        ),
                      ),
                    ),
                  ),


                ),

              ]
          )
      );
    }

  }


}
/*class ShowFolder extends StatefulWidget {
  String folderName;
  final customFunction;
  ShowFolder(this.folderName, {this.customFunction});
  @override
  _ShowFolderState createState() => _ShowFolderState();
}

class SelectionList {
  SelectionList._();
  static var _selectedIndexList = [];
  /*static void _changeSelection({int index}) {

    SelectionList._selectedIndexList.add(index);
    if (index == -1) {
      SelectionList._selectedIndexList.clear();
    }
  }*/


}
class _ShowFolderState extends State<ShowFolder>{
  @override
  //int index = 0;
  bool _FselectionMode = false;

  Widget build(BuildContext context) {
    if (_FselectionMode){
      return Container(
          child: Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[

                    Container(
                      child: GestureDetector(
                        onLongPress: (){
                          widget.customFunction(false);
                          setState(() {
                            _FselectionMode = false;
                            SelectionList._selectedIndexList.clear();
                            //SelectionList._changeSelection(index: 0);
                            print("Selection list after cancel =${SelectionList._selectedIndexList}");
                          });
                          print("long press detected");
                        },
                        onTap: (){
                          print("pressed");
                          //Navigator.push(context,
                          // MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription(widget.folderName)));
                          //Navigator.of(context).push(PageRouteBuilder(
                          //opaque: false,
                          //pageBuilder: (BuildContext context, _, __) =>
                          //    HorizontalScrollWithDescription(widget.folderName)));
                          setState(() {
                            if (SelectionList._selectedIndexList.contains(widget.folderName)) {
                              SelectionList._selectedIndexList.remove(widget.folderName);
                            } else {
                              SelectionList._selectedIndexList.add(widget.folderName);
                            }
                            print(SelectionList._selectedIndexList);
                          });
                        },

                        child: Container(
                          child: new Card(
                            elevation: 10.0,
                            child: new Column(

                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new SizedBox(
                                  height: 5.0,
                                ),
                                new Image.asset("assets/Capture01.PNG",
                                    height: 100.0, width: 100.0,fit: BoxFit.cover),
                                new SizedBox(
                                  height: 5.0,
                                ),
                                new Text(widget.folderName != null? widget.folderName: 'Foldername', style: TextStyle(fontSize: 15.0),),


                              ],
                            ),
                          ),
                        ),
                      ),


                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        SelectionList._selectedIndexList.contains(widget.folderName) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                        color: SelectionList._selectedIndexList.contains(widget.folderName) ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                )

              ]
          )
      );
    }
    else{
      return Container(
          child: Wrap(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onLongPress: (){
                      widget.customFunction(true);
                      setState(() {
                        _FselectionMode = true;
                        //SelectionList._changeSelection(index: index);
                      });
                      print("long press detected");
                    },
                    onTap: (){
                      print("pressed");
                      //Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => HorizontalScrollWithDescription(widget.folderName)));
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              HorizontalScrollWithDescription(widget.folderName)));
                    },

                    child: Container(
                      child: new Card(
                        elevation: 10.0,
                        child: new Column(

                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 5.0,
                            ),
                            new Image.asset("assets/Capture01.PNG",
                                height: 100.0, width: 100.0,fit: BoxFit.cover),
                            new SizedBox(
                              height: 5.0,
                            ),
                            new Text(widget.folderName, style: TextStyle(fontSize: 15.0),),


                          ],
                        ),
                      ),
                    ),
                  ),


                ),

              ]
          )
      );
    }
  }
}*/



void ShowFolderOptions(BuildContext context) async{
  final items = <MultiSelectDialogItem<int>>[
    MultiSelectDialogItem(1, 'Name'),
    MultiSelectDialogItem(2, 'Date'),
    MultiSelectDialogItem(3, 'Description'),
    MultiSelectDialogItem(4, 'Link'),
  ];

  final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context){
        return MultiSelectDialog(
          items: items,
          //initialSelectedValues: [1].toSet(),
        );
      }
  );
}
class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sharing Options'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}


void ShowSortOptions(BuildContext context) async{
  final items = <MultiSelectDialogSortItem<int>>[
    MultiSelectDialogSortItem(1, 'Name'),
    MultiSelectDialogSortItem(2, 'Date'),

  ];

  final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context){
        return MultiSelectDialogSort(
          items: items,
          //initialSelectedValues: [1].toSet(),
        );
      }
  );
}
class MultiSelectDialogSortItem<V> {
  const MultiSelectDialogSortItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialogSort<V> extends StatefulWidget {
  MultiSelectDialogSort({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogSortItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogStateSort<V>();
}

class _MultiSelectDialogStateSort<V> extends State<MultiSelectDialogSort<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('Sort By'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogSortItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

class AppUtil{
  static Future<void> createFolderInAppDocDir(String folderName) async {
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');

    if(await _appDocDirFolder.exists()){
      print("Already Created Folder in: $_appDocDirFolder");
      return null;
    }
    else{
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive:true);
      print("Created new folder: $_appDocDirFolder");
      //return ShowFolder(folderName, customFunction: parentChange);
    }
  }
  static Future<void> deletefolderInAppDocDir(String folderName) async{
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');
    if(await _appDocDirFolder.exists()){
      final Directory _appDocDirNewFolder = await _appDocDirFolder.delete(recursive:true);
      print("Deleted Folder $folderName in: $_appDocDirFolder");
      //return ShowFolder(folderName);;
    }
    else{
      print("Folder does not exist ");
      return null;
    }
  }
}

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String _name;
  String _email;
  String _message;
  String _subject;
  String _phoneNumber;



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> send() async {
       final Email email = Email(
      body: '\nName: $_name'+'\nEmail: $_email'+'\nPhone Number: $_phoneNumber' +'\n\n$_message',
      subject: _subject,
      recipients: ['dannybkkhoo@gmail.com'],
      //attachmentPaths: attachments,
      //isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
    _Thankyoudialog(context);
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength:  20,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildMessage() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Message'),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Write us a message';
        }

        return null;
      },
      onSaved: (String value) {
        _message = value;
      },
    );
  }

  Widget _buildSubject() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Subject'),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Subject is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _subject = value;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone Number'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _phoneNumber = value;
      },
    );
  }
  Future <void> _Thankyoudialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
          title: Text("Contact Us"),
          content: Text("Thank you for your feedback, your will be contacted shortly."),
          actions:[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.keyboard_return),
                  Text('Back')
                ],
              ),
              onPressed: (){
                Navigator.of(context)
                    .popUntil(ModalRoute.withName("/Page1"));
              },
            ),
          ]
      );
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Contact Us")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildEmail(),
                _buildPhoneNumber(),
                _buildSubject(),
                _buildMessage(),

                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: ()  {

                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        print(_name);
                        print(_email);
                        print(_phoneNumber);
                        print(_subject);
                        print(_message);
                        send();

                        //Send to API
                      },
                    ),
                    RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.keyboard_return),
                          Text('Back')
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen(this.path);

  @override
  /*Widget build(BuildContext context) {
    //PDFViewerScaffold
    return PDFView(
          filePath: path,
        );


  }*/
 /* Widget build(BuildContext context) {
    return Scaffold(
      body:PDFView(
        filePath: path,
      )
    );
  }*/
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),

      ),

        path:path

    );

  }
}