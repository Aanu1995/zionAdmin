import 'package:equatable/equatable.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class ChatModel {
  final String id;
  final String userId;
  final String adminId;
  final String chatType;
  final String message;
  final String image;
  final int time;
  final String fromId;
  final String fromName;

  ChatModel({
    this.id,
    this.userId,
    this.adminId,
    this.fromName,
    this.chatType,
    this.message,
    this.image,
    this.time,
    this.fromId,
  });

  factory ChatModel.fromMap({
    Map<String, dynamic> map,
    Members members,
  }) {
    return ChatModel(
      id: map['id'],
      userId: map['userId'],
      adminId: map['adminId'],
      chatType: map['chat_type'],
      message: map['message'] ?? '',
      image: map['image'] ?? '',
      fromId: map['from_id'] ?? '',
      time: map['time'],
      fromName: map['from_name'],
    );
  }

  static Map<String, dynamic> toMap({ChatModel chatModel}) {
    return {
      'id': chatModel.id,
      'userId': chatModel.userId,
      'adminId': chatModel.adminId,
      'chat_type': FirebaseUtils.oneone,
      'message': chatModel.message ?? '',
      'image': chatModel.image ?? '',
      'from_id': chatModel.fromId ?? '',
      'time': chatModel.time,
      'from_name': '',
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
  bool admin;

  Member({this.id, this.name, this.admin}) : assert(name != null && id != null);

  factory Member.fromMap({Map<String, dynamic> map}) {
    return Member(
      name: map['name'],
      id: map['id'],
      admin: map['admin'],
    );
  }

  static Map<String, dynamic> toMap(Member member) {
    return {
      'name': member.name ?? '',
      'id': member.id ?? '',
      'admin': member.admin ?? false,
    };
  }
}
