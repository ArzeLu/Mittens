import '../services/realtime_db.dart';
import 'package:flutter/material.dart';
import '../helpers/chat_tiles.dart';
import '../helpers/textbox.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({Key? key}) : super(key: key);

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: const Text("Chatroom"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
          alignment: Alignment.center, //if the alignment value is not null, then the container will expand to fill its parent
          child: (Stack(alignment: AlignmentDirectional.topCenter, children: [
            StreamBuilder(
                initialData: null,
                stream: Database.database
                    .child("chatroom")
                    .orderByKey()
                    .limitToLast(1)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //this is the only way I found that can actually cast
                    //without compiler or runtime screaming at me
                    final Map rawData = (snapshot.data!).snapshot.value as Map;
                    final casted = rawData.cast<String, String>();
                    String? msg = casted['message'];
                    return Text(msg!);
                  }
                  return const Text("nah no data bro");
                }),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: const TextBox(),
            )
          ]))),
    );
  }
}
