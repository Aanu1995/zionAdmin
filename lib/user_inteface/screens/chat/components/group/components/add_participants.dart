import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/controller/chat_streams.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/components/custom_bottomsheets.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/user_widget.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class AddParticipants extends StatefulWidget {
  final List<UserProfile> groupMembers;
  final Group group;
  const AddParticipants({this.groupMembers, this.group});
  @override
  _AddParticipantsState createState() => _AddParticipantsState();
}

class _AddParticipantsState extends State<AddParticipants> {
  List list = [];
  List _selectedParticipants = [];

  @override
  void initState() {
    super.initState();
  }

  // add participants to the group
  addParticipant(UserProfile profile) {
    if (_selectedParticipants.contains(profile)) {
      _selectedParticipants.remove(profile);
    } else {
      _selectedParticipants.add(profile);
    }
    setState(() {});
  }

  // checks if partcipant has been added
  bool checkAddedStatus(UserProfile profile) {
    if (_selectedParticipants.contains(profile)) {
      return true;
    } else {
      return false;
    }
  }

  void emptyList() {
    _selectedParticipants.clear();
    setState(() {});
  }

  bool checkGroupAddedStatus(UserProfile profile) {
    if (widget.groupMembers.contains(profile)) {
      print('true');
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Participants"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ChatStreams().allUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data.documents;
            return Column(
              children: [
                if (_selectedParticipants.length > 0)
                  Container(
                    width: double.maxFinite,
                    height: 100.0,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0)
                        .add(const EdgeInsets.only(top: 16.0)),
                    child: ListView.builder(
                      itemCount: _selectedParticipants.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final user = _selectedParticipants[index];
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
                          onTap: () => addParticipant(user),
                        );
                      },
                    ),
                  ),
                if (_selectedParticipants.length > 0) Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final userProfile =
                          UserProfile.fromMap(map: list[index].data);
                      return AbsorbPointer(
                        absorbing: checkGroupAddedStatus(userProfile),
                        child: UserWidget(
                          userProfile: userProfile,
                          onTap: () => addParticipant(userProfile),
                          isTapped: checkAddedStatus(userProfile),
                          isAdded: checkGroupAddedStatus(userProfile),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return ShimmerLoadingList();
        },
      ),
      floatingActionButton: _selectedParticipants.length > 0
          ? FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: addParticipants,
            )
          : Offstage(),
    );
  }

// takes user to the add subject page when clicked
  void addParticipants() async {
    CustomDialogs.showProgressDialog(context, text: "Adding participants");
    bool connectionStatus = await DataConnectionChecker().hasConnection;
    if (!connectionStatus) {
      CustomDialogs.closeProgressDialog(context);
      CustomButtomSheets.showConnectionError(context);
      return;
    }
    final result = await GroupChatService.addParticipants(
        widget.group, _selectedParticipants);
    CustomDialogs.closeProgressDialog(context);
    if (result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return;
    }
    // shows error message if login failed
    CustomDialogs.showErroDialog(context, 'Group could not be created');
    return;
  }
}
