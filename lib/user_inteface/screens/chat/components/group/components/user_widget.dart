import 'package:flutter/material.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class UserWidget extends StatelessWidget {
  final UserProfile userProfile;
  final void Function() onTap;
  final bool isTapped;
  final bool isAdded;
  const UserWidget(
      {this.userProfile,
      this.onTap,
      this.isTapped = false,
      this.isAdded = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0)
            .add(const EdgeInsets.only(top: 16.0)),
        child: Row(
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
                      profileURL: userProfile.profileURL,
                    ),
                  ),
                  if (isTapped)
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            EmptySpace(horizontal: true, multiple: 2.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isAdded
                    ? Text(
                        userProfile.name,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        userProfile.name,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                EmptySpace(multiple: 0.5),
                isAdded
                    ? Text(
                        'Already added to the group',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Text(
                        userProfile.phoneNumber,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.black54,
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
