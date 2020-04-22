import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/user_inteface/components/custom_bottomsheets.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class ProfilePage extends StatefulWidget {
  final profileURL;
  ProfilePage({this.profileURL});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _imageFile;
  bool isLoading = false;

  String profileURL;

  UserProfileService userProfileService;

  @override
  void initState() {
    super.initState();
    profileURL = widget.profileURL;
  }

  @override
  Widget build(BuildContext context) {
    userProfileService = Provider.of<DependecyInjection>(context, listen: false)
        .userProfileService;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Hero(
        tag: 'profile',
        child: Material(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomCircleAvatar(
                  profileURL: profileURL,
                  onPressed: onPressed,
                ),
                if (isLoading)
                  SizedBox(
                    height: 35.0,
                    width: 35.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressed() async {
    _imageFile = null;
    var result = await CustomButtomSheets.imagePickerOptions(context);
    print(result);
    switch (result) {
      case 1:
        await deleteProfileImage();
        break;
      case 2:
        _imageFile = await ImageUtils.pickImageFromGallery(context);
        break;
      case 3:
        _imageFile = await ImageUtils.pickImageUsingCamera(context);
        break;
      default:
        print("bottom sheet close");
    }
    if (_imageFile != null) {
      uploadImage();
    }
  }

  deleteProfileImage() async {
    bool connectionStatus = await DataConnectionChecker().hasConnection;
    if (!connectionStatus) {
      CustomButtomSheets.showConnectionError(context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    String url = await userProfileService.deleteProfileImage();
    if (url != FirebaseUtils.error) {
      profileURL = url;
    } else {
      CustomDialogs.showErroDialog(context, url);
    }
    setState(() {
      isLoading = false;
    });
  }

  // upload image to the server
  void uploadImage() async {
    if (_imageFile != null) {
      bool connectionStatus = await DataConnectionChecker().hasConnection;
      if (!connectionStatus) {
        CustomButtomSheets.showConnectionError(context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      String url = await userProfileService.uploadImage(_imageFile);
      if (url != FirebaseUtils.error) {
        profileURL = url;
      } else {
        CustomDialogs.showErroDialog(context, url);
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
