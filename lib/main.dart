import 'dart:async';
import 'package:allnewsatfingertips/Api/Wp_api.dart';
import 'package:allnewsatfingertips/pages/home.dart';
import 'package:allnewsatfingertips/pages/userInterest.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initialization = MobileAds.instance.initialize();
  globals.appNavigator = GlobalKey<NavigatorState>();
  runApp(
    AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.blue,
      ),
      child: ChangeNotifierProvider(
        create: (c) => States(initialization),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<SharedPreferences> _prefs;
  late States states;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
    states = Provider.of<States>(context, listen: false);
    states.getEmail();
    _initOS();
  }

  void _initOS() async {
    OneSignal.shared.setAppId(OSAppID);
    OneSignal.shared.clearOneSignalNotifications();
    states.getSubscription();
  }

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await _prefs;
    if (prefs.getStringList('interest') == null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All News At Fingertips',
      navigatorKey: globals.appNavigator,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: SafeArea(
        child: FutureBuilder<bool>(
            future: _checkFirstTime(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return UserInterest(rout: 'main');
              }
              return Home();
            }),
      ),
    );
  }
}
