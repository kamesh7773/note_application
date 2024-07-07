import 'package:flutter/material.dart';
import 'package:note_application/services/database/curd_methods.dart';

class AddNotePage extends StatefulWidget {
  final String? docID;

  const AddNotePage({super.key, required this.docID});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
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
  void addingNote1(didPop) {
    // if TextFeild's are not empty
    if (!didPop &&
        textEditingController1.text.isNotEmpty &&
        textEditingController2.text.isNotEmpty) {
      firestoreservice.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }
    // if TextFeild 1 is Not Empty
    else if (!didPop && textEditingController1.text.isNotEmpty) {
      firestoreservice.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }
    // if TextFeild 2 is Not Empty
    else if (!didPop && textEditingController2.text.isNotEmpty) {
      firestoreservice.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }

    // if TextFeild 1 & TextFeild 2 are empty
    if (!didPop &&
        textEditingController1.text.isEmpty &&
        textEditingController2.text.isEmpty) {
      // Deleting Empty Note
      firestoreservice.deleteNote(docID: widget.docID);

      // Poping out from Note Page
      Navigator.of(context).pop();

      // Showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text(
            "Empty note discarded",
          ),
        ),
      );
    }
  }

  // --------------------------------------------------------------------
  // Method for adding Note when user click arrow back button of AppBar()
  // --------------------------------------------------------------------
  void addingNote2() {
    // if Textfeild's are not empty
    if (textEditingController1.text.isNotEmpty ||
        textEditingController2.text.isNotEmpty) {
      firestoreservice.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }

    // if Textfeild's are empty
    if (textEditingController1.text.isEmpty &&
        textEditingController2.text.isEmpty) {
      // Deleting Empty Note
      firestoreservice.deleteNote(docID: widget.docID);

      // Poping out from Note Page
      Navigator.of(context).pop();

      // Showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text("Empty note discarded"),
        ),
      );
    }
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        addingNote1(didPop);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            // Method for adding note
            onPressed: addingNote2,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
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
