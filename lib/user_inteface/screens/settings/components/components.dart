import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

// Stream widget that gets stream from backend to the screen
class ProfileStreamData extends StatefulWidget {
  final Widget Function(BuildContext, AsyncSnapshot<UserProfile>) builder;
  ProfileStreamData({this.builder});

  @override
  _ProfileStreamDataState createState() => _ProfileStreamDataState();
}

class _ProfileStreamDataState extends State<ProfileStreamData> {
  UserProfileService userProfileService;
  @override
  void initState() {
    super.initState();
    // calls the function that gets user details data from server
    userProfileService = Provider.of<DependecyInjection>(context, listen: false)
        .userProfileService;
    userProfileService.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile>(
      // user profile stream
      stream: userProfileService.userProfileStreamController.stream,
      // initial data pending the time the data from server is available
      initialData: UserProfileService.initialData,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot);
      },
    );
  }
}

// button for user to select profile image
// buttons such as delete, gallery and camera
class OptionAvartar extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String text;
  final void Function() onTap;
  OptionAvartar({this.backgroundColor, this.icon, this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.24,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 22.0,
                    backgroundColor: backgroundColor,
                  ),
                  Icon(icon, size: 22.0, color: Colors.white),
                ],
              ),
              EmptySpace(multiple: 0.5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

// displays the profile circle avartar
class CustomCircleAvatar extends StatelessWidget {
  final String profileURL;
  final double size;
  final void Function() onPressed;

  CustomCircleAvatar({this.profileURL, this.size, this.onPressed});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).accentColor;
    return size != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              color: Colors.white,
              child: SizedBox(
                  height: size,
                  width: size,
                  child: profileURL.isEmpty
                      ? Image.asset(ImageUtils.defaultProfile)
                      : CachedNetworkImage(imageUrl: profileURL)),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000.0),
                child: Container(
                  color: Colors.white,
                  child: SizedBox(
                    height: 150.0,
                    width: 150.0,
                    child: profileURL.isEmpty
                        ? Image.asset(ImageUtils.defaultProfile)
                        : CachedNetworkImage(imageUrl: profileURL),
                  ),
                ),
              ),
              Positioned(
                right: 0.0,
                bottom: 10.0,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                    ),
                    onPressed: onPressed,
                  ),
                ),
              )
            ],
          );
  }
}
