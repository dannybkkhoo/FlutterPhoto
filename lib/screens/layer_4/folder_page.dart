import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../services/authentication/authenticator.dart';
import '../../services/authentication/authprovider.dart';
import '../../services/cloud_storage/cloud_storage.dart';
import '../../services/cloud_storage/image_storage.dart';
import '../../services/local_storage/dataprovider.dart';
import '../../services/local_storage/userdata.dart';
import '../../services/utils.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MainPageFolder extends StatefulWidget {
  final String title;
  final VoidCallback onSignedOut;
  MainPageFolder({this.title, this.onSignedOut}) : super();

  @override
  State<StatefulWidget> createState() => MainPageFolderState();
}
class MainPageFolderState extends State<MainPageFolder> {
  String _uid;
  UserData _userData;
  Future<UserData> _receivedData;

  Stream<List<ShowFolder>> _generateFolders(List folders) async* {
    print("Generating folders...");
    List<ShowFolder> showfolders = [];
    for(Map folder in folders){  //forEach cant be used as it does not await
      showfolders.add(ShowFolder(folder["folder_id"]));
      yield showfolders;
    }
  }
  Future<UserData> _loadUserData() async {
    debugPrint("Getting UID...");
    _uid = await AuthProvider.of(context).auth.getUID();
    debugPrint("Loading User Data...");
    _userData = DataProvider.of(context).userData;
    return _userData;
  }
  void _refresh() async{
    UserData data = await _loadUserData();
    setState(() {
      _userData = data;
    });
  }

  final pdf = pw.Document();
  List<pw.Widget> items = new List<pw.Widget>();
  List<pw.Widget> photo = new List<pw.Widget>();
  List<PdfImage> images = new List<PdfImage>();
  Directory _downloadsDirectory;

  Future writeOnPdf() async{
    pw.Widget getphotos(BuildContext context, String image_name, PdfImage image_file) {
      return pw.Row(
        children: <pw.Widget>[
          pw.Container(
            child: pw.Column(
              children: <pw.Widget>[
                pw.Image(image_file,height: 100,width: 90,fit:pw.BoxFit.fill),
                pw.Text("$image_name",style: pw.TextStyle(fontSize: 20))
              ]
            )),
        ]
      );
    }
    pw.Widget getfolderset(BuildContext context,String folder_name) {
      return pw.Container(
        child: pw.Column(
            children: <pw.Widget>[
              pw.Text("$folder_name",style: pw.TextStyle(fontSize: 30, decoration: pw.TextDecoration.underline)),
              pw.GridView(
                  crossAxisCount: 4,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  childAspectRatio:1.3 ,
                  children: photo
              ),
            ]//10.17pm working
        ),
      );
    }
    UserData _Data = DataProvider.of(context).userData;
    var _folders = _Data.folders;
    final uidpart = _uid.substring(0,3);
    List<String> folder_names = [];
    for(Map folder in _folders){
      folder_names.add(folder["name"]);
      items.add(getfolderset(context,folder["name"]));
      if(folder["children"].isNotEmpty){
        for(Map image in folder["children"]){
          String path = "/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg";
          PdfImage pdfimage = await pdfImageFromImageProvider(pdf: pdf.document, image: FileImage(File(path)));
          photo.add(getphotos(context,image["name"],pdfimage));
          print(".");
        }
      }
    }
    print("Adding page");
    pdf.addPage(pw.MultiPage(build: (context) => items));
    print("HMM");
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;//_downloadsDirectory.path;
    print("Path PDF: $documentPath");
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
  Future <void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Settings'),
        contentPadding: EdgeInsets.only(top: 12.0),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: ()async{
                  writeOnPdf()
                      .then((value){
                    print('Path passed: $value');
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PdfPreviewScreen(value)
                    ));
                  });
                  print('PDF pressed');
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
            ],
          ),
        ),
      );
    },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _receivedData = _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _receivedData,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(()=>print("Loading..."));
            break;
          case ConnectionState.done:
            return StreamBuilder<List<ShowFolder>>(
              stream: _generateFolders(_userData.folders),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return sizedWaitingScreen();
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasData && snapshot.data.isNotEmpty) {
                        return FolderArea(snapshot.data);
                      }
                      else {
                        return Scaffold(
                          body: Center(
                              child: Text("No Folders...",style: TextStyle(fontSize:24.0),)
                          )
                        );
                      }
                      break;
                    default:
                      if(snapshot.hasError) {
                        print(snapshot.error);
                        return sizedErrorScreen(_refresh,errorText: snapshot.error);
                      }
                      else {
                        return sizedWaitingScreen(waitingWidget: Text("No Data...", style: TextStyle(fontSize:24.0)));
                      }
                  }
                }
            );
            break;
          default:
            return ErrorScreen(()=>print("Error!"));
        }
      }
    );
  }
}

