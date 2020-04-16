import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String message;
  final String date;
  final String time;
  final bool read;
  final String messageId;
  final Timestamp timestamp;

  NotificationModel(
      {this.title,
      this.message,
      this.date,
      this.time,
      this.timestamp,
      this.read = false,
      this.messageId});

// converts data in map to object
  factory NotificationModel.fromMap(
      {Map<String, dynamic> map, String messageId}) {
    String messageTime;
    String messageDate;
    // convert time in Timestamp to datetime
    final time = map['time'];
    if (time != null) {
      DateTime messageDateTime =
          new DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);
      messageTime = DateFormat.jm().format(messageDateTime);
      messageDate = DateFormat.yMMMd().format(messageDateTime);
    }
    return NotificationModel(
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      read: map['read'] ?? false,
      time: messageTime ?? '',
      date: messageDate ?? '',
      messageId: messageId,
    );
  }

// converts object to map
  static Map<String, dynamic> toMap({NotificationModel value}) {
    return <String, dynamic>{
      'title': value.title ?? '',
      'message': value.message ?? '',
      'read': value.read,
      'time': Timestamp.now(),
    };
  }

  // converts list of maps to list of object
  static List<NotificationModel> fromQuerySnapshot({QuerySnapshot snapshot}) {
    List<NotificationModel> list = [];
    snapshot.documents.forEach(
      (item) => list.add(NotificationModel.fromMap(
          map: item.data, messageId: item.documentID)),
    );
    return list;
  }
}
