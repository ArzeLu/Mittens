import 'package:flutter/material.dart';

//relative imports
import '../../services/realtime_db.dart';
import '../../helpers/generator.dart';
import '../../main.dart';

class RoomSetUp extends StatefulWidget {
  Function callback;

  RoomSetUp(this.callback, {super.key});

  @override
  State<RoomSetUp> createState() => _RoomSetUpState();
}

class _RoomSetUpState extends State<RoomSetUp> {
  final RTDatabase _database = RTDatabase();
  final Generator _generator = Generator.instance;
  String inviteCode = "";
  String roomID = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Text("One last step....!"),
            const Text("We're making a private room just for you two <3"),
            TextButton(
                child: const Text("Create a room"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Create a room!"),
                            actions: [
                              TextButton(
                                child: const Text("Create!"),
                                onPressed: () async {
                                  String roomID = await _generator.getRoomCode();
                                  await Future.wait([hive.roomID.put("roomID", roomID)]);
                                  widget.callback();
                                },
                              )
                            ]);
                      });
                }),
            TextButton(
              child: const Text("Join a room"),
              onPressed: () {},
            )
          ],
        ));
  }
}
