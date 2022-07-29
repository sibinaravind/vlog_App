import 'package:flutter/material.dart';
import '../NetworkHandler.Dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler =
      NetworkHandler(); // creating instance of the network handler
  TextEditingController _usernameController =
      TextEditingController(); // to access the value from the text field
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, Colors.green[400]],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          )),
          child: Form(
            key: _globalkey, // to check the validation of all the field
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign Up with Email",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                userNameTextField(),
                emailTextField(),
                passwordTextField(),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    await checkUser();
                    if (_globalkey.currentState.validate() && validate) {
                      Map<String, String> data = {
                        "username": _usernameController.text,
                        "email": _emailController.text,
                        "password": _passwordController.text,
                      }; //  Map<String, String>  converting the data as string

                      await networkHandler.post("/user/register", data);
                      setState(() {
                        circular = false;
                      });
                    } else {
                      setState(() {
                        circular = false;
                      });
                    }
                  },
                  child: circular
                      ? CircularProgressIndicator()
                      : Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff00A86B)),
                          child: Center(
                            child: Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )),
                ),
              ],
            ),
          )),
    ));
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        // circular = false;
        validate = false;
        errorText = "username can't be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${_usernameController.text}");
      if (response['status']) {
        setState(() {
          //   circular = true;
          validate = false;
          errorText = "username alreday taken";
        });
      } else {
        setState(() {
          validate = true;
        });
      }
    }
  }

  Widget userNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: <Widget>[
          Text(
            "Username",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          TextFormField(
            controller:
                _usernameController, // accessinhg the text field controller
            decoration: InputDecoration(
                errorText: validate ? null : errorText,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2))),
          )
        ],
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return "Email can't be empty";
              if ((!value.contains("@")) || (!value.contains(".")))
                return "Invalid Email id";
              return null;
            },
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2))),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: <Widget>[
          Text(
            "Password",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value.isEmpty) return "Password can't be empty";
              if (value.length < 8)
                return "Password not be less than 8 character";
              return null;
            },
            obscureText: vis, // for password Field ...
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        vis = !vis;
                      }); // to view password
                    }), // to set visibility off
                helperText:
                    "Password must be  greater than or equals to 8 character",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2))),
          )
        ],
      ),
    );
  }
}
