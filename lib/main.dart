import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/services/firebase_options.dart';

void main() async {
  // Initlizing FireBase for Current Platform
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
