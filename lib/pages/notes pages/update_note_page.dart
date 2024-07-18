import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';

class UpdateNotePage extends StatefulWidget {
  final String? docID;
  final String? title;
  final String? note;
  const UpdateNotePage({super.key, required this.docID, this.title, this.note});

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  // Textfeild Controller's
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  // dispoing textEditingControllar's
  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Method for adding Note when user clickback button of Android
  // ------------------------------------------------------------
  void updatingNote1(didPop) async {
    if (!didPop) {
      FireStoreCurdMethods.updateNote(
        docID: widget.docID,
        title: textEditingController1.text,
        note: textEditingController2.text,
      );

      Navigator.of(context).pop();
    }
  }

  // --------------------------------------------------------------------
  // Method for adding Note when user click arrow back button of AppBar()
  // --------------------------------------------------------------------
  void updatingNote2() {
    FireStoreCurdMethods.updateNote(
      docID: widget.docID,
      title: textEditingController1.text,
      note: textEditingController2.text,
    );

    Navigator.of(context).pop();
  }

  // ------------------------
  // Method for deleting Note
  // ------------------------
  void deletingNote() {
    FireStoreCurdMethods.addNoteToTrash(
      deletedNotes: {
        "title": textEditingController1.text,
        "note": textEditingController2.text,
        "timestamp": Timestamp.now(),
      },
    );
    FireStoreCurdMethods.deleteNote(docID: widget.docID);
    Navigator.of(context).pop();
    // Showing SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text(
          "Note deleted",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    //! Assigning the FireStore Data to textEditingController's.
    textEditingController1.text = widget.title!;
    textEditingController2.text = widget.note!;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // Updating Note By PopScope()
        updatingNote1(didPop);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: myColors!.notePage,
          // Add the Note when user Press Back arrow button of AppBar()
          leading: IconButton(
            onPressed: updatingNote2,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              // Updating Note By AppBar() Arrow back button
              onPressed: deletingNote,
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            )
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              TextField(
                controller: textEditingController1,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Theme.of(context).colorScheme.inversePrimary,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Title",
                  hintStyle: TextStyle(fontSize: 22),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: textEditingController2,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 100,
                  autofocus: true,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18),
                    hintText: "Note : ",
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
