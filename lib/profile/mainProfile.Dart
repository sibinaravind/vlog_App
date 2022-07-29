import 'package:blog_app_flutter/Model/ProfileModel.dart';
import 'package:blog_app_flutter/blog/Blogs.dart';
import 'package:flutter/material.dart';
import '../NetworkHandler.Dart';
import '../blog/Blogs.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          )
        ],
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 1.5,
                ),
                otherDetails("About", profileModel.about),
                otherDetails("Name", profileModel.name),
                otherDetails("Profession", profileModel.profession),
                otherDetails("Dob", profileModel.DOB),
                Divider(
                  thickness: 1.5,
                ),
                SizedBox(
                  height: 20,
                ),
                Blogs(
                  url: "/blogPost/getOwnBlog",
                )
              ],
            ),
    );
  }

  Widget head() {
    String username = profileModel.username;
    String titleLine = profileModel.titleline;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(profileModel.username),
              //  onBackgroundImageError: Image.AssetImage("assets/1200px-Google_2015_logo.svg.png"),
            ),
          ),
          Text("$username",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 2,
          ),
          if (titleLine != null)
            Text("$titleLine", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("$label :",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(
            "$value",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
