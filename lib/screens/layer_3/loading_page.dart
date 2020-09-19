import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../services/local_storage/dataprovider.dart';
import '../../services/local_storage/userdata.dart';
import '../../services/authentication/authenticator.dart';
import '../../services/authentication/authprovider.dart';
import '../../services/cloud_storage/cloud_storage.dart';
import '../../services/utils.dart';


class LoadingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoadingPageState();
}
class _LoadingPageState extends State<LoadingPage>{
  String _uid;
  UserData _userData;
  Future<UserData> _receivedData;
  Future<UserData> _retrieveUserData() async {
    const int maxRetry = 3;
    debugPrint("Getting UID...");
    for(int x = 1;x<maxRetry;x++) {
      _uid = await AuthProvider.of(context).auth.getUID();
      if(_uid != null){  //if UID successfully retrieved, continue next operation
        break;
      }
      else if(x<maxRetry){  //otherwise, retry getting UID for maxRetry times
        debugPrint("Failed to get UID, retrying...");
        await Future.delayed(Duration(seconds: 2)); //wait for 2 seconds and retry/continue get UID again
      }
      else{ //if UID still failed to get after maxRetry, operation cancelled, print error
        debugPrint("Failed to get UID after $maxRetry tries, please check for errors.");
        return null;  //ends the onLoad() function
      }
    }
    debugPrint("Retrieving User Data...");
    for(int x = 1;x<maxRetry;x++){
      _userData = await DataProvider.of(context).userData.loadLatestUserData(_uid);
      if(_userData != null) {
        return _userData;
      }
      else if(x<maxRetry){  //otherwise, retry getting UID for maxRetry - 1 times
        debugPrint("Failed to retrieve User Data, retrying...");
        await Future.delayed(Duration(seconds: 2)); //wait for 2 seconds and retry/continue get data again
      }
      else{ //if User Data still failed to get after maxRetry, operation cancelled, print error
        print("Failed to retrieve User Data after $maxRetry tries, please check for errors.");
        return null;  //ends the onLoad() function
      }
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _receivedData = _retrieveUserData();
  }

  Widget build(BuildContext context){
    return FutureBuilder(
      future: _receivedData,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text("Retrieving User Data..."),
                    ),
                  )
                ],
              )
            );
            break;
          case ConnectionState.done:
            return ProgressBar(_uid,_userData);
            break;
          default:
            return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                          child: Text("Error")
                      ),
                    )
                  ],
                )
            );
        }
      }
    );
  }
}

class ProgressBar extends StatefulWidget{
  final String _uid;
  final UserData _userData;
  ProgressBar(this._uid, this._userData);
  @override
  State<StatefulWidget> createState() => _ProgressBarState();
}
class _ProgressBarState extends State<ProgressBar>{
  String message="";
  double percent=0.00;
  void _downloadUserImages() async {
    final appDocDir = await getLocalPath();
    final uidpart = widget._uid.substring(0,3);
    final folders = widget._userData.folders;
    final downloader = CloudStorage();
    String message;
    double percent=0.00;
    List image_list =[];

    for(Map folder in folders){
      for(Map image in folder["children"])
        image_list.add(image);
    }
    final length = image_list.length;
    message = "Account contains $length images.";
    setState(() {
      this.message = message;
      this.percent = percent;
    });

    if(length != 0) {
      int index = 0;
      debugPrint("Downloading images...");
      for (Map folder in folders) {
        for (Map image in folder["children"]) {
          index += 1;
          message = "[$index/$length] image id:${image["image_id"]}, image name:${image["name"]}";
          debugPrint(message);
          File img = File("/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg");
          Directory imgpath = Directory("/storage/emulated/0/Flutter Photo/IMG_$uidpart${image["image_id"]}.jpg");
          File tmb = File("$appDocDir/${widget._uid}/${folder["folder_id"]}/TMB_$uidpart${image["image_id"]}.jpg");
          bool img_exist = await img.exists();
          bool tmb_exist = await tmb.exists();
          if (!img_exist) {  //check if image exists locally, otherwise, download image and create thumbnail
            debugPrint("${image["name"]} does not exists.");
            await downloader.getFileToGallery(widget._uid, image['image_id'], folder["folder_id"]);
            debugPrint("${image["name"]} successfully downloaded.");
          }
          else if (!tmb_exist) { //if image exists, thumbnail may not exist, so create thumbnail if not found
            print("${image["name"]} thumbnail does not exists.");
            await createLocalThumbnail(widget._uid, image['image_id'], folder["folder_id"], img);
            print("${image["name"]} thumbnail successfully downloaded.");
          }
          percent=index/length;
          setState(() {
            this.message = message;
            this.percent = percent;
          });
        }
      }
    }
    Navigator.popAndPushNamed(context,Folder_Page);
  }

  @override
  void initState(){
    super.initState();
    _downloadUserImages();
  }

  Widget build(BuildContext context){
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(message,style: TextStyle(fontSize: 18.0),),
            LinearPercentIndicator(
              lineHeight: 11.0,
              percent: percent,
            ),
          ],
        )
    );
  }
}