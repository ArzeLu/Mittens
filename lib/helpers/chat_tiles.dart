import 'package:flutter/material.dart';

class ChatTiles {
  //chatroom.dart accesses this map to make a chat list in that file.
  //the map consists of sender and message to make a distinction
  static Map<String, String> messages = {};

  ListTile getMessageTile(String sender, String message) {
    //if(sender == me){set pfp to mine}
    return ListTile(
      leading: const Icon(Icons.circle),
      title: Text(message),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      style: ListTileStyle.list,
    );
  }
}