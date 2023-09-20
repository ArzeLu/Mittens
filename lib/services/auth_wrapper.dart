import 'package:flutter/material.dart';
import '../pages/start/start.dart';
import '../pages/home/home.dart';
import 'authentication.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Authentication().authState, builder: (context, snapshot) {
      if(snapshot.hasData){
        return const Home();
      }else{
        return const Start();
      }
    });
  }
}
