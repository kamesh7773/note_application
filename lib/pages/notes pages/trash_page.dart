import 'package:flutter/material.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("T R A S H"),
      ),
      body: const Center(
        child: Text("T R A S H   P A G E"),
      ),
    );
  }
}
