import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/device_scale/flutter_scale_aware.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class GroupDetails extends StatelessWidget {
  final Group group;
  final String userId;
  const GroupDetails({this.group, this.userId});
  @override
  Widget build(BuildContext context) {
    String createdAt = DateFormat.yMd()
        .format(DateTime.fromMillisecondsSinceEpoch(group.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: GoogleFonts.abel(fontWeight: FontWeight.bold),
            ),
            Text(
              'Created on $createdAt',
              style:
                  GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<UserProfile>>(
        future: GroupChatService.getMembersListFromLocal(group.id),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16.0),
                        child: Text(
                          '${snapshot.data.length} participants',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (userId == group.adminId)
                        Column(children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              radius: context.scale(22.5),
                              child: Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              "Add Participants",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              radius: context.scale(22.5),
                              child: Icon(
                                Icons.link,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              "Invite via link",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Divider(),
                          ),
                        ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data.map((member) {
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 16.0),
                              leading: CustomCircleAvatar(
                                size: 45.0,
                                profileURL: member.profileURL,
                              ),
                              title: Text(
                                member.id == userId ? 'You' : member.name,
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: group.adminId == member.id
                                  ? Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        'Group Admin',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : Offstage(),
                            );
                          }).toList()),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.pinkAccent,
                    ),
                    title: Text(
                      "Exit group",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
