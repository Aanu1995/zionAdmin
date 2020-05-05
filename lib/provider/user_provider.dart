import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/global_data_utils.dart';

class UserProvider with ChangeNotifier {
  UserProfile _userProfile;

  UserProvider() {
    getDefaultData();
    getUserData();
  }

  void getDefaultData() async {
    var box = await Hive.openBox(GlobalDataUtils.zion);
    final map = await box.get('user');
    if (map != null) {
      _userProfile = UserProfile.fromMap(map: map);
    }
  }

  getUserData() async {
    var box = await Hive.openBox(GlobalDataUtils.zion);
    bool connection = await DataConnectionChecker().hasConnection;
    if (!connection) {
      return;
    }
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final doc = await Firestore.instance
        .collection(FirebaseUtils.admin)
        .document(user.uid)
        .get();
    box.put('user', doc.data);
    _userProfile = UserProfile.fromMap(map: doc.data);
    notifyListeners();
  }

  UserProfile get userProfile => _userProfile;
}
