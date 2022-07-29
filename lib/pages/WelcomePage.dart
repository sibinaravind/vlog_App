import 'package:flutter/material.dart';
import 'SignUpPage.dart';
import 'SignInPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  //singele ticker provider for animation control
  AnimationController _controller1; // declare animation controller
  Animation<Offset> animation1; // offset is the 2 d point  like x and y
  // AnimationController _controller2;
  // Animation<Offset> animation2;

  @override
  void initState() {
    super.initState();
    // animation1
    _controller1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    // twin is used for starting and ending ponit and which is also used for curved animation
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.bounceOut));
    _controller1.forward();
    // animation2
    // _controller2 = AnimationController(
    //     vsync: this, duration: Duration(milliseconds: 3000));
    // animation2 = Tween<Offset>(
    //   begin: Offset(0.0, 1.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(
    //     CurvedAnimation(parent: _controller2, curve: Curves.easeInOutBack));
    // _controller2.forward();
  }

  @override
  void dispose() {
    //  implement dispose

    _controller1
        .dispose(); // after the contoller use dispose it other wise it will make app hang
    // _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(children: [
              // appling th animation
              SlideTransition(
                position: animation1,
                child: Text(
                  "AikarA",
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Colors.pink),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              SlideTransition(
                position: animation1,
                child: Text(
                  "We are BIG with Big heart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              boxContainer("assets/1200px-Google_2015_logo.svg.png",
                  "Sign Up with Google", null),
              SizedBox(width: 40),
              boxContainer("assets/facebook-logo-png-20.png",
                  "Sign Up with Facebook", null),
              SizedBox(width: 40),
              boxContainer(
                "assets/gmail_logo_PNG12.png",
                "Sign Up with Email",
                onEmailClick,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have account?",
                    style: TextStyle(color: Colors.indigo[600], fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      ));
                    },
                    child: Text(
                      "SignIN",
                      style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ])),
      ),
    ));
  }

  onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpPage(),
    ));
  }

  Widget boxContainer(
      String path, String text, onClick) // creating custom widget
  {
    return InkWell(
      // rectangle area of a Material that responds to touch
      onTap: onClick,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 100,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(children: [
              Image.asset(path, height: 30, width: 30),
              SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
