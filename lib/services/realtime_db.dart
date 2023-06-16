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
    String id = Authentication().getUserID();
    final newMessage = <String, String>{
      "user": id,
      "message": message,
    };

    try {
      await _messagesPath.push().set(newMessage);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<DatabaseEvent> getSingleMessage() {
    return _messagesPath.limitToLast(1).onValue;
  }

  Future<DatabaseEvent> getMultipleMessages({required String before}) async {
    return await _messagesPath.orderByKey().endBefore(before).limitToLast(20).once();
  }
}
