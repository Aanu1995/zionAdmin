import 'dart:async';
import 'package:zion/service/user_profile_service.dart';
import 'package:connectivity/connectivity.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  StreamController<bool> connectionStatusController = StreamController<bool>();
  ConnectivityService() {
    try {
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        connectionStatusController.add(_getStatusFromResult(result));
      });
    } catch (e) {}
  }

  bool _getStatusFromResult(ConnectivityResult result) {
    bool status = false;
    switch (result) {
      case ConnectivityResult.mobile:
        status = true;
        break;
      case ConnectivityResult.wifi:
        status = true;
        break;
      case ConnectivityResult.none:
        status = false;
        break;
      default:
        status = false;
        break;
    }
    if (status) UserProfileService.setUserOnline();
    return status;
  }
}
