import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
//relative imports
import '../services/authentication.dart';
import '../services/media_store.dart';
import '../services/local_file_system.dart';
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
  final MStore store = MStore();
  final RTDatabase _db = RTDatabase.instance;
  File? _profilePicture;

  String test = "";

  void _loadProfilePicture() {
    _profilePicture = store.getImage(fileName: "profile.jpg");
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tileMaker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    await MStore().setProfilePicture().then((value) {
                      setState(() {
                        _loadProfilePicture();
                      });
                    });
                  },
                  child: const Text("Pick a file")),
              TextButton(
                  onPressed: () {
                    LocalFileSystem().clearCache();
                  },
                  child: const Text("delete cache")),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chatroom(tileMaker: _tileMaker)));
                },
                child: const Text("open chat room"),
              ),
              SizedBox(
                height: 20,
                child: Text(test),
              ),
              TextButton(
                onPressed: (){
                  var rand = Random(DateTime.now().millisecondsSinceEpoch);
                  String generatedLetters = "";
                  for (int i = 0; i < 5; i++) {
                    int newNum = rand.nextInt(26) + 64;
                    generatedLetters += String.fromCharCode(newNum);
                  }
                  setState(() {
                    test = generatedLetters;
                  });
                },
                child: Text("test")
              ),
              _profilePicture != null
                  ? Image.file(_profilePicture!)
                  : Image.asset("assets/images/default.jpg")
            ])));
  }
}
