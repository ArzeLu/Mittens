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

  Generator();
  Generator._(){
    rand = Random(DateTime.now().millisecondsSinceEpoch);
  }

  ///Automatically sets random seed to current time in milliseconds
  static final Generator instance = Generator._();

  ///Generate a room code. Checks if room codes exists. O(1) time for checking
  Future<String> getRoomCode() async {
    String generatedLetter = "";
    bool check = true; //check if room code exists
    while(check) {
      for (int i = 0; i < 5; i++) {
        int newNum = rand.nextInt(26) + 65;
        generatedLetter += String.fromCharCode(newNum);
      }
      check = await _database.checkInviteCodeExistence(generatedLetter);
    }

    return generatedLetter;
  }

  ///Generate an invite code for the mitten<3 room. Checks if invite code exists
  Future<String> getInviteCode() async {
    int generatedCode = 0;
    bool check = true; //check if invite code exists
    while(check){
      generatedCode = rand.nextInt(871563) + 182654;
      check = await _database.checkInviteCodeExistence("$generatedCode");
    }

    return "$generatedCode";
  }
}