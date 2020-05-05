import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/controller/chat_streams.dart';
import 'package:zion/model/app.dart';
import 'package:zion/provider/createGroupProvider.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/service/connectivity_service.dart';
import 'package:zion/user_inteface/utils/dependency_injection.dart';

class CustomMultiprovider extends StatefulWidget {
  final child;
  const CustomMultiprovider({this.child});

  @override
  _CustomMultiproviderState createState() => _CustomMultiproviderState();
}

class _CustomMultiproviderState extends State<CustomMultiprovider> {
  DependecyInjection _dependecyInjection = DependecyInjection();
  AppModel _appModel = AppModel();
  ConnectivityService _service = ConnectivityService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (context) => _dependecyInjection),
        Provider(create: (context) => User()),
        Provider(create: (_) => CurrentGroupProvider()),
        ChangeNotifierProvider(
          create: (context) => SplashAppStatus(),
        ),
        ChangeNotifierProvider(create: (context) => _appModel),
        ChangeNotifierProvider(create: (context) => CreateGroupProvider()),
        StreamProvider<bool>(
          initialData: false,
          create: (_) => _service.connectionStatusController.stream,
        ),
        StreamProvider<QuerySnapshot>(
          create: (_) => ChatStreams().allChatsStream,
        ),
      ],
      child: widget.child,
    );
  }
}
