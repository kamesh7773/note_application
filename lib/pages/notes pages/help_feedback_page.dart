import 'package:flutter/material.dart';
import 'package:note_application/pages/drawer%20pages/drawer.dart';

class HelpAndFeedbackPage extends StatefulWidget {
  const HelpAndFeedbackPage({super.key});

  @override
  State<HelpAndFeedbackPage> createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends State<HelpAndFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("H E L P  &  F E E D B A C K"),
      ),
      drawer: const DrawerWidget(),
      body: const Center(
        child: Text("H E L P   &   F E E D B A C K   P A G E"),
      ),
    );
  }
}
