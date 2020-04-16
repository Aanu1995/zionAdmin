import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/service/notification_service.dart';
import 'package:zion/user_inteface/screens/home/components/notification_icon.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService notificationService;
  @override
  void initState() {
    super.initState();
    notificationService =
        Provider.of<DependecyInjection>(context, listen: false).service;
    notificationService.unreadMessagesCount();
  }

  @override
  void dispose() {
    notificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Screen"),
        actions: <Widget>[NotificationIcon()],
      ),
      body: Container(),
    );
  }
}
