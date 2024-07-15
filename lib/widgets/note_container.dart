import 'package:flutter/material.dart';

class NoteContainer extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String note;
  const NoteContainer({
    super.key,
    required this.isSelected,
    required this.title,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 1.6 : 0.8,
            color: isSelected
                ? Colors.black
                : const Color.fromARGB(255, 110, 115, 119),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
