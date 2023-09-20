import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//relative imports
import 'authentication.dart';
import 'hive_storage.dart';

//Messages are only sent if there's internet connection.
//Therefore, this class is reached first before the Hive class
//upon sending and receiving
class RTDatabase {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  late final DatabaseReference _messagesPath;
  late final DatabaseReference _inviteCodePath = _database.child("invite_codes");
  late final DatabaseReference _chatRoomID = _database.child("roomIDs");

  ///Singleton constructor
  RTDatabase._() {
    _messagesPath = _database.child("chat_rooms/123456/messages"); //User specific (can't have a general instantiation)
  }

  RTDatabase();

  static final RTDatabase instance = RTDatabase._();

  ///Store a message onto firebase realtime db
  ///Map<String name, String message>
  Future<void> sendMessage(String message) async {
    String id = Authentication().getUserID();

    final newMessage = <String, String>{
      "user": id,
      "message": message,
    };

    try {
      await _messagesPath.child(DateTime.now().millisecondsSinceEpoch.toString()).set(newMessage);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Checks if a user has created of joined a room
  Future<bool> checkRoomBound(String userID) async {
    return await getChatRoomID(userID) != null;
  }

  ///Get the lover room ID for a particular user
  Future<String?> getChatRoomID(String userID) async {
    DatabaseEvent event = await _chatRoomID.child(userID).once();
    Object? value = event.snapshot.value;

    return null;

    //Map<String, String> map = Map.from(event as Map).cast<String, String>();
  }

  ///Check if the invite code is a branch in
  Future<bool> checkInviteCodeExistence(String key) async {
    DatabaseEvent event = await _inviteCodePath.child(key).once();
    return event.snapshot.exists;
  }

  ///Returns a Stream that listens to one incoming message at a time
  Stream<DatabaseEvent> getSingleMessage() {
    return _messagesPath.limitToLast(1).onValue;
  }

  ///Returns a DatabaseEvent (a realtime database instance) that includes 20
  ///messages in one batch.
  ///Perimeter requires a realtime db order key that acts as a timestamp
  ///, then grabs the messages before the key.
  Future<DatabaseEvent> getMultipleMessages({required String before}) async {
    return await _messagesPath.orderByKey().endBefore(before).limitToLast(20).once();
  }
}
