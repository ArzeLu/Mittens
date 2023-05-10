import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

///This is the first page users see when they start up the program

class Initialize extends StatefulWidget {
  const Initialize({Key? key}) : super(key: key);

  @override
  State<Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  Color creamYellow = const Color(0xfffffdd0);

  @override
  Widget build(BuildContext context) {
    double topSectionHeight = (MediaQuery.of(context).size.height) * 3 / 4;
    double buttonWidth = MediaQuery.of(context).size.width / 5;
    double buttonHeight = MediaQuery.of(context).size.height / 18;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: creamYellow,
      body: Column(
        children: [
          ///Section of the top image
          Container(
            height: topSectionHeight,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/mittens.jpg'),
                  fit: BoxFit.cover,
                )),
          ),

          ///Section for the Signin Signup buttons
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                          height: 20,
                          child: Text("If you have an account with us already,",
                              style: TextStyle(color: Colors.blueGrey))),
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
                                fontSize: 17,
                              ))),
                      const SizedBox(height: 5),
                      const SizedBox(
                          height: 20,
                          child: Text("Otherwise, please",
                              style: TextStyle(color: Colors.blueGrey))),
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
                                fontSize: 17,
                              )))
                    ],
                  ))),
        ],
      ),
    );
  }
}
