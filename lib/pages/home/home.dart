import 'package:flutter/material.dart';

//relative imports
import 'room_setup.dart';
import 'home_page.dart';
import '../../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isRoomBound =
      hive.roomID.get("roomID") != null; //if the user has created or joined a room

  String something = "something";

  void roomBinding() {
    setState(() {
      isRoomBound = true;
      something = hive.roomID.get("roomID");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(something)),

      //display home if user is already in a room
      body: isRoomBound ? const HomePage() : RoomSetUp(() => roomBinding()),

      //navigator bar. if the user isn't in a room yet, then don't display it
      bottomNavigationBar: isRoomBound
          ? BottomNavigationBar(items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home_filled),
                  label: 'Home♥️'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance),
                  activeIcon: Icon(Icons.gavel),
                  label: 'Courthouse'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  activeIcon: Icon(Icons.pin_drop),
                  label: 'Journey')
            ])
          : null,
    );
  }
}
