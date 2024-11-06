import 'package:flutter/material.dart';

class ShowCase extends StatefulWidget {
  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;

  const ShowCase({
    super.key,
    required this.globalKey,
    required this.title,
    required this.description,
    required this.child,
    required this.shapeBorder,
  });

  @override
  State<ShowCase> createState() => _ShowCaseState();
}

class _ShowCaseState extends State<ShowCase> {
  @override
  Widget build(BuildContext context) {
    return ShowCase(
      globalKey: widget.globalKey,
      title: widget.title,
      description: widget.description,
      shapeBorder: const CircleBorder(),
      child: widget.child,
    );
  }
}
