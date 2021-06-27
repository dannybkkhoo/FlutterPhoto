//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

enum ConnStatus {
  connected,
  notConnected,
  unknown
}

class ConnProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  ConnStatus _connectionStatus = ConnStatus.unknown;
  bool _internetStatus = false;
  bool _stopChecking = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnProvider(){initConnectivity();} //run initialization once

  Connectivity get connectivity => _connectivity;
  ConnStatus get connectionStatus => _connectionStatus;
  bool get internetStatus => _internetStatus;
  StreamSubscription get connectivitySubscription => _connectivitySubscription;

  Future<void> _checkInternetStatus() async { //continuously check for internet connection if connected to WiFi or mobile network
    await _updateInternetStatus();            //will check once first
    Timer.periodic(Duration(seconds:3),(Timer timer)=>_updateInternetStatus(timer));  //then will check again every 3 seconds
  }

  void _stopCheckInternet() { //will stop periodically checking internet connection if not connected to WiFi or mobile network
    _stopChecking = true;
    _internetStatus = false;
    notifyListeners();
  }

  Future<void> _updateInternetStatus([Timer? timer = null]) async {  //tries to connect to an example webpage on the internet
    if(_stopChecking){
      if(timer != null){
        timer.cancel();
        print("zz");
      }
    }
    else{
      bool _prevStatus = _internetStatus;
      try{
        final result = await InternetAddress.lookup('example.com');
        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
          _internetStatus = true;
        }
      } on SocketException catch (_) {
        _internetStatus = false;
      }
      if(_prevStatus != _internetStatus){ //if internet connection status changed, then notify other widgets
        if(_internetStatus){  //if connected to internet
          _connectionStatus = ConnStatus.connected;
        }
        else{
          _connectionStatus = ConnStatus.notConnected;
        }
        notifyListeners();
      }
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch(result){
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        _stopChecking = false;
        await _checkInternetStatus();
        break;
      case ConnectivityResult.none:
        _connectionStatus = ConnStatus.notConnected;
        _stopCheckInternet();
        break;
      default:
        _connectionStatus = ConnStatus.unknown;
        _stopCheckInternet();
    }
  }

  Future<void> initConnectivity() async {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    late ConnectivityResult result;
    try{
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch(e) {
      print(e.toString());
      return;
    }
    return _updateConnectionStatus(result);
  }
}