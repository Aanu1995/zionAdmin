import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/components/custom_bottomsheets.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class FullImage extends StatelessWidget {
  final String hero;
  final String imageUrl;
  const FullImage({this.hero, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: SizedBox.expand(
        child: Hero(
          tag: hero,
          child: Material(
            color: Colors.black87,
            child: imageUrl.isEmpty
                ? Image.asset(ImageUtils.defaultProfile)
                : PhotoView.customChild(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, value) {
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class GroupFullIcon extends StatelessWidget {
  static File _imageFile;
  static Group group;

  @override
  Widget build(BuildContext context) {
    group = Provider.of<CurrentGroupProvider>(context, listen: false).getGroup;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Group icon'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onPressed(context),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Material(
          color: Colors.black87,
          child: Center(
            child: group.groupIcon.isEmpty
                ? Image.asset(ImageUtils.defaultProfile)
                : CachedNetworkImage(
                    imageUrl: group.groupIcon,
                    fit: BoxFit.contain,
                    placeholder: (context, value) {
                      return CircularProgressIndicator();
                    },
                  ),
          ),
        ),
      ),
    );
  }

  void onPressed(BuildContext context) async {
    _imageFile = null;
    var result = await CustomButtomSheets.imagePickerOptions(context);
    print(result);
    switch (result) {
      case 1:
        await deleteProfileImage(context);
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
      uploadImage(context);
    }
  }

  // upload image to the server
  void uploadImage(BuildContext context) async {
    if (_imageFile != null) {
      CustomDialogs.showProgressDialog(context, text: 'Updating group icon');
      bool connectionStatus = await DataConnectionChecker().hasConnection;
      if (!connectionStatus) {
        CustomButtomSheets.showConnectionError(context);
        return;
      }
      String url =
          await GroupChatService.updateGroupIcon(context, group.id, _imageFile);
      CustomDialogs.closeProgressDialog(context);
      if (url == FirebaseUtils.error) {
        Fluttertoast.showToast(
          msg: "Group icon could not be updated",
          gravity: ToastGravity.CENTER,
        );
        return;
      }
      Navigator.pop(context);
    }
  }

  deleteProfileImage(BuildContext context) async {
    CustomDialogs.showProgressDialog(context, text: 'Updating group icon');
    bool connectionStatus = await DataConnectionChecker().hasConnection;
    if (!connectionStatus) {
      CustomDialogs.closeProgressDialog(context);
      CustomButtomSheets.showConnectionError(context);
      return;
    }
    String url = await GroupChatService.deleteGroupIcon(context, group.id);
    CustomDialogs.closeProgressDialog(context);
    if (url == FirebaseUtils.error) {
      Fluttertoast.showToast(
        msg: "Group icon could not be updated",
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    Navigator.pop(context);
  }
}