class FolderArea extends StatefulWidget{
  final List<ShowFolder> folders;
  FolderArea(this.folders);

  @override
  _FolderAreaState createState() => _FolderAreaState();
}
class _FolderAreaState extends State<FolderArea>{
  final _searchTextController = TextEditingController();
  int _searchFolderLength = 0;
  bool _selectionMode = false;
  bool _isSearching = false;
  List<int> _selectedIndexList = List();
  List<Widget> _buttons = List();
  List<ShowFolder> _filteredShowfolders = List();
  List<ShowFolder> _displayedShowfolders = List();
  ImageStorage imageStorage = ImageStorage();

  List<Widget> _buttonList(){
    _buttons = [];
    if (_selectionMode) {
      _buttons.add(
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
              });
            }),
      );
      _buttons.add(
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            print('Sharings');
            //ShowFolderOptions(context);
          },
        ),
      );
      _buttons.add(
        FlatButton(
            child:Text('Cancel', style: TextStyle(color: Colors.white),),
            onPressed: () {
              setState(() {
                _selectionMode = false;
                _selectedIndexList.clear();
              });
            }),
      );
    }
    else{
      if(_isSearching){
        _buttons.add(
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                this._isSearching = false;
              });
            },
          ),
        );
      }
      else{
        _buttons.add(
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async{
            },
          ),);
        _buttons.add(
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              filterSearchResults("");
              setState(() {
                _isSearching = true;
              });
            },
          ),);
        _buttons.add(
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              //_showChoiceDialogForSort(context);
              print('Sorted');
            },
          ),);
        _buttons.add(
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //_showChoiceDialog(context);
              print("Nothing");
            },
          ),
        );
      }
    }
    return _buttons;
  }

  void filterSearchResults(String text) {
    int searchFolderLength = 0;
    final userData = DataProvider.of(context).userData;
    final folderList = userData.folder_list;
    List<ShowFolder> originalShowfolders = List.from(widget.folders);
    List<ShowFolder> filteredShowfolders = List();
    if(text.isNotEmpty && text.length > 0){
      List wantedIDList = folderList.keys.where((folder_id){
        return(folderList[folder_id].contains(RegExp(text,caseSensitive: false)));
      }).toList();

      print("wanted");
      print(wantedIDList);

      filteredShowfolders = originalShowfolders.where((folder){
        return(wantedIDList.contains(folder.folder_id));
      }).toList();

      print("folder");
      print(filteredShowfolders);

      // for(String folder_id in folderList.keys){
      //   String folder_name = folderList[folder_id];
      //   if(folder_name.contains(RegExp(text,caseSensitive: false))){
      //     for(var folder in originalShowfolders){
      //       if(folder.folder_id == folder_id) {
      //         filteredShowfolders.add(folder);
      //       }
      //     }
      //   }
      // };
    }
    if(text.isNotEmpty && text.length > 0){ //if user is searching
      if(filteredShowfolders.isNotEmpty){  //if filtered folder is found
        searchFolderLength = filteredShowfolders.length;
      }
      else{ //if no filtered folder is found
        searchFolderLength = 1;
      }
    }
    else{ //if user havent typed in anything
      searchFolderLength = _displayedShowfolders.length;
    }
    print(filteredShowfolders);
    setState(() {
      _filteredShowfolders = List.from(filteredShowfolders);
      _searchFolderLength = searchFolderLength;
    });
  }
  Widget _appbarTitle(){
    if(_selectionMode){
      return Text("${_selectedIndexList.length} item selected");
    }
    else if(!_selectionMode){
      if(_isSearching){
        return TextField(
          controller: _searchTextController,
          onChanged: (String text) {
            filterSearchResults(text);
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search Folder",
            hintStyle: TextStyle(color: Colors.white)),
        );
      }
      else {
        return Text("My Gallery");
      }
    }
  }
  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }
  GridTile _getGridTile(int index, List<ShowFolder> folders){
    if(_selectionMode){
      return GridTile(
        header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
            )
        ),
        child: GestureDetector(
          onLongPress: () {
            setState((){
              _changeSelection(enable: false, index: -1);
            });
            print("Selection list after cancel =${_selectedIndexList}");
            print("long press detected");
          },
          onTap: () {
            setState(() {
              if(_selectedIndexList.contains(index))
                _selectedIndexList.remove(index);
              else
                _selectedIndexList.add(index);
              print(_selectedIndexList);
            });
          },
          child: folders[index],
        )
      );
    }
    else if(_isSearching){  //if user is searching
      if(_searchTextController.text.isNotEmpty && _searchTextController.text.length > 0) { //if user is searching
        if(_filteredShowfolders.isNotEmpty) { //if filtered folder is found
          return GridTile(
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    _changeSelection(enable: true, index: index);
                  });
                  print("long press detected");
                },
                onTap:() {
                  Navigator.popAndPushNamed(context,File_Page,arguments: {'folder_id':_filteredShowfolders[index].folder_id});
                },
                child: _filteredShowfolders[index],
              )
          );
        }
        else{ //if no filtered folder is found
          return GridTile(
              child: GestureDetector(
                child: Text("No results..."),
              )
          );
        }
      }
      else {  //user has not typed in folder name yet, or if at least 1 folder found
        return GridTile(
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  _changeSelection(enable: true, index: index);
                });
                print("long press detected");
              },
              onTap:() {
                Navigator.popAndPushNamed(context,File_Page,arguments: {'folder_id':folders[index].folder_id});
              },
              child: folders[index],
            )
        );
      }
    }
    else{
      return GridTile(
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
            print("long press detected");
          },
          onTap:() {
            Navigator.popAndPushNamed(context,File_Page,arguments: {'folder_id':folders[index].folder_id});
          },
          child: folders[index],
        )
      );
    }
  }
  Widget _createBody(List<ShowFolder> folders){
    return StaggeredGridView.countBuilder(
      key: UniqueKey(),
      crossAxisCount: 3,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      itemCount: _isSearching?_searchFolderLength:_displayedShowfolders.length,
      itemBuilder: (BuildContext context, int index){
        return AspectRatio(aspectRatio: (2/3),child:_getGridTile(index, folders));
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1,1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  @override
  void initState() {
    super.initState();
    _displayedShowfolders = List.of(widget.folders);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _appbarTitle(),
        actions: _buttonList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await imageStorage.AddFolder(context);
          setState(() {});
        },
        icon: Icon(Icons.add, color: Colors.black,),
        label: Text("New Folder"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _createBody(_displayedShowfolders),
          )
        ],
      )
    );
  }
}

