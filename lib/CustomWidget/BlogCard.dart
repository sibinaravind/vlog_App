import 'dart:ffi';
import 'dart:io';

import 'package:blog_app_flutter/Model/addBlogModels.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import '../NetworkHandler.Dart';

class BlogCard extends StatelessWidget {
  const BlogCard({Key key, this.addBlogModels, this.networkHandler})
      : super(
            key:
                key); // accessing image file value whoch is passed from the previous page

  final AddBlogModel addBlogModels;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shadowColor: Colors.black,
            color: Colors.grey,
            elevation: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: networkHandler.getImage(addBlogModels.id),
                          fit: BoxFit.fitWidth)),
                ),
                Positioned(
                    bottom: 2,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(addBlogModels.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    )),
              ],
            ),
          ),
        ));
  }
}
