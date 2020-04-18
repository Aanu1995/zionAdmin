import 'package:flutter/material.dart';
import 'package:zion/model/profile.dart';

class CreateGroupProvider with ChangeNotifier {
  List<UserProfile> groupParticipantList = [];

  // add participants to the group
  addParticipant(UserProfile profile) {
    print('tapped');
    if (!groupParticipantList.contains(profile)) {
      groupParticipantList.add(profile);
    } else {
      groupParticipantList.remove(profile);
    }
    notifyListeners();
  }

  // checks if partcipant has been handle
  bool checkAddedStatus(UserProfile profile) {
    if (groupParticipantList.contains(profile)) {
      return true;
    } else {
      return false;
    }
  }

  void emptyList() {
    groupParticipantList.clear();
  }
}
