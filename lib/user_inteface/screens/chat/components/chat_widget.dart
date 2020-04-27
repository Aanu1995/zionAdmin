import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:zion/user_inteface/screens/chat/admin_chat_page.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel oneone;
  final UserProfile user;
  const ChatWidget({this.oneone, this.user});

// displays last message details if user is not typing

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm()
        .format(DateTime.fromMillisecondsSinceEpoch(oneone.time));
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(oneone.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          UserProfile userProfile =
              UserProfile.fromMap(map: snapshot.data.data);
          return Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 12.0),
              leading: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 28.0,
                    backgroundColor: Colors.grey,
                    child: CustomCircleAvatar(
                      size: 67.0,
                      profileURL: userProfile.profileURL,
                    ),
                  ),
                  Positioned(
                    bottom: 6.0,
                    right: 0.0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor:
                          userProfile.online ? Colors.green : Colors.redAccent,
                    ),
                  )
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      userProfile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: UserTyping(
                        oneone: oneone,
                        user: user,
                      ),
                    ),
                    UnreadMessages(
                      oneone: oneone,
                      user: user,
                    )
                  ],
                ),
              ),
              onTap: () async {
                // takes user to the group chat page
                pushDynamicScreen(
                  context,
                  screen: MaterialPageRoute(
                    builder: (context) => AdminChatPage(
                      oneone: oneone,
                      user: user,
                      responderProfile: userProfile,
                    ),
                  ),
                  platformSpecific: true,
                  withNavBar: false,
                );
              },
            ),
          );
        }
        return ShimmerLoadingItem();
      },
    );
  }
}

class UserTyping extends StatelessWidget {
  final UserProfile user;
  final ChatModel oneone;
  const UserTyping({this.user, this.oneone});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(oneone.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
          return Text(
            '${oneone.message}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black54,
            ),
          );
        } else {
          String memberId = snapshot.data.data['typing'];
          if (memberId != null && memberId.isNotEmpty && memberId != user.id) {
            return Text(
              'Typing',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.0,
              ),
            );
          }
        }
        return Text(
          '${oneone.message}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black54,
          ),
        );
      },
    );
  }
}

class UnreadMessages extends StatelessWidget {
  final UserProfile user;
  final ChatModel oneone;
  const UnreadMessages({this.user, this.oneone});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0, left: 16.0),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseUtils.firestore
            .collection(FirebaseUtils.chats)
            .document(oneone.id)
            .collection(FirebaseUtils.messages)
            .where('messageStatus', isLessThan: 2)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.length == 0) {
            return Offstage();
          } else if (snapshot.hasData) {
            final messages = snapshot.data.documents;
            int unreadMessages = 0;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseUtils.firestore
                  .collection(FirebaseUtils.admin)
                  .document(user.id)
                  .collection(FirebaseUtils.groups)
                  .document(oneone.id)
                  .get(),
              builder: (context, snap) {
                if (!snap.hasData || snap.data.data == null) {
                  return Offstage();
                } else {
                  messages.forEach((mess) {
                    int messTime = int.parse(mess.documentID);
                    int lastSeen = snap.data.data['time'];
                    if (lastSeen < messTime) {
                      unreadMessages = unreadMessages + 1;
                    }
                  });

                  return unreadMessages == 0
                      ? Offstage()
                      : CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 10.5,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "$unreadMessages",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                }
              },
            );
          }
          return Offstage();
        },
      ),
    );
  }
}
