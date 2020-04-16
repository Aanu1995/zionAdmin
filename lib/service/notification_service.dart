import 'dart:async';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zion/model/notification.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class PushNotificationService {
  static Future<String> getPlayerId() async {
    final status = await OneSignal.shared.getPermissionSubscriptionState();
    final playerId = status.subscriptionStatus.userId;
    return playerId;
  }

  static void sendWelcomeNotification(
      {String playerId, String username}) async {
    var notification = OSCreateNotification(
      playerIds: [playerId],
      content: "We all at Zion are glad you are using the app",
      heading: "WELCOME ${username.toUpperCase()}",
      androidSmallIcon: 'ic_stat_one_signal_default',
      additionalData: <String, dynamic>{"screen": "/notificationpage"},
    );
    await OneSignal.shared.postNotification(notification);
  }
}

class NotificationService {
  StreamController<List<NotificationModel>> notificationStreamController =
      StreamController.broadcast();

  StreamController<int> countController = StreamController.broadcast();

  // get notification messages from the server
  void getNotificationMessages() async {
    try {
      final user = await FirebaseUtils.auth.currentUser(); // get current user
      final querySnapshot = await FirebaseUtils.firestore
          .collection(FirebaseUtils.notification)
          .document(user.uid)
          .collection(FirebaseUtils.admin)
          .getDocuments();
      if (querySnapshot != null) {
        final notification =
            NotificationModel.fromQuerySnapshot(snapshot: querySnapshot);
        notificationStreamController.add(notification);
      }
    } catch (e) {
      print(e);
    }
  }

  // gets the number of messages that has not been read
  void unreadMessagesCount() async {
    final user = await FirebaseUtils.auth.currentUser(); // get current user
    final querySnapshot = await FirebaseUtils.firestore
        .collection(FirebaseUtils.notification)
        .document(user.uid)
        .collection(FirebaseUtils.admin)
        .where('read', isEqualTo: false)
        .getDocuments();
    if (querySnapshot != null) {
      print(querySnapshot.documents.length);
      countController.add(querySnapshot.documents.length);
    }
  }

  // displose the stream
  void dispose() {
    notificationStreamController.close();
    countController.close();
  }
}
