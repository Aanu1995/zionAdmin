import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/user_inteface/screens/chat/components/full_image.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/add_participants.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/edit_subject.dart';
import 'package:zion/user_inteface/utils/device_scale/flutter_scale_aware.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class GroupDetails extends StatelessWidget {
  final String userId;
  const GroupDetails({this.userId});

  static List<UserProfile> _groupMembers = [];
  static Group group;

  @override
  Widget build(BuildContext context) {
    group = Provider.of<CurrentGroupProvider>(context).getGroup;
    // computes time that the group was created
    String createdAt = DateFormat.yMd()
        .format(DateTime.fromMillisecondsSinceEpoch(group.createdAt));
    // creates an accent color
    final accentColor = Theme.of(context).accentColor;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: InkWell(
                child: FlexibleSpaceBar(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        group.name,
                      ),
                      Text(
                        'Created on $createdAt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  background: group.groupIcon.isEmpty
                      ? Image.asset(ImageUtils.defaultProfile)
                      : CachedNetworkImage(
                          imageUrl: group.groupIcon,
                          fit: BoxFit.cover,
                        ),
                ),
                onTap: () => _fullImage(context),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editSubject(context, group.name),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  onPressed: () => _addParticipants(context),
                ),
              ],
            ),
          ];
        },
        body: FutureBuilder<List<UserProfile>>(
          future: GroupChatService.getMembersListFromLocal(group.id),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              _groupMembers = snapshot.data; // -----
              return ListView(
                padding: EdgeInsets.all(0.0),
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
                              color: accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (userId == group.adminId)
                          Column(children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: accentColor,
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
                              onTap: () => _addParticipants(context),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Divider(),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: accentColor,
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
                                    vertical: 2.0, horizontal: 16.0),
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
      ),
    );
  }

  void _addParticipants(BuildContext context) {
    pushDynamicScreen(
      context,
      screen: MaterialPageRoute(
        builder: (context) => AddParticipants(
          groupMembers: _groupMembers,
          group: group,
        ),
      ),
      platformSpecific: true,
      withNavBar: false,
    );
  }

  void _editSubject(BuildContext context, String subject) {
    pushDynamicScreen(
      context,
      screen:
          MaterialPageRoute(builder: (context) => EditSubject(group: group)),
      platformSpecific: true,
      withNavBar: false,
    );
  }

  void _fullImage(BuildContext context) {
    pushDynamicScreen(
      context,
      screen: MaterialPageRoute(builder: (context) => GroupFullIcon()),
      platformSpecific: true,
      withNavBar: false,
    );
  }
}
