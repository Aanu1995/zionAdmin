import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
import 'package:zion/router/router.dart';
import 'package:zion/user_inteface/components/custom_multiprovider.dart';
import 'package:zion/user_inteface/screens/authentication/login_page.dart';
import 'package:zion/user_inteface/screens/default_page.dart';
import 'package:zion/user_inteface/screens/splash_page.dart';
import 'package:zion/user_inteface/utils/device_scale/flutter_scale_aware.dart';
import 'package:zion/user_inteface/utils/global_data_utils.dart';
import 'package:zion/user_inteface/utils/theme_utils.dart';

// our application starts running here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(CustomMultiprovider(child: MyApp()));
}

init() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive..init(appDocumentDir.path);
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // by default the user has not been authenticated
  // user will be taken to login screen
  Widget page = LoginPage();

  @override
  void initState() {
    super.initState();
    // One signal initialization
    initPlatformState();
    // has user logged in or not
    authenticationStatus();
  }

  // intializes the function for one signal notification
  Future<void> initPlatformState() async {
    if (!mounted) return;

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    OneSignal.shared.setRequiresUserPrivacyConsent(requiresConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    // initialize one signal in the app
    await OneSignal.shared.init(GlobalDataUtils.appId, iOSSettings: settings);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  // checks if user has been authenticated
  void authenticationStatus() async {
    // takes user to home page if authenticated else login page
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      page = DefaultPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Consumer<SplashAppStatus>(
      builder: (context, status, _) {
        if (status.isLoading) {
          return MaterialApp(
            title: 'Zion Auto Diagnosis',
            debugShowCheckedModeBanner: false,
            home: SplashPage(), // defines the routes of the application
          );
        } else {
          return Consumer<AppModel>(
            builder: (context, app, _) {
              return ScaleAware(
                config: ScaleConfig(),
                child: MaterialApp(
                  title: 'Zion Auto Diagnosis',
                  theme: app.darkTheme
                      ? ThemeUtils.buildDarkTheme()
                      : ThemeUtils.buildLightTheme(),
                  debugShowCheckedModeBanner: false,
                  home: page,
                  routes:
                      Routes.getroutes, // defines the routes of the application
                ),
              );
            },
          );
        }
      },
    );
  }
}
