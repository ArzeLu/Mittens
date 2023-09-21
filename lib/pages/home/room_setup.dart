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
  final _lightGrey = const Color(0xfff2f2f2);
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
                                  String roomID =
                                      await _generator.getRoomCode();
                                  await hive.roomID.put("roomID", roomID);
                                  await _database.storeRoomID();
                                  widget.callback();
                                },
                              ),
                              TextButton(
                                child: const Text("Go Back"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ]);
                      });
                }),
            TextButton(
              child: const Text("Join a room"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String input = "";
                      String errorPrompt = "";
                      return AlertDialog(
                          title: const Text("Join the room!"),
                          content: Column(children: [
                            TextFormField(
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.email,
                                        color: Colors.lightBlue),
                                    hintText: "Room Code",
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    filled: true,
                                    fillColor: _lightGrey),
                                onChanged: (value) => input = value),
                            Text(errorPrompt)
                          ]),
                          actions: [
                            TextButton(
                              child: const Text("Join!"),
                              onPressed: () async {
                                bool availability = await _database
                                    .checkRoomIDAvailability(input);

                                if (availability) {
                                  await hive.roomID.put("roomID", roomID);
                                  await _database.storeRoomID();
                                  await _database.markRoomFull();
                                  widget.callback();
                                } else {
                                  setState(() {
                                    errorPrompt = "The code is either invalid or used by others. Please try again!";
                                  });
                                }
                              },
                            ),
                            TextButton(
                              child: const Text("Go Back"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ]);
                    });
              },
            )
          ],
        ));
  }
}
