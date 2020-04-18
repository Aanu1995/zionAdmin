import 'package:flutter/material.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class UserWidget extends StatelessWidget {
  final UserProfile userProfile;
  final void Function() onTap;
  final bool isTapped;
  const UserWidget({this.userProfile, this.onTap, this.isTapped = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(60, 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 29.0,
                    child: CustomCircleAvatar(
                      size: 58.0,
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
                Text(
                  userProfile.name,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                EmptySpace(multiple: 0.5),
                Text(
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
