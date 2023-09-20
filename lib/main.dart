import 'package:flutter/material.dart';
import 'package:mittens/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//relative imports
import 'services/auth_wrapper.dart';
import 'services/hive_storage.dart';
import 'services/realtime_db.dart';

late final RTDatabase database;
late final HiveStorage hive;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  database = RTDatabase.instance;
  hive = HiveStorage();
  await hive.hiveStart();
  await hive.openBoxes();
  runApp(const Mittens());
}

class Mittens extends StatelessWidget {
  const Mittens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mittens',
      home: AuthWrapper(),
    );
  }
}
