import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/services/firebase_options.dart';
import 'package:note_application/theme/dark_mode.dart';
import 'package:note_application/theme/light_mode.dart';

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
    return MaterialApp(
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
