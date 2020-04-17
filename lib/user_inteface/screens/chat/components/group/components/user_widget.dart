import 'package:flutter/material.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class UserWidget extends StatelessWidget {
  final UserProfile userProfile;
  const UserWidget({this.userProfile});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 35.0,
        child: CustomCircleAvatar(
          size: 56.0,
          profileURL: userProfile.profileURL,
        ),
      ),
      title: Text(
        userProfile.name,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        userProfile.phoneNumber,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black54,
        ),
      ),
    );
  }
}
