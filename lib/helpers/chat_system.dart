import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../services/realtime_db.dart';

///Handles receiving and sending chat messages
///Also wraps the messages into chat tiles.
class ChatTiles {
  final Authentication _auth = Authentication();
  final RTDatabase _database = RTDatabase.instance;
  late bool initialized;
  late final ValueNotifier<List<Align>> messageList;
  late final StreamSubscription<DatabaseEvent> singleMessageStreamSub;

  ChatTiles._() {
    initialized = false;
    messageList = ValueNotifier(List<Align>.empty(growable: true));
    singleMessageStreamSub = _database.getSingleMessage().listen((event) async {
      List<Align> tempList = List.empty(growable: true);

      //See https://youtu.be/sXBJZD0fBa4?list=RDCMUCP4bf6IHJJQehibu6ai__cg&t=2019
      //for guidance.
      if (event.snapshot.exists) {
        tempList = extractMessageData(event);

        //Getting the past messages when the user taps into the chatroom
        if(!initialized){
          final Map<String, dynamic> map = Map.from(event.snapshot.value as Map).cast<String, dynamic>();
          String key = map.keys.first;
          DatabaseEvent oldEvent = await _database.getMultipleMessages(before: key);
          if(oldEvent.snapshot.exists) {
            List<Align> oldList = extractMessageData(oldEvent);
            oldList.addAll(tempList);
            tempList = oldList;
          }
          initialized = true;
        }

        //If I don't write the second line of messageList.value,
        //then the notifier won't trigger properly.
        //This is because the reference to the List is the same and
        //I have to create a new variable for the equality operator to detect a difference.
        messageList.value.addAll(tempList);
        messageList.value = List.from(messageList.value);
      }
    });
  }

  ChatTiles(); //If I don't want to initiate singleton stuff above

  static ChatTiles instance = ChatTiles._();

  void releaseResources() {
    singleMessageStreamSub.cancel();
    messageList.dispose();
  }

  ValueNotifier<List<Align>> get messageListNotifier => messageList;

  Align getMessageTile(String sender, String message) {
    String id = _auth.getUserID();
    //if(sender == me){set pfp to mine}
    return Align(
        alignment: sender == id ? Alignment.centerRight : Alignment.centerLeft,
        child: ListTile(
          leading: const Icon(Icons.circle),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          style: ListTileStyle.list,
          title: Text(message),
        ));
  }

  Future<void> getRecentPastMessages(String before) async {
    List<Align> tempList = List.empty(growable: true);
    var event = await _database.getMultipleMessages(before: before);

    if(event.snapshot.exists){
      tempList = extractMessageData(event);

      tempList.addAll(messageList.value);
      messageList.value = tempList;
    }
  }

  List<Align> extractMessageData(DatabaseEvent event){
    List<Align> tempList = List.empty(growable: true);

    final map = Map.from(event.snapshot.value as Map);
    for(var value in map.values){
      final data = Map.from(value as Map).cast<String, String>();
      tempList.add(getMessageTile(data["user"]!, data["message"]!));
    }

    return tempList;
  }
}
