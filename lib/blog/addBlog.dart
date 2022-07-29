import 'dart:convert';
import 'package:blog_app_flutter/CustomWidget/OverlayCard.dart';
import 'package:blog_app_flutter/Model/addBlogModels.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:blog_app_flutter/NetworkHandler.dart';
import 'package:blog_app_flutter/pages/HomePage.dart';

class AddBlog extends StatefulWidget {
  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController _title = TextEditingController();
  TextEditingController _blogBody = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();
  NetworkHandler networkhandler = NetworkHandler();
  PickedFile _imageFile;
  IconData iconPhoto =
      Icons.image; // deffine icon image to new variable iconphoto
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_imageFile.path != null &&
                  _globalKey.currentState.validate()) {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) =>
                      OverlayCard(imagefile: _imageFile, title: _title.text)),
                );
              }
            }, // passing the image file value to next page
            child: Text(
              "preview",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[titleTextField(), bodyTextField(), addButton()],
        ),
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value.isEmpty)
            return "title can't be empty";
          else if (value.length > 100) {
            return "title length Should be less than or equal to 100";
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
            labelText: "Add Image and title",
            prefixIcon: IconButton(
              icon: Icon(
                iconPhoto,
                color: Colors.teal,
              ),
              onPressed: () {
                takeCoverPhoto();
              },
            )),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: _blogBody,
        validator: (value) {
          if (value.isEmpty) return "Body can't be empty";
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )),
          labelText: "Provide Body your Blog",
        ),
        maxLines: null,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        if (_imageFile.path != null && _globalKey.currentState.validate()) {
          AddBlogModel addBlogModels =
              AddBlogModel(body: _blogBody.text, title: _title.text);
          var response = await networkhandler.post1(
              "/blogpost/Add", addBlogModels.toJson());
          print(response.body);
          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            var imageResponse = await networkhandler.patchImage(
                "/blogpost/add/coverImage/$id", _imageFile.path);
            if (imageResponse.statusCode == 200 ||
                imageResponse.statusCode == 201) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            }
          }
        }
      },
      child: Center(
          child: Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.teal),
        child: Center(
          child: Text(
            "Add Blog",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      )),
    );
  }

  void takeCoverPhoto() async {
    final coverphoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverphoto;
      iconPhoto = Icons
          .check_box; // after image is select the icon will change to checkbox
    });
  }
}
