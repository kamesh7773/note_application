import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final void Function() onTap;

  final String text;
  final Color color;
  final Color? textColor;

  const ButtonWidget({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
