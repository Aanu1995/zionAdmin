import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';

class ChatModel {
  final String message;
  final String time;
  final bool isUser;
  final DateTime dateTime;
  final String image;
  final String audio;

  ChatModel({
    this.message,
    this.time,
    this.isUser = false,
    this.dateTime,
    this.audio,
    this.image,
  });

  factory ChatModel.fromMap({Map<String, dynamic> map}) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(map['time'].seconds * 1000);
    var format = DateFormat.jm();
    var correctDate = format.format(date);
    return ChatModel(
      message: map["message"] ?? "",
      image: map["image"] ?? "",
      audio: map["audio"] ?? "",
      time: correctDate,
      isUser: map['isUser'] ?? false,
      dateTime: date,
    );
  }

  factory ChatModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    Map<String, dynamic> map = documentSnapshot.data;
    return ChatModel.fromMap(map: map);
  }

  static List<ChatModel> fromQuerySnapshot({QuerySnapshot querySnapshot}) {
    List<DocumentSnapshot> documents = querySnapshot.documents;
    List<ChatModel> list = documents
        .map((f) => ChatModel.fromDocumentSnapshot(documentSnapshot: f))
        .toList();
    return list;
  }

  static Map<String, dynamic> toMap({ChatModel chat}) {
    return {
      'message': chat.message ?? '',
      'image': chat.image ?? '',
      'audio': chat.audio ?? '',
      'isUser': chat.isUser,
      'time': Timestamp.now(),
    };
  }
}

class ChatData extends Equatable {
  final int unreadMessages;
  final String chatId;
  final String time;
  final String lastMessage;

  ChatData(
      {this.lastMessage = '',
      this.time = '',
      this.unreadMessages = 0,
      this.chatId = ''});

  @override
  List<Object> get props => [unreadMessages, time, lastMessage, chatId];
}

class Group {
  final String id;
  final String adminId;
  final String adminName;
  final int createdAt;
  final String groupIcon;
  final String name;
  final String chatType;
  final String message;
  final String image;
  final int time;
  final String fromId;
  final String fromName;
  final Members members;
  Group({
    this.id,
    this.adminId,
    this.adminName,
    this.fromName,
    this.createdAt,
    this.chatType,
    this.message,
    this.image,
    this.time,
    this.fromId,
    this.groupIcon,
    this.name,
    this.members,
  });

  factory Group.fromMap({
    Map<String, dynamic> map,
    Members members,
  }) {
    return Group(
      id: map['id'],
      adminId: map['admin_id'],
      adminName: map['admin_name'],
      groupIcon: map['group_icon'],
      name: map['name'],
      chatType: map['chat_type'] ?? 'group',
      message: map['message'] ?? '',
      image: map['image'] ?? '',
      fromId: map['from_id'] ?? '',
      time: map['time'],
      members: members,
      fromName: map['from_name'],
      createdAt: map['createdAt'],
    );
  }

  static Map<String, dynamic> toMap({Group group}) {
    return {
      'id': group.id,
      'admin_id': group.adminId,
      'admin_name': group.adminName,
      'chat_type': 'group',
      'message': group.message ?? '',
      'image': group.image ?? '',
      'from_id': group.fromId ?? '',
      'time': group.time,
      'name': group.name ?? '',
      'from_name': '',
      'group_icon': group.groupIcon,
      'createdAt': group.createdAt,
    };
  }
}

class Members {
  List<Member> members;
  Members({this.members});
}

class Member {
  String name;
  String id;

  Member({this.id, this.name}) : assert(name != null && id != null);

  factory Member.fromMap({Map<String, dynamic> map}) {
    return Member(name: map['name'], id: map['id']);
  }

  static Map<String, dynamic> toMap(Member member) {
    return {
      'name': member.name ?? '',
      'id': member.id ?? '',
    };
  }
}
