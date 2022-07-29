import 'package:blog_app_flutter/blog/addBlog.dart';
import 'package:blog_app_flutter/pages/WelcomePage.dart';
import "package:flutter/material.dart";
import '../Screen/HomeScreen.dart';
import '../profile/profieScreen.dart';
import '../profile/mainProfile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../blog/addBlog.dart';
import 'package:blog_app_flutter/NetworkHandler.Dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkHandler networkhandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  final storage = FlutterSecureStorage();
  String username = "";
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  // creating dynamic widget
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
        color: Colors.black87, borderRadius: BorderRadius.circular(50)),
  );

  void checkProfile() async {
    var response = await networkhandler.get("/profile/checkProfile");
    if (response["status"] == true) {
      setState(() {
        username = response['username'];
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      profilePhoto = Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(50)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 100,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Column(children: <Widget>[
              SizedBox(height: 10),
              profilePhoto,
              Text(
                "@$username",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ])),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: Text("New Story"),
              trailing: Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
                title: Text("Setting"),
                trailing: Icon(Icons.settings),
                onTap: () {}),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: () {
                logout();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Icon(Icons.add, size: 40),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.teal[300],
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.home),
                      color: currentState == 0 ? Colors.white : Colors.white54,
                      onPressed: () {
                        setState(() {
                          currentState = 0;
                        });
                      },
                      iconSize: 40),
                  IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        setState(() {
                          currentState = 1;
                        });
                      },
                      color: currentState == 1 ? Colors.white : Colors.white54,
                      iconSize: 40)
                ],
              ),
            ),
          )),
      body: widgets[currentState],
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
        (route) => false);
  }
}
