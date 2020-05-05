import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/user_inteface/screens/chat/components/chat_widget.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/group_chat_widget.dart';
import 'package:zion/user_inteface/screens/chat/components/group/create_group.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  static List chatList = [];
  static UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    userProfile = Provider.of<UserProvider>(context, listen: false).userProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: <Widget>[
          /* IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchChat(chats: chatList, userProfile: userProfile),
            ),
          ) */
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
              return ListView(
                children: chatList.map((f) {
                  final chat = f.data;
                  final chatType = chat['chat_type'];
                  if (chatType == FirebaseUtils.oneone) {
                    ChatModel oneone = ChatModel.fromMap(map: chat);
                    return Column(
                      children: [
                        ChatWidget(oneone: oneone, user: userProfile),
                        if (chatList.length > 1)
                          const Padding(
                            padding: EdgeInsets.only(left: 90.0, right: 16.0),
                            child: Divider(height: 8.0),
                          )
                      ],
                    );
                  }
                  if (chatType == FirebaseUtils.group) {
                    Group group = Group.fromMap(map: chat);
                    return Column(children: [
                      GroupChatWidget(group: group, user: userProfile),
                      if (chatList.length > 1)
                        const Padding(
                          padding: EdgeInsets.only(left: 90.0, right: 16.0),
                          child: Divider(height: 8.0),
                        )
                    ]);
                  }
                  return Offstage();
                }).toList(),
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
}
