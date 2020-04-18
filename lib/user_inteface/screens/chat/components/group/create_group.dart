import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/controller/chat_streams.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/user_widget.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class CreateGroupChat extends StatelessWidget {
  static List list = [];

  @override
  Widget build(BuildContext context) {
    Provider.of<CreateGroupProvider>(context).emptyList();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Group"),
            SizedBox(height: 4.0),
            Text(
              "Add participants",
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ChatStreams().allUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data.documents;
            return Consumer<CreateGroupProvider>(
              builder: (context, groupProvider, child) {
                final partList = groupProvider.groupParticipantList;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      if (partList.length > 0)
                        Container(
                          width: double.maxFinite,
                          height: 100.0,
                          margin: EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: partList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final user = partList[index];
                              return InkWell(
                                child: SizedBox(
                                  width: 60,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox.fromSize(
                                        size: Size(60, 60),
                                        child: Stack(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 29.0,
                                              child: CustomCircleAvatar(
                                                size: 58.0,
                                                profileURL: user.profileURL,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0.0,
                                              right: 0.0,
                                              child: CircleAvatar(
                                                radius: 12.0,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.grey,
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        user.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: groupProvider.addParticipant(user),
                              );
                            },
                          ),
                        ),
                      if (groupProvider.groupParticipantList.length > 0)
                        Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final userProfile =
                                UserProfile.fromMap(map: list[index].data);
                            return UserWidget(
                              userProfile: userProfile,
                              onTap: () =>
                                  groupProvider.addParticipant(userProfile),
                              isTapped:
                                  groupProvider.checkAddedStatus(userProfile),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return ShimmerLoadingList();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {},
      ),
    );
  }
}