class ShowFolder extends StatefulWidget {
  final String folder_id;
  ShowFolder(this.folder_id, {Key key}):super(key:key);

  @override
  _ShowFolderState createState() => _ShowFolderState();
}
class _ShowFolderState extends State<ShowFolder>{
  String _uid, _name, _appDocDir;
  List _children = [];
  Future<Map> _receivedData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _receivedData = _loadFolderData();
  }

  String getFolderName() {
    return _name;
  }
  Future<Map> _loadFolderData() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    _appDocDir = await getLocalPath();
    Map folder = getFolderData(_uid, widget.folder_id, context);
    return folder;
  }
  Widget FolderThumbnail(List children) { //finds the image on local device and display
    if(children.isNotEmpty){
      final file_path = _appDocDir + "/" + _uid + "/" + widget.folder_id;
      final image_filename = children[0]['image_id'];
      final uid = _uid.substring(0,3);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Image.file(File("$file_path/TMB_$uid$image_filename.jpg"),height: 100.0, width: 100.0,fit: BoxFit.contain),
          ),
          Wrap(
            children: [
              Text(_name, style: TextStyle(fontSize: 15.0),)
            ],
          )
        ],
      );
    }
    else{
      return NoImage(_name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _receivedData,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(()=>print("Issue"));
            break;
          case ConnectionState.done:
            _name = snapshot.data["name"];
            _children = snapshot.data["children"];
            return Container(
              alignment: Alignment.center,
              child: Wrap(
                children: <Widget>[
                  Container(
                    child: new Card(
                        elevation: 10.0,
                        child: Container(
                          child: FolderThumbnail(_children),
                        )
                    ),
                  )
                ]
              )
            );break;
          default:
            return sizedErrorScreen(null,errorText: snapshot.error);
        }
      },
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen(this.path);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("PDF Viewer"),
        ),
        path:path
    );

  }
}

