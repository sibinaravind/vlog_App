import 'dart:convert';
import "package:flutter/material.dart";
import 'SignUpPage.dart';
import 'HomePage.dart';
import '../NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage =
      new FlutterSecureStorage(); // creating instance for secure storage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green[200]],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Form(
          key: _globalkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.teal[900]),
                ),
                SizedBox(
                  height: 20,
                ),
                usernameTextField(),
                SizedBox(
                  height: 15,
                ),
                passwordTextField(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        "New User?",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                      print(circular);
                    });
                    // print("hsiii");
                    // if (_globalkey.currentState.validate()) {
                    //   Scaffold.of(context).showSnackBar(
                    //       SnackBar(content: Text("Please Fill the Fileds")));
                    //   setState(() {
                    //     circular = false;
                    //     validate = false;
                    //   });
                    // }
                    // print("hsiii");
                    //Login Logic start here
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "password": _passwordController.text,
                    };
                    var response = await networkHandler.post(
                        "/user/login/${_usernameController.text}", data);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      print(output["token"]);
                      await storage.write(key: "token", value: output["token"]);
                      // storing the tocken on the secure storage with any key and give value a token
                      setState(() {
                        validate = true;
                        circular = false;
                      });
                      // pushAndRemoveUntil will remove all the previous login page and sign up pages
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    } else {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("can't login")));
                      String output = json.decode(response.body);
                      setState(() {
                        validate = false;
                        errorText = output;
                        circular = false;
                      });
                    }

                    // login logic End here
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff00A86B),
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white70,
                            )
                          : Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                // Divider(
                //   height: 50,
                //   thickness: 1.5,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameTextField() {
    return Column(
      children: [
        Text("Username"),
        TextFormField(
          controller: _usernameController,
          validator: (value) {
            if (value.isEmpty) return "UserName can't be empty";
            return null;
          },
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      children: [
        Text("Password"),
        TextFormField(
          controller: _passwordController,
          validator: (value) {
            if (value.isEmpty) return "Password can't be empty";
            return null;
          },
          obscureText: vis,
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              },
            ),
            helperStyle: TextStyle(
              fontSize: 14,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        )
      ],
    );
  }
}
