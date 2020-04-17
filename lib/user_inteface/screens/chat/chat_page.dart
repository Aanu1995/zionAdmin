import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/router/router.dart';
import 'package:zion/user_inteface/screens/chat/components/chat_widget.dart';
import 'package:zion/user_inteface/screens/chat/components/group/create_group.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/chat/search_page.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';

const double _fabDimension = 56.0;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List chats = [];
  FirebaseUser admin;

  @override
  void initState() {
    super.initState();
    admin = Provider.of<User>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchChat(chats: chats, admin: admin),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        // gets the list of all chats for the admin
        child: StreamBuilder<QuerySnapshot>(
          stream: Stream.value(Provider.of<QuerySnapshot>(context)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              chats = snapshot.data.documents;
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chatId = chats[index].documentID;
                  // gets the user profile for each chat
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseUtils.firestore
                        .collection(FirebaseUtils.user)
                        .document(chatId)
                        .snapshots(),
                    builder: (context, user) {
                      if (user.hasData) {
                        final responserProfile =
                            UserProfile.fromMap(map: user.data.data);
                        // gets the last chat details for each chat
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () => pushDynamicScreen(
          context,
          screen: MaterialPageRoute(
            builder: (context) => CreateGroupChat(),
          ),
          platformSpecific: true,
          withNavBar: false,
        ),
      ),
    );
  }
  /*  */

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
