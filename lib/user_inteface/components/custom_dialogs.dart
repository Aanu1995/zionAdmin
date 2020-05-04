import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/screens/chat/components/full_image.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/group_chat_page.dart';
import 'package:zion/user_inteface/screens/chat/components/group/components/group_details.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class CustomDialogs {
  // displays permission dialogs to the user
  static Future permissionDialog({BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notification Permission'),
          content: Text(
            'To continue, turn on device notification in Settings. This is require to notify you of new messages.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.3,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  static showErroDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 16.0, bottom: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Text(
            message,
            style: GoogleFonts.raleway(
              fontSize: 18.0,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

// displays toast messages
  static void displayMessage({String message, Color color, Toast toast}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toast ?? Toast.LENGTH_LONG,
      backgroundColor: color ?? Colors.black.withOpacity(0.7),
      textColor: Colors.white,
    );
  }

// show the snackbar to display message
  static void showSnackBar(final globalKey, final content) {
    globalKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          content,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

// show the dialog for circularprogress indicator
  static showProgressDialog(BuildContext context, {String text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(30.0),
              height: 80.0,
              child: Card(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                    SizedBox(
                      width: 24.0,
                    ),
                    Text(
                      text ?? "Creating Group...",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static showGroupDialog(BuildContext context, Group group, final user) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final accentColor = Theme.of(context).accentColor;
    GroupChatService.getMembersListFromServer(group.id);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            top: height * 0.1,
            left: width * 0.14,
            right: width * 0.14,
            bottom: height * 0.4,
          ),
          child: Card(
            margin: EdgeInsets.all(0.0),
            child: SizedBox(
              height: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: SizedBox.expand(
                      child: InkWell(
                        child: Stack(
                          children: <Widget>[
                            group.groupIcon.isEmpty
                                ? Image.asset(ImageUtils.defaultProfile)
                                : CachedNetworkImage(
                                    imageUrl: group.groupIcon,
                                    fit: BoxFit.cover,
                                  ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          pushDynamicScreen(
                            context,
                            screen: MaterialPageRoute(
                                builder: (context) => GroupFullIcon()),
                            platformSpecific: true,
                            withNavBar: false,
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(height: 0.0),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.message,
                            color: accentColor,
                            size: 30.0,
                          ),
                          onPressed: () {
                            Provider.of<CurrentGroupProvider>(
                              context,
                              listen: false,
                            ).setGroup = group;
                            Navigator.pop(context);
                            pushDynamicScreen(
                              context,
                              screen: MaterialPageRoute(
                                builder: (context) => GroupChatPage(
                                  user: user,
                                ),
                              ),
                              platformSpecific: true,
                              withNavBar: false,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: accentColor,
                            size: 30.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            pushDynamicScreen(
                              context,
                              screen: MaterialPageRoute(
                                builder: (context) =>
                                    GroupDetails(userId: user.id),
                              ),
                              platformSpecific: true,
                              withNavBar: false,
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// close the dialog for circularprogress indicator
  static closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
