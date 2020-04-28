import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/group_details.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/zion_group_chat.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class GroupChatPage extends StatefulWidget {
  final Group group;
  final UserProfile user;

  GroupChatPage({
    this.user,
    this.group,
  });

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final GlobalKey<ZionMessageChatState> _chatViewKey =
      GlobalKey<ZionMessageChatState>();

  @override
  void initState() {
    super.initState();
    // gets list of members
    GroupChatService.getMembersListFromServer(widget.group.id);
  }

  Widget userTyping() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(widget.group.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
          return Offstage();
        } else {
          String membername = snapshot.data.data['typing'];
          if (membername != null &&
              membername.isNotEmpty &&
              membername != widget.user.name) {
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
        title: InkWell(
          splashColor: Colors.transparent,
          child: Row(
            children: [
              CustomCircleAvatar(
                size: 40.0,
                profileURL: widget.group.groupIcon,
              ),
              EmptySpace(horizontal: true, multiple: 1.5),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.name,
                    style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                  ),
                  userTyping(),
                ],
              )
            ],
          ),
          onTap: () {
            // takes user to the group detail page
            pushDynamicScreen(
              context,
              screen: MaterialPageRoute(
                builder: (context) =>
                    GroupDetails(group: widget.group, userId: widget.user.id),
              ),
              platformSpecific: true,
              withNavBar: false,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
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
                  .document(widget.group.id)
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
                  ChatServcice.updateGroupCheckMessageTime(
                      widget.user.id, widget.group.id);
                  return ZionGroupChat(
                    chatKey: _chatViewKey,
                    messages: messages,
                    group: widget.group,
                    lastDocumentSnapshot:
                        items.length != 0 ? items[items.length - 1] : null,
                    user: ChatUser(uid: widget.user.id, name: widget.user.name),
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
