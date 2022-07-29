import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";
import 'dart:io';
import '../NetworkHandler.Dart';
import "../pages/homePage.Dart";

class CreateProfie extends StatefulWidget {
  @override
  _CreateProfieState createState() => _CreateProfieState();
}

class _CreateProfieState extends State<CreateProfie> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  PickedFile _imagefile;
  bool _trial = false;
  final _globalKey =
      GlobalKey<FormState>(); // the global key only validater the form widget
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _globalKey, //pass the global key for validation
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            professionTextField(),
            SizedBox(
              height: 20,
            ),
            dobTextField(),
            SizedBox(
              height: 20,
            ),
            titleTextField(),
            SizedBox(
              height: 20,
            ),
            aboutTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalKey.currentState.validate()) {
                  Map<String, String> data = {
                    "name": _name.text,
                    "profession": _profession.text,
                    "DOB": _dob.text,
                    "title": _title.text,
                    "about": _about.text
                  };
                  var response =
                      await networkHandler.post("/profile/add", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    if (_imagefile.path != null) {
                      var imageResponse = await networkHandler.patchImage(
                          "/profile/add/image", _imagefile.path);
                      if (imageResponse.statusCode == 200 ||
                          imageResponse.statusCode == 201) {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
                    }
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text("Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            )
          ]),
    ));
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "choose profile photo",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              SizedBox(
                width: 20,
              ),
              FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagefile = pickedFile;
    });
  }

  Widget imageProfile() {
    //BuildContext context;
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
            radius: 80.0,
            // maxRadius: 80.0,
            backgroundColor: Colors.white70,
            backgroundImage: _imagefile == null
                ? AssetImage("assets/1200px-Google_2015_logo.svg.png")
                : FileImage(File(_imagefile.path))),
        Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => bottomSheet()));
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ))
      ]),
    );
  }

  Widget nameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "name cant be  empty";

          return null;
        },
        controller: _name,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 3)),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.green,
            ),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "Name",
            helperText: "Name cant be empty",
            hintText: "Aikara"));
  }

  Widget professionTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "profession cant be  empty";

          return null;
        },
        controller: _profession,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 3)),
            prefixIcon: Icon(
              Icons.mouse,
              color: Colors.green,
            ),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "Profession",
            helperText: "Profession cant be empty",
            hintText: "IT Profession"));
  }

  Widget dobTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "DOB cant be  empty";

          return null;
        },
        controller: _dob,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 3)),
            prefixIcon: Icon(
              Icons.calendar_today,
              color: Colors.green,
            ),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "Date of Birth",
            helperText: "DOB cant be empty",
            hintText: "12/02/1996"));
  }

  Widget titleTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Title cant be  empty";

          return null;
        },
        controller: _title,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 3)),
            prefixIcon: Icon(
              Icons.title,
              color: Colors.green,
            ),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "Title",
            helperText: "Title cant be empty",
            hintText: "Aikara"));
  }

  Widget aboutTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "About text cant be  empty";

          return null;
        },
        controller: _about,
        maxLines: 4,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 3)),
            prefixIcon: Icon(
              Icons.text_fields,
              color: Colors.green,
            ),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "About",
            helperText: "About cant be empty",
            hintText: "tell something about you"));
  }
}

// import 'package:image_picker/image_picker.dart';
// import "package:flutter/material.dart";
// import 'dart:io';
// import '../NetworkHandler.Dart';
// import "../pages/homePage.Dart";

// class CreatProfile extends StatefulWidget {
//   CreatProfile({Key key}) : super(key: key);

//   @override
//   _CreatProfileState createState() => _CreatProfileState();
// }

