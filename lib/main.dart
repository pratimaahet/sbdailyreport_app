import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sbdailyreport_app/helpers/helper_functions.dart';
import 'package:sbdailyreport_app/pages/auth/login_page.dart';
import 'package:sbdailyreport_app/pages/home_page.dart';
import 'package:sbdailyreport_app/pages/meetings/calender_client.dart';
import 'package:sbdailyreport_app/secrets/secrets.dart';
import 'package:sbdailyreport_app/shared/constants.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var clientID = ClientId(Secret.getId(), "");
  const scopes = [cal.CalendarApi.calendarScope];
  await clientViaUserConsent(clientID, scopes, prompt)
      .then((AuthClient client) async {
    CalendarClient.calendar = cal.CalendarApi(client);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Constants().primaryColor),
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
