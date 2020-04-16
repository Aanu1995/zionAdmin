import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/chat/components/zion_chat.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdminChatPage extends StatefulWidget {
  final String chatId;
  final UserProfile responderProfile;
  final String adminId;
  AdminChatPage({
    this.chatId,
    this.responderProfile,
    this.adminId,
  });

  @override
  _AdminChatPageState createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final GlobalKey<ZionMessageChatState> _chatViewKey =
      GlobalKey<ZionMessageChatState>();

  String lastActive;

  @override
  void initState() {
    super.initState();
    final result =
        DateTime.now().difference(widget.responderProfile.lastActive);
    lastActive = timeago.format(DateTime.now().subtract(result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomCircleAvatar(
              size: 40.0,
              profileURL: widget.responderProfile.profileURL,
            ),
            EmptySpace(horizontal: true, multiple: 1.5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.responderProfile.name,
                  style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.responderProfile.online
                      ? 'Online'
                      : 'Last seen: $lastActive',
                  style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(FirebaseUtils.chat)
              .document(widget.chatId)
              .collection(FirebaseUtils.admin)
              .orderBy('createdAt', descending: true)
              .limit(20)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> items = snapshot.data.documents;
              final messages =
                  items.map((i) => ChatMessage.fromJson(i.data)).toList();
              // send last seen of the user in the chat to the server
              ChatServcice.updateLastSeen(
                  adminId: widget.adminId, documentId: widget.chatId);
              return ZionChat(
                chatKey: _chatViewKey,
                messages: messages,
                chatId: widget.chatId,
                online: widget.responderProfile.online,
                lastDocumentSnapshot:
                    items.length != 0 ? items[items.length - 1] : null,
                user: ChatUser(uid: widget.adminId),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

// send images picked during chat to the server
  void onImagePicked() async {
    File result = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (result != null) {
      ChatServcice.sendImage(
        file: result,
        user: ChatUser(uid: widget.adminId),
        chatId: widget.chatId,
      );
    }
  }
}
