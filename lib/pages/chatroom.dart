import 'package:flutter/material.dart';

//relative imports
import '../helpers/chat_system.dart';
import '../services/realtime_db.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({Key? key, required this.tileMaker}) : super(key: key);
  final ChatTiles tileMaker;

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final RTDatabase rtDatabase = RTDatabase.instance;
  final ScrollController _scrollController = ScrollController();

  //Disposables
  final TextEditingController _textController = TextEditingController();
  late final ChatTiles _tileMaker; //Disposed in home.dart
  late final ValueNotifier<List<Align>> _messageListNotifier;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _tileMaker = widget.tileMaker;
    _messageListNotifier = _tileMaker.messageListNotifier;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    _tileMaker.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          //set this so that the chatroom itself will not move up and down due to the nature of SingleChildScrollView
          reverse: true,
          //align to the bottom so the textbox appears pinned underneath
          child: Column(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ValueListenableBuilder(
                    valueListenable: _messageListNotifier,
                    builder: (context, list, _) {
                      return ListView.builder(
                          controller: _scrollController,
                          reverse: true, //the list is built like a reversed stack, setting this to true allows the list to grow from bottom
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return list[index];
                          });
                    })),
            Container(
                height: 70,
                color: Colors.blue,
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    maxLines: null,
                  )),
                  IconButton(
                      iconSize: 20,
                      onPressed: () {
                        rtDatabase.sendMessage(_textController.text);
                        _textController.clear();
                      },
                      icon: const Icon(Icons.send))
                ]))
          ])),
    );
  }
}
