import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/components/custom_bottomsheets.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';
import 'package:zion/user_inteface/utils/device_scale/flutter_scale_aware.dart';

class AddSubject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final participants =
        Provider.of<CreateGroupProvider>(context, listen: false).getList;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Group"),
            SizedBox(height: 4.0),
            Text(
              "Add subjects",
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddSubjectField(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Participants: ${participants.length}",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Wrap(
                    children: participants.map((parts) {
                      return Container(
                        height: 100.0,
                        width: 80.0,
                        margin: EdgeInsets.only(right: 12.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 29.0,
                              backgroundColor: Colors.grey,
                              child: CustomCircleAvatar(
                                size: 70.0,
                                profileURL: parts.profileURL,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              parts.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AddSubjectField extends StatefulWidget {
  @override
  _AddSubjectFieldState createState() => _AddSubjectFieldState();
}

class _AddSubjectFieldState extends State<AddSubjectField> {
  File _imageFile;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      width: double.maxFinite,
      child: Stack(
        children: <Widget>[
          Container(
            height: 120.0,
            width: double.maxFinite,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      splashColor: Colors.grey,
                      child: CircleAvatar(
                        radius: context.scale(25.0),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(context.scale(100.0)),
                                child: Image.file(_imageFile),
                              )
                            : Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                        backgroundColor: Colors.grey[300],
                      ),
                      onTap: pickImage,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          hintText: "Type a group subject here...",
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Provide a group subject and optional group icon",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 0.0,
            child: FloatingActionButton(
              child: Icon(Icons.done, size: 30.0),
              onPressed: createGroup,
            ),
          )
        ],
      ),
    );
  }

  void pickImage() async {
    _imageFile = null;
    final result = await CustomButtomSheets.imagePickerOptions(
      context,
      showDelete: false,
      title: 'Group Icon',
    );
    switch (result) {
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
      setState(() {});
    }
  }

  // takes user to the add subject page when clicked
  void createGroup() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hides keyboard
    FocusScope.of(context).unfocus();
    final message = 'Provide a group subject and optional group icon';
    if (_controller.text.isNotEmpty) {
      CustomDialogs.showProgressDialog(context);
      bool connectionStatus = await DataConnectionChecker().hasConnection;
      if (!connectionStatus) {
        CustomDialogs.closeProgressDialog(context);
        CustomButtomSheets.showConnectionError(context);
        return;
      }
      final String groupName = _controller.text.trim().toString();
      final participants = [
        Provider.of<UserProvider>(context).userProfile,
        ...Provider.of<CreateGroupProvider>(context, listen: false).getList
      ];

      final result = await GroupChatService.createGroup(
        groupName,
        participants,
        file: _imageFile,
        adminId: Provider.of<UserProvider>(context).userProfile.id,
      );
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
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
    );
  }
}
