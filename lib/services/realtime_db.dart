import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'authentication.dart';

class Database {
  static DatabaseReference database = FirebaseDatabase.instance.ref();
  late final DatabaseReference _chatroom;

  Database(){
    _chatroom = database.child("chatroom");
  }

  ///Store a message onto realtime db
  ///Map<String name, String message>
  Future<bool> sendMessage(String message) async {
    String id = Authentication().getUserID();
    final newMessage = <String, String>{
      id: message,
    };

    try{
      await _chatroom.child("messages").push().set(newMessage);
      return true;
    }catch (e){
      debugPrint(e.toString());
    }

    return false;
  }

  Stream<DatabaseEvent> get getMessages {
    return database.child("user/coupleChat").limitToLast(5).onValue;
  }
}
