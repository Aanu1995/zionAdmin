/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:zion/user_inteface/screens/chat/components/chat_widget.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class SearchChat extends SearchDelegate {
  final List chats;
  final UserProfile userProfile;
  SearchChat({this.chats, this.userProfile});

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : [
            IconButton(
              icon: Icon(Icons.clear, color: Theme.of(context).accentColor),
              onPressed: () {
                query = "";
              },
            )
          ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).accentColor,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
              final responserProfile = UserProfile.fromMap(map: user.data.data);
              // gets the last chat details for each chat
              return responserProfile.name.contains(query)
                  ? StreamBuilder<QuerySnapshot>(
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
                            future:
                                getLatestData(messagesSnapshot.data, chatId),
                            builder: (context, chatData) {
                              if (chatData.hasData) {
                                return ChatWidget(
                                  chatData: chatData.data,
                                  user: userProfile,
                                  responderProfile: responserProfile,
                                  chatId: chatId,
                                );
                              }
                              return ChatWidget(
                                chatData: ChatData(),
                                user: userProfile,
                                responderProfile: responserProfile,
                                chatId: chatId,
                              );
                            },
                          );
                        }
                        return ChatWidget(
                          chatData: ChatData(),
                          user: userProfile,
                          responderProfile: responserProfile,
                          chatId: chatId,
                        );
                      },
                    )
                  : Offstage();
            }
            return ShimmerLoadingItem();
          },
        );
      },
    );
  }

  /// use it to determine the count of unread messages
  /// Also gets the latest message and time of the chat
  Future<ChatData> getLatestData(QuerySnapshot snapshot, String chatId) async {
    int count = 0;
    final messages = snapshot.documents;
    ChatMessage lastMessage = ChatMessage.fromJson(messages[0].data);
    final document = await Firestore.instance
        .collection(FirebaseUtils.chats)
        .document(chatId)
        .get();
    final userLastSeenTime =
        document.data[userProfile.id] + 5000; // delay of 5 seconds
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
 */
