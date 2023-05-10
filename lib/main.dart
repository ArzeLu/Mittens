import 'package:flutter/material.dart';
import 'package:mittens/firebase_options.dart';
import 'services/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
