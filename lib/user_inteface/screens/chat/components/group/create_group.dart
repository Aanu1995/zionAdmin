import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/controller/chat_streams.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:zion/user_inteface/screens/chat/components/group/add_subject_page.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/user_widget.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class CreateGroupChat extends StatefulWidget {
  @override
  _CreateGroupChatState createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  static List list = [];
  CreateGroupProvider _createGroupProvider;
  @override
  void initState() {
    super.initState();
    _createGroupProvider =
        Provider.of<CreateGroupProvider>(context, listen: false);
    _createGroupProvider.emptyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Group"),
            SizedBox(height: 4.0),
            Consumer<CreateGroupProvider>(
              builder: (context, groupProvider, _) {
                final partList = groupProvider.getList.length;
                return Text(
                  partList > 0
                      ? "$partList of ${list.length} selected"
                      : "Add participants",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ChatStreams().allUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data.documents;
            return Consumer<CreateGroupProvider>(
              builder: (context, groupProvider, _) {
                final partList = groupProvider.getList;
                print(partList.length);
                return Column(
                  children: [
                    if (partList.length > 0)
                      Container(
                        width: double.maxFinite,
                        height: 100.0,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0)
                            .add(const EdgeInsets.only(top: 16.0)),
                        child: ListView.builder(
                          itemCount: partList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final user = partList[index];
                            return InkWell(
                              child: Container(
                                width: 60,
                                margin: EdgeInsets.only(right: 16.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox.fromSize(
                                      size: Size(60, 60),
                                      child: Stack(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 29.0,
                                            backgroundColor: Colors.grey,
                                            child: CustomCircleAvatar(
                                              size: 70.0,
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
                                    const SizedBox(height: 4.0),
                                    Text(
                                      user.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => groupProvider.addParticipant(user),
                            );
                          },
                        ),
                      ),
                    if (groupProvider.getList.length > 0) Divider(),
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
                );
              },
            );
          }
          return ShimmerLoadingList();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: navigateToAddSubjectPage,
      ),
    );
  }

// takes user to the add subject page when clicked
  void navigateToAddSubjectPage() {
    bool value = _createGroupProvider.getList.length > 0 ? true : false;
    final message = 'At least 1 participant must be selected';
    if (value) {
      pushDynamicScreen(
        context,
        screen: MaterialPageRoute(
          builder: (context) => AddSubject(),
        ),
        platformSpecific: true,
        withNavBar: false,
      );
      return;
    }
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
  }
}
