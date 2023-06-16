import 'package:flutter/material.dart';
//relative imports
import '../helpers/chat_system.dart';
import '../helpers/textbox.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({Key? key, required this.tileMaker}) : super(key: key);
  final ChatTiles tileMaker;
  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final TextEditingController _controller = TextEditingController();
  late final TextBox _textbox;
  late final ChatTiles _tileMaker;
  late final ValueNotifier<List<Align>> _messageListNotifier;
  bool initialized = false;

  @override
  void initState() {
    _textbox = TextBox(controller: _controller);
    _tileMaker = widget.tileMaker;
    _messageListNotifier = _tileMaker.messageListNotifier;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: (Stack(alignment: AlignmentDirectional.topCenter, children: [
            ValueListenableBuilder(
                valueListenable: _messageListNotifier,
                builder: (context, list, _) {
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return list[index];
                      });
                }),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: _textbox,
            )
          ]))),
    );
  }
}
