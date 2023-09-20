import 'package:flutter/material.dart';

//relative imports
import '../../services/realtime_db.dart';
import '../../helpers/generator.dart';
import '../../main.dart';

class RoomSetUp extends StatefulWidget {
  const RoomSetUp({super.key});

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
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Text("One last step....!"),
            const Text("We're making a private room just for you two <3"),
            TextButton(
              child: const Text("Create a room"),
              onPressed: () async {
                roomID = await _generator.getRoomCode();
              }
            ),
            TextButton(
              child: const Text("Join a room"),
              onPressed: () {},
            )
          ],
        ));
  }
}