/*Foldr Page----------------------------------------------------------------------------------------*/
class Foldr extends StatefulWidget {
  final String folder_id;
  Foldr(this.folder_id);

  @override
  _FoldrState createState() => _FoldrState();
}
class _FoldrState extends State<Foldr>{
  String _uid, _name, appDocDir, uidpart;
  List _children = [];
  Future<Map> onLoad() async {
    _uid = await AuthProvider.of(context).auth.getUID();
    Map folder = await getFolderData(_uid, widget.folder_id, context);
    return folder;
  }
  Stream<int> _downloadImages(List image_datas) async* {
    appDocDir = await getLocalPath();
    uidpart = _uid.substring(0,3);
    final length = image_datas.length;
    int index = 1;
    if(length != 0){
      print("Downloading images...");
      for(Map image in image_datas){
        print("[$index/$length] image id:${image["image_id"]}, image name:${image["name"]}");
        File img = File("/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg");
        Directory imgpath = Directory("/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg");
        File tmb = File("$appDocDir/$_uid/${widget.folder_id}/TMB_$uidpart${image["image_id"]}.jpg");
        if(await img.exists()){
          print("${image["name"]} exists.");
        }
        else {
          print("${image["name"]} does not exists.");
          await CloudStorage().getFileToGallery(_uid, image['image_id'], widget.folder_id);
          print("${image["name"]} successfully downloaded.");
        }
        if(await tmb.exists()){
          print("${image["name"]} thumbnail exists.");
        }
        else{
          print("${image["name"]} thumbnail does not exists.");
          await createLocalThumbnail(_uid,image['image_id'], widget.folder_id, img);
          print("${image["name"]} thumbnail successfully downloaded.");
        }
        index+=1;
        yield index;
      }
    }
    else{
      print("No images in file.");
      yield null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Map>(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return WaitingScreen(()=>print("Loading..."));break;
          case ConnectionState.done:
            _name = snapshot.data["name"];
            _children = snapshot.data["children"];
            print(_children);
            return StreamBuilder<int>(
                stream: _downloadImages(_children),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return sizedWaitingScreen();break;
                    case ConnectionState.active:
                      if(snapshot.data != null){
                        String image_id = _children[0]["image_id"];
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                  child: Image.file(File("$appDocDir/$_uid/${widget.folder_id}/TMB_$uidpart$image_id.jpg"),height: 100.0, width: 100.0,fit: BoxFit.cover),
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      else {
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height:100.0,
                                                    width:100.0,
                                                    padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                    child: Center(child: Text("No images..."))
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      break;
                    case ConnectionState.done:
                      if(snapshot.data != null){
                        String image_id = _children[0]["image_id"];
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                        //Navigator.pushNamed(context, FolderDescription_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                  child: Image.file(File("$appDocDir/$_uid/${widget.folder_id}/TMB_$uidpart$image_id.jpg"),height: 100.0, width: 100.0,fit: BoxFit.cover),
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      else {
                        return Container(
                            alignment: Alignment.center,
                            child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.popAndPushNamed(context, File_Page,arguments:{'folder_id':widget.folder_id});
                                      },
                                      child: Container(
                                        child: new Card(
                                            elevation: 10.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height:100.0,
                                                    width:100.0,
                                                    padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                    child: Center(child: Text("No images..."))
                                                ),
                                                Text(_name, style: TextStyle(fontSize: 15.0),)
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            )
                        );
                      }
                      break;
                    default:
                      return NoImage(_name);
                  }
                }
            );
          default:
            return sizedErrorScreen(null,errorText: snapshot.error);
        }
      },
    );
  }
}
/*End of Foldr Page---------------------------------------------------------------------------------*/