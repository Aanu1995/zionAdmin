import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/screens/chat/admin_chat_page.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class ChatWidget extends StatelessWidget {
  final UserProfile responderProfile;
  final ChatData chatData;
  final FirebaseUser user;
  final String chatId;
  ChatWidget({this.chatData, this.user, this.responderProfile, this.chatId});

// displays last message details if user is not typing
  Widget userTyping() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('Typing').document(chatId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String isTyping = snapshot.data.data['typing'];
          if (isTyping != null && isTyping.isNotEmpty && isTyping != user.uid) {
            return Text(
              'Typing',
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 14.0,
              ),
            );
          }
        }
        return Expanded(
          child: Text(
            chatData.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        );
      },
    );
  }

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
            userTyping(),
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
