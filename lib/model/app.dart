import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zion/user_inteface/utils/global_data_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppModel with ChangeNotifier {
  // gets app config from the local storage when app is opened
  AppModel() {
    getConfig();
  }

  void getConfig() async {
    try {
      var box = await Hive.openBox(GlobalDataUtils.zion);
      _darkTheme = box.get(GlobalDataUtils.darkTheme) ?? false;
    } catch (e) {
      print(e);
    }
  }

  bool _darkTheme = false;

  Future<void> updateTheme(bool theme) async {
    try {
      var box = await Hive.openBox(GlobalDataUtils.zion);
      _darkTheme = theme;
      notifyListeners();
      await box.put(GlobalDataUtils.darkTheme, theme);
    } catch (error) {
      print("theme could not be changed");
    }
  }

  bool get darkTheme => _darkTheme;
}

class SplashAppStatus with ChangeNotifier {
  // checks if the splash is still showing
  // returns true if splash is still showing else return false
  bool _isLoading = true;

// setter
  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

// getter
  bool get isLoading => _isLoading;
}

class User {
  FirebaseUser _user;
  FirebaseUser get user => _user;
  User() {
    getUser();
  }

  void getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }
}
