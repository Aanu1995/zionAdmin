import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
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
        Provider(
          create: (context) => _dependecyInjection,
        ),
        Provider(
          create: (context) => User(),
        ),
        ChangeNotifierProvider(
          create: (context) => SplashAppStatus(),
        ),
        ChangeNotifierProvider(create: (context) => _appModel),
        StreamProvider<bool>(
          initialData: false,
          create: (_) => _service.connectionStatusController.stream,
        ),
      ],
      child: widget.child,
    );
  }
}
