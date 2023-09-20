import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//relative imports
import '../structures/message_structure.dart';

///https://pub.dev/packages/hive
///"It's not necessary to await for future"
//Extend HiveObject to access the save() and delete() methods
class HiveStorage extends HiveObject{
  late final Box messageBox;
  late final Box roomID;
  List<String> boxNames = ["messages"];
  HiveStorage();

  Future<void> hiveStart() async {
    await Hive.initFlutter();
  }

  Future<void> openBoxes() async {
    messageBox = await Hive.openBox("messages");
    roomID = await Hive.openBox("roomID");
  }

  Future<void> putMessage(String time, MessageStruct message) async {
    await messageBox.put(time, message).then((value) async => await save());
  }

  Future<void> deleteMessage(String time) async {
    await messageBox.delete(time).then((value) async => await save());
  }
}