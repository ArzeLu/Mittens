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

  ///Grabs past messages if not initialized
  late bool initialized;

  //Disposables
  ///This chatroom displays this list.
  late final ValueNotifier<List<Align>> messageList;
  ///A stream that receives one new message at a time
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
        if (!initialized) {
          final Map<String, dynamic> map =
              Map.from(event.snapshot.value as Map).cast<String, dynamic>();
          String key = map.keys.first;
          DatabaseEvent oldEvent =
              await _database.getMultipleMessages(before: key);
          if (oldEvent.snapshot.exists) {
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

  void dispose() {
    singleMessageStreamSub.cancel();
    messageList.dispose();
  }

  ValueNotifier<List<Align>> get messageListNotifier => messageList;

  Align getMessageTile(String sender, String message) {
    String id = _auth.getUserID();
    //if(sender == me){set pfp to mine}
    return Align(
        alignment: Alignment.centerRight,
        //If the sender of the message equals to the ID of the current user,
        //align the text tile to the right
        child: sender == id
            ? ListTile(
                trailing: const Icon(Icons.circle),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                style: ListTileStyle.list,
                title: Text(textAlign: TextAlign.right, message))
            : ListTile(
                leading: const Icon(Icons.circle),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                style: ListTileStyle.list,
                title: Text(textAlign: TextAlign.left, message),
              ));
  }

  ///Gets a batch of messages when user opens chatroom.
  ///Checks if the db snapshot instance exists
  ///No return value because it adds to the messageList directly.
  Future<void> getRecentPastMessages(String before) async {
    List<Align> tempList = List.empty(growable: true);
    var event = await _database.getMultipleMessages(before: before);

    if (event.snapshot.exists) {
      tempList = extractMessageData(event);

      tempList.addAll(messageList.value);
      messageList.value.addAll(tempList);
      messageList.value = List.from(messageList.value);
    }
  }

  ///Returns a list of compiled messages data as String
  ///from the realtime db DatabaseEvent passed in the perimeter
  List<Align> extractMessageData(DatabaseEvent event) {
    List<Align> tempList = List.empty(growable: true);

    final map = Map.from(event.snapshot.value as Map);
    for (var value in map.values) {
      final data = Map.from(value as Map).cast<String, String>();
      tempList.insert(0, getMessageTile(data["user"]!, data["message"]!)); //adding new message to the first
    }

    return tempList;
  }
}
