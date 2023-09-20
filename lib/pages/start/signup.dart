import 'package:flutter/material.dart';
import '../../services/authentication.dart';

///Two sign in methods: traditional manual, google
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _hermesOrange = const Color(0xfff37021);
  final _blue = const Color(0xff3cccff);
  final _lightGrey = const Color(0xfff2f2f2);
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  bool hidePasswordInput = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.yellowAccent),
          toolbarHeight: 50,
          backgroundColor: _hermesOrange,
        ),
        body: Container(
            //wrapping everything with a container just to set a background color feelsbadman
            color: Colors.white,
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 30.0),
                  child: Column(children: [
                    ///Form for a traditional email password sign in
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text('~Sign Up~',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30)),
                          const SizedBox(height: 25),
                          const Text(
                              '       We\'ll make sure you and your\nspecial loved one can find each other!',
                              style: TextStyle(fontSize: 17)),
                          const SizedBox(height: 50),

                          ///Email input field
                          TextFormField(
                            decoration: InputDecoration(
                                icon: const Icon(Icons.email, color: Colors.lightBlue),
                                hintText: "someone@example.com",
                                hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: _lightGrey),
                            style: const TextStyle(fontSize: 15),
                            //validator: (value) {},
                            onChanged: (value) => email = value,
                          ),
                          const SizedBox(height: 20),

                          ///Password input field
                          TextFormField(
                            decoration: InputDecoration(
                              icon: const Icon(Icons.password, color: Colors.lightBlue),
                              filled: true,
                              fillColor: _lightGrey,
                              suffixIcon: hidePasswordInput
                                  ? IconButton(
                                      icon: const Icon(
                                          Icons.remove_red_eye_outlined),
                                      onPressed: () => setState(() {
                                        hidePasswordInput = false;
                                      }),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.remove_red_eye),
                                      onPressed: () => setState(() {
                                        hidePasswordInput = true;
                                      }),
                                    ),
                              hintText: 'password',
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: const TextStyle(fontSize: 15),
                            obscureText: hidePasswordInput,
                            //validator: (value) {},
                            onChanged: (value) => password = value,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    ///Submit button and the workings of it
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: _hermesOrange,
                            fixedSize: const Size(100, 40)),
                        onPressed: () async {
                          await Authentication()
                              .signUp(email: email, password: password)
                              .then((value) => Navigator.of(context).pop());
                        },
                        child: const Text('Submit!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),

                    const SizedBox(
                        height: 50, child: Divider(color: Colors.blueGrey)),

                    ///Google Sign in option
                  ])),
              Expanded(
                  //expand to use more axis space to align
                  child: Align(
                      child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height / 4,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/coffee_cake.png"))),
              )))
            ])));
  }
}
