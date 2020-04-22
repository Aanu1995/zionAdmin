import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class GroupChatService {
  // The functions below are for the group chat
  // ---------------------------------------------------------------------------
  static Future<bool> createGroup(
      String groupName, List<UserProfile> participants,
      {File file}) async {
    String groupId = Uuid().v4().toString();
    FirebaseUser admin = await FirebaseAuth.instance.currentUser();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    // list of members in the group
    List<Member> members = [];
    participants
        .forEach((user) => members.add(Member(id: user.id, name: user.name)));
    // group
    String groupIcon;
    if (file != null) {
      groupIcon = await uploadGroupIcon(groupId, file);
    }
    Group group = Group(
      id: groupId,
      adminId: admin.uid,
      adminName: '',
      createdAt: createdAt,
      time: createdAt,
      fromId: '',
      groupIcon: groupIcon ?? '',
      name: groupName,
    );
    try {
      final document =
          Firestore.instance.collection(FirebaseUtils.chats).document(groupId);
      await document.setData(Group.toMap(group: group)); // sets the group data
      for (int i = 0; i < members.length; i++) {
        // creates all the members
        await document.collection('members').document(members[i].id).setData(
              Member.toMap(
                members[i],
              ),
            );
      }

      for (int i = 0; i < members.length; i++) {
        // creates all the members
        await Firestore.instance
            .collection(FirebaseUtils.user)
            .document(members[i].id)
            .collection("groups")
            .document(groupId)
            .setData({
          'name': groupName,
          'id': groupId,
          'time': createdAt,
        });
      }
      await Firestore.instance
          .collection(FirebaseUtils.admin)
          .document(admin.uid)
          .collection("groups")
          .document(groupId)
          .setData({
        'name': groupName,
        'id': groupId,
        'time': createdAt,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

// this upload the group icon to the storage
  static Future<String> uploadGroupIcon(String groupId, File file) async {
    try {
      final storageReference = FirebaseUtils.storage
          .ref()
          .child('group_icon')
          .child(groupId)
          .child("icon.jpg");
      StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;
      final String url = await storageReference.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
