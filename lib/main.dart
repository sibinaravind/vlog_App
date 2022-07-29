import 'package:blog_app_flutter/blog/addBlog.dart';
import 'package:flutter/material.dart';
import 'pages/WelcomePage.dart';
import 'package:google_fonts/google_fonts.dart'; // for  text styleing
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pages/homePage.dart';
import 'profile/mainProfile.Dart';
import 'blog/addBlog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await storage.read(
        key:
            "token"); // check the tocken is available or not and go to home page
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: page,
    );
  }
}
