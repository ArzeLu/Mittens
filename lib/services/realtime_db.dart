import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//relative imports
import 'authentication.dart';
import '../main.dart';

//Messages are only sent if there's internet connection.
//Therefore, this class is reached first before the Hive class
//upon sending and receiving
class RTDatabase {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final DatabaseReference leDatabase = FirebaseDatabase.instance.ref();

  late final DatabaseReference _messagesPath;
  late final DatabaseReference _chatRoomID;
  late final DatabaseReference _inviteCodePath;
  late final String roomID;

  ///Singleton constructor
  RTDatabase._() {
    roomID = hive.roomID.get("roomID");
    _messagesPath = _database.child("chat_rooms").child(roomID).child("messages"); //User specific (can't have a general instantiation)
    _chatRoomID = _database.child("chat_rooms").child(roomID);
    _inviteCodePath = _database.child("invite_codes");
  }

  RTDatabase();

  static final RTDatabase instance = RTDatabase._();

  //==========================================================================================
  //================================ Room Set Up Handling ====================================
  //==========================================================================================

  ///Putting roomID as a new branch into the chat_rooms directory,
  ///then put the current user id below it.
  Future<void> storeRoomID() async {
    String id = Authentication().getUserID();
    _database.child("chat_rooms").child(hive.roomID.get("roomID")).child("lovers").update({id : true});
  }

  ///Mark the current roomID as full in realtime database
  ///The function checkRoomIDAvailability uses it to see if a couple has already occupied the current roomID
  Future<void> markRoomFull() async {
    _database.child("chat_rooms").child(hive.roomID.get("roomID")).update({"userCount" : 2});
  }

  ///Check if a given room id is available:
  ///if there are already two people occupying the id
  ///if the id exists and operational
  Future<bool> checkRoomIDAvailability(String roomID) async {
    DataSnapshot snapshot = await _database.child("chat_rooms").child(roomID).get();

    //if the room exists
    if(!snapshot.exists){
      return false;
    }
    //if the room has been occupied by two people (a couple)
    if(snapshot.child("userCount").value.toString() == "2"){
      return false;
    }
    return true;
  }

  ///Check if the roomID is a branch in the chat_rooms branch
  ///In other words, check if it already exists
  Future<bool> checkRoomIDExistence(String roomID) async {
    DataSnapshot snapshot = await _database.child("chat_rooms").child(roomID).get();
    return snapshot.exists;
  }

  ///Check if the invite code is a branch in the main directory
  ///This is probably not ever going to be used
  Future<bool> checkInviteCodeExistence(String key) async {
    DatabaseEvent event = await _inviteCodePath.child(key).once();
    return event.snapshot.exists;
  }

  //==========================================================================================
  //================================ Chatting data handling ==================================
  //==========================================================================================

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
