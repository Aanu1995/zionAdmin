import 'package:flutter/material.dart';
import 'package:zion/user_inteface/screens/authentication/login_page.dart';
import 'package:zion/user_inteface/screens/default_page.dart';
import 'package:zion/user_inteface/screens/settings/profile_page.dart';

class Routes {
  static const String LOGINPAGE = '/login';
  static const String DEFAULTPAGE = "/defaultpage";
  static const String PROFILE = "/profile";
  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        LOGINPAGE: (context) => LoginPage(),
        DEFAULTPAGE: (context) => DefaultPage(),
        PROFILE: (context) => ProfilePage(),
      };
}
