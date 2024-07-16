import 'package:flutter/material.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';

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
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 1.6 : 0.8,
            color: isSelected
                ? myColors!.commanColor!
                : const Color.fromARGB(255, 92, 108, 118),
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
