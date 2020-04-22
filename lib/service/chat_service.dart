import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class ChatServcice {
  // send input messages to the server
  static sendMessage({ChatMessage message, String chatId}) async {
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    try {
      final documentSnapshot =
          Firestore.instance.collection(FirebaseUtils.chats).document(chatId);
      await documentSnapshot
          .collection(FirebaseUtils.messages)
          .document(createdAt.toString())
          .setData(
            message.toJson(createdAt),
          );
      await documentSnapshot.updateData({
        'time': createdAt,
        'message': message.text,
        'from_id': message.user.uid,
        'from_name': message.user.name,
      });
    } catch (e) {}
  }

  //update messageStatus to seen
  static updateMessageStatus({String chatId, int status, String documentId}) {
    try {
      Firestore.instance
          .collection(FirebaseUtils.chats)
          .document(chatId)
          .collection(FirebaseUtils.messages)
          .document(documentId)
          .updateData({'messageStatus': status});
    } catch (e) {}
  }

// send chat messages to the server
  static sendImage(
      {File file, ChatUser user, chatId, int status, String text}) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      StorageUploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.onComplete;
      final String url = await storageRef.getDownloadURL();
      ChatMessage message = ChatMessage(
          text: text, user: user, image: url, messageStatus: status);
      await sendMessage(message: message, chatId: chatId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // load more messages for the chat
  static Future<List<DocumentSnapshot>> loadMoreMessages(
      String chatId, DocumentSnapshot doc) async {
    List<DocumentSnapshot> list = [];
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(FirebaseUtils.chats)
          .document(chatId)
          .collection(FirebaseUtils.messages)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(doc)
          .limit(20)
          .getDocuments();
      if (querySnapshot != null) {
        List<DocumentSnapshot> items = querySnapshot.documents;
        list = items;
      }
    } catch (e) {}
    return list;
  }

  // update the last time a message in a group is checked
  static void updateGroupCheckMessageTime(String userId, String groupId) {
    final lastSeen = DateTime.now().millisecondsSinceEpoch;
    try {
      FirebaseUtils.firestore
          .collection(FirebaseUtils.admin)
          .document(userId)
          .collection(FirebaseUtils.groups)
          .document(groupId)
          .updateData({'time': lastSeen});
    } catch (e) {}
  }

  // send last seen of the user to the server
  static void updateLastSeen({String adminId, String documentId}) {
    final lastSeen = DateTime.now().millisecondsSinceEpoch;
    try {
      Firestore.instance
          .collection(FirebaseUtils.chats)
          .document(documentId)
          .updateData({adminId: lastSeen});
    } catch (e) {}
  }

  // checks if user is typing
  static void isTyping(String chatId, {String username}) {
    Firestore.instance.collection('Typing').document(chatId).setData(
      {'typing': username ?? ""},
    );
  }
}
