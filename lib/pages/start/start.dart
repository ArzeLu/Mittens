import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

///This is the first page users see when they start up the program

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final _hermesOrange = const Color(0xfff37021);

  @override
  Widget build(BuildContext context) {
    double topSectionHeight = (MediaQuery.of(context).size.height) / 4;
    double buttonWidth = MediaQuery.of(context).size.width / 3;
    double buttonHeight = MediaQuery.of(context).size.height / 20;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //title of the app
          //the bunch of code here is just for styling:
          //putting a text on the bottom side of a color block that takes up about half of the screen
          Container(
              padding: const EdgeInsetsDirectional.only(bottom: 30.0),
              height: MediaQuery.of(context).size.height * 1.2 / 3,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xfffbbb62),
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Mittens',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 60,
                            fontWeight: FontWeight.w600)),
                    Text("Build an everlasting love!", style: TextStyle(fontSize: 20)),
                  ])),

          const SizedBox(height: 10),

          //Section for the Signin Signup buttons
          Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        fixedSize: Size(buttonWidth, buttonHeight),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
                      },
                      child: const Text("Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ))),
                  const SizedBox(width: 10),
                  const Text('  |  ',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey)),
                  const SizedBox(width: 10),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        fixedSize: Size(buttonWidth, buttonHeight),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text("Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )))
                ],
              )),
          const SizedBox(),

          //Section of the top image
          Expanded(
              child: Container(
            alignment: Alignment.bottomCenter,
            height: topSectionHeight,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/gifs/mitten_bounce.gif'),
              fit: BoxFit.fitWidth,
            )),
          )),
        ],
      ),
    );
  }
}
