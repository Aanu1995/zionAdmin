import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/service/notification_service.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationService notificationService;
  final random = new Random();

  List<Color> color = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.indigo,
    Colors.pink,
  ];
  @override
  void initState() {
    super.initState();
    notificationService =
        Provider.of<DependecyInjection>(context, listen: false).service;
    notificationService.getNotificationMessages();
  }

  @override
  Widget build(BuildContext context) {
    final notificationService =
        Provider.of<DependecyInjection>(context, listen: false).service;
    final accentColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: StreamBuilder(
        stream: notificationService.notificationStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List list = snapshot.data;
            return Container(
              margin: EdgeInsets.all(16.0),
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return ExpansionTileCard(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: color[random.nextInt(7)],
                      child: Text(
                        "$index",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    title: Container(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        item.title,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.time,
                          style: TextStyle(fontSize: 13.0),
                        ),
                        Text(
                          item.date,
                          style: TextStyle(fontSize: 13.0),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Container(
                        margin: EdgeInsets.all(16.0),
                        child: Text(
                          item.message,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.4,
                          ),
                        ),
                      ),
                      ButtonBar(children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: accentColor,
                          ),
                          onPressed: () {},
                        )
                      ])
                    ],
                  );
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
