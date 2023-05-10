import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../services/media_store.dart';
import '../services/file_system.dart';
import 'dart:io';
import '../services/realtime_db.dart';
import 'chatroom.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Store store = Store();
  File? _profilePicture;

  void _loadProfilePicture() {
    _profilePicture = store.getImage(fileName: "profile.jpg");
    if (_profilePicture == null) debugPrint("yuh\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(children: [
              TextButton(
                  onPressed: () async {
                    await Authentication().signOut();
                  },
                  child: const Text("Sign Out")),
              TextButton(
                  onPressed: () async {
                    await Authentication().currentUser?.delete();
                  },
                  child: const Text("Delete User")),
              TextButton(
                  onPressed: () async {
                    await Store().setProfilePicture().then((value) {
                      setState(() {
                        _loadProfilePicture();
                      });
                    });
                  },
                  child: const Text("Pick a file")),
              TextButton(
                  onPressed: () {
                    FileSystem().clearCache();
                  },
                  child: const Text("delete cache")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _loadProfilePicture();
                    });
                  },
                  child: const Text("set state bich")),
              TextButton(
                  onPressed: () {
                    Database().sendMessage("hello");
                  },
                  child: const Text("Send Text Test")),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chatroom()));
                },
                child: const Text("open chat room"),
              ),
              _profilePicture != null
                  ? Image.file(_profilePicture!)
                  : Image.asset("assets/images/default.jpg")
            ])));
  }
}