// class _CreatProfileState extends State<CreatProfile> {
//   final networkHandler = NetworkHandler();
//   bool circular = false;
//   PickedFile _imageFile;
//   final _globalkey = GlobalKey<FormState>();
//   TextEditingController _name = TextEditingController();
//   TextEditingController _profession = TextEditingController();
//   TextEditingController _dob = TextEditingController();
//   TextEditingController _title = TextEditingController();
//   TextEditingController _about = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _globalkey,
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           children: <Widget>[
//             imageProfile(),
//             SizedBox(
//               height: 20,
//             ),
//             nameTextField(),
//             SizedBox(
//               height: 20,
//             ),
//             professionTextField(),
//             SizedBox(
//               height: 20,
//             ),
//             dobField(),
//             SizedBox(
//               height: 20,
//             ),
//             titleTextField(),
//             SizedBox(
//               height: 20,
//             ),
//             aboutTextField(),
//             SizedBox(
//               height: 20,
//             ),
//             InkWell(
//               onTap: () async {
//                 setState(() {
//                   circular = true;
//                 });
//                 if (_globalkey.currentState.validate()) {
//                   Map<String, String> data = {
//                     "name": _name.text,
//                     "profession": _profession.text,
//                     "dob": _dob.text,
//                     "title": _title.text,
//                     "about": _about.text,
//                   };
//                   var response =
//                       await networkHandler.post("/profile/add", data);
//                   if (response.statusCode == 200 ||
//                       response.statusCode == 201) {
//                     if (_imageFile.path != null) {
//                       var imageResponse = await networkHandler.patchImage(
//                           "/profile/add/image", _imageFile.path);
//                       if (imageResponse.statusCode == 200) {
//                         setState(() {
//                           circular = false;
//                         });
//                         Navigator.of(context).pushAndRemoveUntil(
//                             MaterialPageRoute(builder: (context) => HomePage()),
//                             (route) => false);
//                       }
//                     } else {
//                       setState(() {
//                         circular = false;
//                       });
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (context) => HomePage()),
//                           (route) => false);
//                     }
//                   }
//                 }
//               },
//               child: Center(
//                 child: Container(
//                   width: 200,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.teal,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(
//                     child: circular
//                         ? CircularProgressIndicator()
//                         : Text(
//                             "Submit",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget imageProfile() {
//     return Center(
//       child: Stack(children: <Widget>[
//         CircleAvatar(
//           radius: 80.0,
//           backgroundImage: _imageFile == null
//               ? AssetImage("assets/profile.jpeg")
//               : FileImage(File(_imageFile.path)),
//         ),
//         Positioned(
//           bottom: 20.0,
//           right: 20.0,
//           child: InkWell(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: ((builder) => bottomSheet()),
//               );
//             },
//             child: Icon(
//               Icons.camera_alt,
//               color: Colors.teal,
//               size: 28.0,
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget bottomSheet() {
//     return Container(
//       height: 100.0,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 20,
//       ),
//       child: Column(
//         children: <Widget>[
//           Text(
//             "Choose Profile photo",
//             style: TextStyle(
//               fontSize: 20.0,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//             FlatButton.icon(
//               icon: Icon(Icons.camera),
//               onPressed: () {
//                 takePhoto(ImageSource.camera);
//               },
//               label: Text("Camera"),
//             ),
//             FlatButton.icon(
//               icon: Icon(Icons.image),
//               onPressed: () {
//                 takePhoto(ImageSource.gallery);
//               },
//               label: Text("Gallery"),
//             ),
//           ])
//         ],
//       ),
//     );
//   }

//   void takePhoto(ImageSource source) async {
//     final pickedFile = await _picker.getImage(
//       source: source,
//     );
//     setState(() {
//       _imageFile = pickedFile;
//     });
//   }

//   Widget nameTextField() {
//     return TextFormField(
//       controller: _name,
//       validator: (value) {
//         if (value.isEmpty) return "Name can't be empty";

//         return null;
//       },
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.teal,
//         )),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.orange,
//           width: 2,
//         )),
//         prefixIcon: Icon(
//           Icons.person,
//           color: Colors.green,
//         ),
//         labelText: "Name",
//         helperText: "Name can't be empty",
//         hintText: "Dev Stack",
//       ),
//     );
//   }

//   Widget professionTextField() {
//     return TextFormField(
//       controller: _profession,
//       validator: (value) {
//         if (value.isEmpty) return "Profession can't be empty";

//         return null;
//       },
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.teal,
//         )),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.orange,
//           width: 2,
//         )),
//         prefixIcon: Icon(
//           Icons.person,
//           color: Colors.green,
//         ),
//         labelText: "Profession",
//         helperText: "Profession can't be empty",
//         hintText: "Full Stack Developer",
//       ),
//     );
//   }

//   Widget dobField() {
//     return TextFormField(
//       controller: _dob,
//       validator: (value) {
//         if (value.isEmpty) return "DOB can't be empty";

//         return null;
//       },
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.teal,
//         )),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.orange,
//           width: 2,
//         )),
//         prefixIcon: Icon(
//           Icons.person,
//           color: Colors.green,
//         ),
//         labelText: "Date Of Birth",
//         helperText: "Provide DOB on dd/mm/yyyy",
//         hintText: "01/01/2020",
//       ),
//     );
//   }

//   Widget titleTextField() {
//     return TextFormField(
//       controller: _title,
//       validator: (value) {
//         if (value.isEmpty) return "Title can't be empty";

//         return null;
//       },
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.teal,
//         )),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.orange,
//           width: 2,
//         )),
//         prefixIcon: Icon(
//           Icons.person,
//           color: Colors.green,
//         ),
//         labelText: "Title",
//         helperText: "It can't be empty",
//         hintText: "Flutter Developer",
//       ),
//     );
//   }

//   Widget aboutTextField() {
//     return TextFormField(
//       controller: _about,
//       validator: (value) {
//         if (value.isEmpty) return "About can't be empty";

//         return null;
//       },
//       maxLines: 4,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.teal,
//         )),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//           color: Colors.orange,
//           width: 2,
//         )),
//         labelText: "About",
//         helperText: "Write about yourself",
//         hintText: "I am Dev Stack",
//       ),
//     );
//   }
// }
