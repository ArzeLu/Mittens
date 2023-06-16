import 'package:flutter/material.dart';
import 'dart:io';
//relative imports
import '../services/authentication.dart';
import '../services/media_store.dart';
import '../services/file_system.dart';
import '../helpers/chat_system.dart';
import 'chatroom.dart';
import '../services/realtime_db.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ChatTiles _tileMaker = ChatTiles.instance;
  final Store store = Store();
  final RTDatabase _db = RTDatabase.instance;
  File? _profilePicture;

  void _loadProfilePicture() {
    _profilePicture = store.getImage(fileName: "profile.jpg");
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tileMaker.releaseResources();
    super.dispose();
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chatroom(tileMaker: _tileMaker)));
                },
                child: const Text("open chat room"),
              ),
              TextButton(
                onPressed: (){
                  _db.sendMessage("hello");
                },
                child: const Text("sends example text: hello"),
              ),
              _profilePicture != null
                  ? Image.file(_profilePicture!)
                  : Image.asset("assets/images/default.jpg")
            ])));
  }
}
