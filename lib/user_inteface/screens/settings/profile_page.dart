import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/user_inteface/components/custom_bottomsheets.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

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

  // crop images after picking the image from the source
  Future<File> cropImage(File imageFile) async {
    final primaryColor = Theme.of(context).primaryColor;
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).accentColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
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
    var result = await CustomButtomSheets.imagePickerOptions(context);
    print(result);
    switch (result) {
      case 1:
        await deleteProfileImage();
        break;
      case 2:
        await pickImageFromGallery();
        break;
      case 3:
        await pickImageUsingCamera();
        break;
      default:
        print("bottom sheet close");
    }
  }

  pickImageFromGallery() async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      final croppedImage = await cropImage(image);
      _imageFile = croppedImage;
    }
    uploadImage();
  }

  pickImageUsingCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      final croppedImage = await cropImage(image);
      _imageFile = croppedImage;
    }
    uploadImage();
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
