import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'dart:io';

//relative imports
import '../../services/authentication.dart';
import '../../services/media_store.dart';
import '../../services/local_file_system.dart';
import '../../helpers/chat_system.dart';
import '../chatroom/chatroom.dart';
import '../../services/realtime_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatTiles _tileMaker = ChatTiles.instance;
  final MStore _store = MStore(); //media_store.dart

  final RTDatabase _database = RTDatabase();

  File? _profilePicture;

  String test = "";

  void _loadProfilePicture() {
    _profilePicture = _store.getImage(fileName: "profile.jpg");
  }

  @override
  void dispose() {
    _tileMaker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                await MStore().setProfilePicture().then((value) {
                  setState(() {
                    _loadProfilePicture();
                  });
                });
              },
              child: const Text("set pfp")),
          TextButton(
              onPressed: () {
                LocalFileSystem().clearCache();
              },
              child: const Text("delete cache")),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Chatroom(tileMaker: _tileMaker)));
            },
            child: const Text("open chat room"),
          ),
          SizedBox(height: 20, child: Text(test)),
          TextButton(
            onPressed: () async {
              DatabaseEvent event = await _database.leDatabase.child("chat_rooms").child("123456").child("messages").child("1689059065825").once();

              setState(() {
                test = event.snapshot.child("user").value.toString();
              });
            },
            child: const Text("test"),
          ), Row(children: [
            _profilePicture != null
                ? Image.file(_profilePicture!)
                : Image.asset("assets/images/default.jpg"),
            _profilePicture != null
                ? Image.file(_profilePicture!)
                : Image.asset("assets/images/default.jpg")
          ]),
        ]));
  }
}
