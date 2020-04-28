import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/global_data_utils.dart';

class GroupChatService {
  // The functions below are for the group chat
  // ---------------------------------------------------------------------------
  static Future<bool> createGroup(
      String groupName, List<UserProfile> participants,
      {File file, String adminId}) async {
    String groupId = Uuid().v4().toString();
    FirebaseUser admin = await FirebaseAuth.instance.currentUser();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    // list of members in the group
    List<Member> members = [];
    participants.forEach((user) => members.add(
          Member(
            id: user.id,
            name: user.name,
            admin: adminId == user.id ? true : false,
          ),
        ));
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

// add participants to the group
  static Future<bool> addParticipants(Group group, List participants) async {
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    // list of members in the group
    List<Member> members = [];
    participants.forEach((user) => members.add(
          Member(
            id: user.id,
            name: user.name,
            admin: false,
          ),
        ));
    // group

    try {
      final document =
          Firestore.instance.collection(FirebaseUtils.chats).document(group.id);
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
            .document(group.id)
            .setData({
          'name': group.name,
          'id': group.id,
          'time': createdAt,
        });
      }
      await GroupChatService.getMembersListFromServer(group.id);
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

// gets the members list from the local database
  static Future<List<UserProfile>> getMembersListFromLocal(
      String groupId) async {
    var box = await Hive.openBox(GlobalDataUtils.zion);
    List groupData = await box.get(groupId);
    List<UserProfile> membersProfile = [];
    if (groupData != null) {
      groupData.forEach((memberData) {
        final profile = UserProfile.fromMap(map: memberData);
        membersProfile.add(profile);
      });
    }
    return membersProfile;
  }

  // gets members list from the server
  static getMembersListFromServer(String groupId) async {
    var box = await Hive.openBox(GlobalDataUtils.zion);
    bool connection = await DataConnectionChecker().hasConnection;
    if (!connection) {
      return;
    }
    List<Map> list = [];
    final doc = await FirebaseUtils.firestore
        .collection(FirebaseUtils.chats)
        .document(groupId)
        .collection('members')
        .getDocuments();
    final userCol = FirebaseUtils.firestore.collection(FirebaseUtils.user);
    final adminCol = FirebaseUtils.firestore.collection(FirebaseUtils.admin);
    for (int i = 0; i < doc.documents.length; i++) {
      if (doc.documents[i].data['admin'] == true) {
        final adminDoc = adminCol.document(doc.documents[i].documentID);
        final data = await adminDoc.get();
        list.add(data.data);
      } else {
        final userDoc = userCol.document(doc.documents[i].documentID);
        final data = await userDoc.get();
        list.add(data.data);
      }
    }
    if (list.isNotEmpty) {
      box.put(groupId, list);
    }
  }
}
