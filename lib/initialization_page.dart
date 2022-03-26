import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';
import 'userdata.dart';
import 'app_router.dart';
import 'loading_page.dart';
import 'error_page.dart';
import 'strings.dart';
import 'images.dart';
import 'screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'cloud_storage.dart';
import 'userdata_provider.dart';
import 'initialization_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InitializationPage extends ConsumerStatefulWidget {
  const InitializationPage({Key? key}):super(key:key);

  @override
  InitializationPageState createState() => InitializationPageState();
}

class InitializationPageState extends ConsumerState<InitializationPage> {
  late InitializationProvider _initprovider;
  late InitStatus _initstatus;
  late double _initpercent;
  late ChangeNotifierProvider<InitializationProvider> _initprovider;

  @override
  void initState(){
    super.initState();
    Screen().portrait();
    _initprovider = ref.read(initializationProvider);
  }

  @override
  Widget build(BuildContext context) {
    _initstatus = ref.watch(initializationProvider.select((init) => init.status));
    _initpercent = ref.watch(initializationProvider.select((init) => init.percent));
    //_initstatus = ref.watch(_initprovider.select((value) => value.status));
    //_initpercent = ref.watch(_initprovider.select((value) => value.percent));

    //Display
    switch(_initstatus){
      case InitStatus.none: {
        return LoadingPage("X");
      }
      case InitStatus.retrievingUserdata: {
        return LoadingPage("Retrieving User Data...");
      }
      case InitStatus.downloadingImage: {
        //return LoadingPage(_initpercent.toString());
        return LoadingPage(_initpercent.toString());
      }
      case InitStatus.done: {
        return LoadingPage("DONE DOWNLOAD"); //goto homepage
      }
      default: {
        return ErrorPage(
          text: Strings.userdataFailedtoRetrieve,
          image: Images.defaultError,
        );
      }
    }
  }
}

