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

  ///Singleton constructor
  RTDatabase._() {
    _messagesPath = _database.child("chatroom/messages");
  }

  RTDatabase();

  static final RTDatabase instance = RTDatabase._();

  ///Store a message onto firebase realtime db
  ///Map<String name, String message>
  Future<void> sendMessage(String message) async {
    DateTime now = DateTime.now();

    StringBuffer time = StringBuffer();
    time.write(now.year);
    time.write(now.month);
    time.write(now.day);
    time.write(now.hour);
    time.write(now.minute);
    time.write(now.second);

    String id = Authentication().getUserID();

    final newMessage = <String, String>{
      "user": id,
      "message": message,
    };

    try {
      await _messagesPath.child(time.toString()).set(newMessage);
    } catch (e) {
      debugPrint(e.toString());
    }
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
