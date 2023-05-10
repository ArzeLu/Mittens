import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  const TextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller;
    return Container(
        height: 50,
        color: Colors.cyanAccent,
        child: Row(children: [
          TextFormField(
            controller: controller,
          ),
          IconButton(onPressed: (){}, icon: icon)
        ]));
  }
}
