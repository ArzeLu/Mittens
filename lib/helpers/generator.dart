import 'dart:math';
//relative imports
import '../services/realtime_db.dart';

class Generator{
  final RTDatabase _database = RTDatabase.instance;
  late final Random rand;

  //This is the char index in dart. Dart doesn't have conventional char var type
  int start = "a".codeUnitAt(0); //97
  int end = "z".codeUnitAt(0); //122
  int capStart = "A".codeUnitAt(0); //65
  int capEnd = "Z".codeUnitAt(0); //90

  Generator(){
    rand = Random(DateTime.now().millisecondsSinceEpoch);
  }

  String getInviteCode(){
    while(true) {
      String generatedLetter = "";
      for (int i = 0; i < 5; i++) {
        int newNum = rand.nextInt(26) + 64;
        generatedLetter += String.fromCharCode(newNum);
      }

    }

    return 'hi';
  }
}