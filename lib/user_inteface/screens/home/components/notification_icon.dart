import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/user_inteface/screens/home/notification_page.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';

class NotificationIcon extends StatefulWidget {
  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    final notificationService =
        Provider.of<DependecyInjection>(context, listen: false).service;
    final appContext = Theme.of(context);
    return StreamBuilder<int>(
      stream: notificationService.countController.stream,
      initialData: 0,
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                pushDynamicScreen(
                  context,
                  screen: MaterialPageRoute(
                      builder: (context) => NotificationPage()),
                  platformSpecific: true,
                  withNavBar: false,
                );
              },
            ),
            snapshot.data > 0
                ? Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: appContext.brightness == Brightness.light
                            ? Colors.redAccent
                            : ColorUtils.darkThemeBlueColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${snapshot.data}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Offstage()
          ],
        );
      },
    );
  }
}
