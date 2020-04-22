import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class ChatStreams {
  Stream<QuerySnapshot> allChatsStream = FirebaseUtils.firestore
      .collection(FirebaseUtils.chats)
      .orderBy('time', descending: true)
      .snapshots();
  // gets all users
  Stream<QuerySnapshot> allUserStream =
      FirebaseUtils.firestore.collection(FirebaseUtils.user).snapshots();
}
