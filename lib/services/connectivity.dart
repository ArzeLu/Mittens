import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class Connectivity {
  late final StreamSubscription<List<InternetAddress>> connectionSubscription;
  bool connected = false;

  Connectivity._(){
    connectionSubscription = InternetAddress.lookup("example.com").asStream().listen((connection) {
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        connected = true;
      }
      connected = false;
    });
  }
  Stream<bool> checkConnection() async* {
    try {
      bool connected = false;
      yield connected;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
