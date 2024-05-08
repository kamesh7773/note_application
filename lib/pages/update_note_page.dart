import 'package:flutter/material.dart';
import 'package:note_application/services/curd_methods.dart';

class UpdateNotePage extends StatefulWidget {
  final String? docID;
  final String? title;
  final String? note;
  const UpdateNotePage({super.key, required this.docID, this.title, this.note});

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  // Creating the Instance of Curd Operation class
  FireStoreCurdMethods firestoreservice = FireStoreCurdMethods();

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
      firestoreservice.updateNote(
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
    firestoreservice.updateNote(
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
    firestoreservice.deleteNote(docID: widget.docID);
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
                  border: InputBorder.none,
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
                    border: InputBorder.none,
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
