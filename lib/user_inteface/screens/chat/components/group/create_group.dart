import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zion/controller/chat_streams.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/shimmer.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/user_widget.dart';

class CreateGroupChat extends StatelessWidget {
  List list = [];
  @override
  Widget build(BuildContext context) {
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
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView(
                padding: const EdgeInsets.all(0.0),
                children: list
                    .map((f) => UserWidget(
                        userProfile: UserProfile.fromMap(map: f.data)))
                    .toList(),
              ),
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
