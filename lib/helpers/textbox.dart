import 'package:flutter/material.dart';
//relative imports
import '../services/realtime_db.dart';

class TextBox extends StatelessWidget {
  final RTDatabase rtDatabase = RTDatabase.instance;

  TextBox({Key? key, required this.controller}) : super(key: key);
  late final TextEditingController controller;

  void releaseResources() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          releaseResources();
          return true;
        },
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Colors.cyanAccent,
            child: Row(children: [
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: null,
              )),
              IconButton(
                  onPressed: () {
                    rtDatabase.sendMessage(controller.text);
                    controller.clear();
                  },
                  icon: const Icon(Icons.send))
            ])));
  }
}
