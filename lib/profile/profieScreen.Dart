import "package:flutter/material.dart";
import 'CreateProfile.Dart';
import '../NetworkHandler.Dart';
import 'mainProfile.Dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetworkHandler networkhandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkhandler.get("/profile/checkProfile");
    print(response);
    if (response["status"] == true) {
      setState(() {
        page = MainProfile();
      });
    } else {
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: page),
    );
  }

  Widget showProfile() {
    MainProfile();
    return Center(child: Text("Aikara"));
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text("Tap to button to add profile data",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 18,
                  )),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateProfie()))
              },
              child: Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text("Add profile",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )),
            )
          ]),
    );
  }
}
