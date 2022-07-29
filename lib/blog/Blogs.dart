import 'package:blog_app_flutter/CustomWidget/BlogCard.dart';
import 'package:blog_app_flutter/Model/addBlogModels.dart';
import 'package:blog_app_flutter/Model/superModel.dart';
import 'package:blog_app_flutter/blog/addBlog.dart';
import "package:flutter/material.dart";
import '../NetworkHandler.Dart';
import '../CustomWidget/BlogCard.dart';
import 'package:blog_app_flutter/blog/SingleBlog.Dart';

class Blogs extends StatefulWidget {
  Blogs({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data =
      []; // initilaizing empty array to not show error if not have any elemnts

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler
        .get(widget.url); // widget.url is used to access data through given url
    print(response);
    superModel = SuperModel.fromJson(response);
    print(superModel.data);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => InkWell(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleBlog()))
                      },
                      child: BlogCard(
                        addBlogModels: item,
                        networkHandler: networkHandler,
                      ),
                    ))
                .toList(),
          )
        : Center(
            child: Text("We dont have any BLog yet "),
          );
  } //data.map is used to map the values in the data table as newsfeed
}

class Blog {}
