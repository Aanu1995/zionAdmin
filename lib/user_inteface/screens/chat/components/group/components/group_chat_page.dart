import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/zion_group_chat.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class GroupChatPage extends StatelessWidget {
  final Group group;
  final UserProfile user;

  GroupChatPage({
    this.user,
    this.group,
  });

  final GlobalKey<ZionMessageChatState> _chatViewKey =
      GlobalKey<ZionMessageChatState>();

  Widget userTyping() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(group.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
          return Offstage();
        } else {
          String membername = snapshot.data.data['typing'];
          if (membername != null &&
              membername.isNotEmpty &&
              membername != user.name) {
            return Text(
              '$membername is typing',
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14.0,
              ),
            );
          }
        }
        return Offstage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomCircleAvatar(
              size: 40.0,
              profileURL: group.groupIcon,
            ),
            EmptySpace(horizontal: true, multiple: 1.5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                ),
                userTyping(),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImageUtils.chatBackground,
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(FirebaseUtils.chats)
                  .document(group.id)
                  .collection(FirebaseUtils.messages)
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
                  // update user last seen
                  ChatServcice.updateGroupCheckMessageTime(user.id, group.id);
                  return ZionGroupChat(
                    chatKey: _chatViewKey,
                    messages: messages,
                    group: group,
                    lastDocumentSnapshot:
                        items.length != 0 ? items[items.length - 1] : null,
                    user: ChatUser(uid: user.id, name: user.name),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
