import 'package:flutter/material.dart';
import 'package:zion/model/profile.dart';

class CreateGroupProvider with ChangeNotifier {
  List<UserProfile> _groupParticipantList = [];
  List<UserProfile> get getList => _groupParticipantList;
  // add participants to the group
  addParticipant(UserProfile profile) {
    if (_groupParticipantList.contains(profile)) {
      _groupParticipantList.remove(profile);
    } else {
      _groupParticipantList.add(profile);
    }
    notifyListeners();
  }

  // checks if partcipant has been handle
  bool checkAddedStatus(UserProfile profile) {
    if (_groupParticipantList.contains(profile)) {
      return true;
    } else {
      return false;
    }
  }

  void emptyList() {
    _groupParticipantList.clear();
  }
}
