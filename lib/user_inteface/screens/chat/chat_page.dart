import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/user_inteface/screens/chat/admin_chat_page.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
import 'package:badges/badges.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseUser admin; // firebase user

  @override
  void initState() {
    super.initState();
    admin = Provider.of<User>(context, listen: false).user;
    print(admin.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseUtils.firestore
              .collection(FirebaseUtils.chat)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List chats = snapshot.data.documents;
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chatId = chats[index].documentID;
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseUtils.firestore
                        .collection(FirebaseUtils.user)
                        .document(chatId)
                        .snapshots(),
                    builder: (context, user) {
                      if (user.hasData) {
                        final responserProfile =
                            UserProfile.fromMap(map: user.data.data);
                        return StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection(FirebaseUtils.chat)
                              .document(chatId)
                              .collection(FirebaseUtils.admin)
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                          builder: (context, messagesSnapshot) {
                            if (messagesSnapshot.hasData) {
                              /// gets the time the user read from the chat
                              /// use it to determine the count of unread messages
                              /// Also gets the latest message and time of the chat
                              return FutureBuilder(
                                future: getLatestData(
                                    messagesSnapshot.data, chatId),
                                builder: (context, chatData) {
                                  if (chatData.hasData) {
                                    return ChatWidget(
                                      chatData: chatData.data,
                                      user: admin,
                                      responderProfile: responserProfile,
                                      chatId: chatId,
                                    );
                                  }
                                  return ChatWidget(
                                    chatData: ChatData(),
                                    user: admin,
                                    responderProfile: responserProfile,
                                    chatId: chatId,
                                  );
                                },
                              );
                            }
                            return ChatWidget(
                              chatData: ChatData(),
                              user: admin,
                              responderProfile: responserProfile,
                              chatId: chatId,
                            );
                          },
                        );
                      }
                      return ShimmerLoadingItem();
                    },
                  );
                },
              );
            }
            return ShimmerLoadingList();
          },
        ),
      ),
    );
  }

// gets latest unread messages from the server
  /// use it to determine the count of unread messages
  /// Also gets the latest message and time of the chat
  Future<ChatData> getLatestData(QuerySnapshot snapshot, String chatId) async {
    int count = 0;
    final messages = snapshot.documents;
    ChatMessage lastMessage = ChatMessage.fromJson(messages[0].data);
    final document = await Firestore.instance
        .collection(FirebaseUtils.chat)
        .document(chatId)
        .get();
    final userLastSeenTime =
        document.data[admin.uid] + 5000; // delay of 5 seconds
    if (userLastSeenTime != null) {
      messages.forEach((mess) {
        int messTime = int.parse(mess.documentID);
        if (userLastSeenTime < messTime) {
          count = count + 1;
        }
      });
    }
    return ChatData(
        lastMessage: lastMessage.text,
        time: DateFormat('h:mm a').format(lastMessage.createdAt),
        unreadMessages: count);
  }
}

class ChatWidget extends StatelessWidget {
  final UserProfile responderProfile;
  final ChatData chatData;
  final FirebaseUser user;
  final String chatId;
  ChatWidget({this.chatData, this.user, this.responderProfile, this.chatId});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0.0, right: 12.0),
      leading: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 35.0,
            child: CustomCircleAvatar(
              size: 56.0,
              profileURL: responderProfile.profileURL,
            ),
          ),
          Positioned(
            bottom: 6.0,
            right: 6.0,
            child: CircleAvatar(
              radius: 6,
              backgroundColor:
                  responderProfile.online ? Colors.green : Colors.redAccent,
            ),
          )
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            responderProfile.name,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            chatData.time,
            style: TextStyle(
              color:
                  chatData.unreadMessages > 0 ? Colors.green : Colors.black54,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: chatData.unreadMessages > 0 ? 0.0 : 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                chatData.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ),
            if (chatData.unreadMessages > 0)
              Padding(
                padding: EdgeInsets.only(right: 8.0, left: 16.0),
                child: Badge(
                  badgeColor: Colors.green,
                  padding: EdgeInsets.all(6.0),
                  badgeContent: Text(
                    '${chatData.unreadMessages}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      onTap: () async {
        // takes user to the admin chat page
        pushDynamicScreen(
          context,
          screen: MaterialPageRoute(
            builder: (context) => AdminChatPage(
              chatId: chatId,
              responderProfile: responderProfile,
              adminId: user.uid,
            ),
          ),
          platformSpecific: true,
          withNavBar: false,
        );
      },
    );
  }
}
