import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/group_chat_page.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class GroupChatWidget extends StatelessWidget {
  final Group group;
  final UserProfile user;
  const GroupChatWidget({this.group, this.user});

// displays last message details if user is not typing

  @override
  Widget build(BuildContext context) {
    final time =
        DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(group.time));

    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0.0, right: 12.0),
        leading: Hero(
          tag: group.id,
          child: InkWell(
            child: CircleAvatar(
              radius: 28.0,
              backgroundColor: Colors.grey,
              child: CustomCircleAvatar(
                size: 67.0,
                profileURL: group.groupIcon,
              ),
            ),
            onTap: () => CustomDialogs.showGroupDialog(context, group, user),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                group.name,
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
                child: UserTyping(user: user, group: group),
              ),
              UnreadMessages(user: user, group: group),
            ],
          ),
        ),
        onTap: () async {
          // takes user to the group chat page
          Provider.of<CurrentGroupProvider>(context, listen: false).setGroup =
              group;
          pushDynamicScreen(
            context,
            screen: MaterialPageRoute(
              builder: (context) => GroupChatPage(
                user: user,
              ),
            ),
            platformSpecific: true,
            withNavBar: false,
          );
        },
      ),
    );
  }
}

class UserTyping extends StatelessWidget {
  final UserProfile user;
  final Group group;
  const UserTyping({this.user, this.group});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(group.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
          return RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: (group.fromName != user.name && group.fromName != '')
                      ? '${group.fromName}: '
                      : '',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${group.message}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        } else {
          String membername = snapshot.data.data['typing'];
          if (membername != null &&
              membername.isNotEmpty &&
              membername != user.name) {
            return Text(
              '$membername: is typing',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.0,
              ),
            );
          }
        }
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: (group.fromName != user.name && group.fromName != null)
                    ? '${group.fromName}: '
                    : '',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '${group.message}',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UnreadMessages extends StatelessWidget {
  final UserProfile user;
  final Group group;
  const UnreadMessages({this.user, this.group});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0, left: 16.0),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseUtils.firestore
            .collection(FirebaseUtils.chats)
            .document(group.id)
            .collection(FirebaseUtils.messages)
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
                  .document(group.id)
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
