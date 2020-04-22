import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/group_chat_widget.dart';
import 'package:zion/user_inteface/screens/chat/components/group/create_group.dart';
import 'package:zion/user_inteface/screens/chat/search_page.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List chatList = [];
  UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = Provider.of<UserProvider>(context, listen: false).userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchChat(chats: chatList, userProfile: userProfile),
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
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              chatList = snapshot.data.documents;
              if (chatList.length == 0) return Container();
              return Scrollbar(
                child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final chat = chatList[index].data;
                    // checks the chatType
                    final chatType = chat['chat_type'];
                    if (chatType == FirebaseUtils.oneone) {
                      return Container();
                    } else {
                      Group group = Group.fromMap(map: chat);
                      return GroupChatWidget(group: group, user: userProfile);
                    }
                  },
                ),
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

}

/* 
StreamBuilder<DocumentSnapshot>(
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
                                .collection(FirebaseUtils.chats)
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
                    ); */
