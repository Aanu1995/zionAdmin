import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/global_data_utils.dart';

class UserProvider {
  UserProfile _userProfile;

  UserProvider() {
    getUserData();
  }

  void getUserData() async {
    var box = await Hive.openBox(GlobalDataUtils.zion);
    bool connection = await DataConnectionChecker().hasConnection;
    if (!connection) {
      _userProfile = UserProfile.fromMap(map: await box.get('user'));
    }
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final doc = await Firestore.instance
        .collection(FirebaseUtils.admin)
        .document(user.uid)
        .get();
    box.put('user', doc.data);
    _userProfile = UserProfile.fromMap(map: doc.data);
  }

  UserProfile get userProfile => _userProfile;
}
