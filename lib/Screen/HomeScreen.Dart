import "package:flutter/material.dart";
import '../blog/Blogs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: ListView(children: <Widget>[
            Blogs(
              url: "/blogPost/getOtherBlog",
            ),
          ]),
        ));
  }
}
