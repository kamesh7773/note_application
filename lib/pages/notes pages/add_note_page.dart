import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:showcaseview/showcaseview.dart';

class AddNotePage extends StatefulWidget {
  final String? docID;

  const AddNotePage({
    super.key,
    required this.docID,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  // Declaration of Global Key's for showCaseView.
  final GlobalKey globalKey3 = GlobalKey();
  final GlobalKey globalKey4 = GlobalKey();
  // TextField Controllers
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    //! Initlization of ShowcaseView widget with provided global keys.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        globalKey3,
        globalKey4,
      ]);
    });
  }

  // Disposing TextEditingControllers
  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Method for adding a note when the user clicks the back button on Android
  // ------------------------------------------------------------
  void addingNote1(didPop) {
    // If TextFields are not empty
    if (!didPop && textEditingController1.text.isNotEmpty && textEditingController2.text.isNotEmpty) {
      FireStoreCurdMethods.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }
    // If TextField 1 is not empty
    else if (!didPop && textEditingController1.text.isNotEmpty) {
      FireStoreCurdMethods.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }
    // If TextField 2 is not empty
    else if (!didPop && textEditingController2.text.isNotEmpty) {
      FireStoreCurdMethods.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }

    // If both TextField 1 and TextField 2 are empty
    if (!didPop && textEditingController1.text.isEmpty && textEditingController2.text.isEmpty) {
      // Deleting empty note
      FireStoreCurdMethods.deleteNote(docID: widget.docID);

      // Popping out from the note page
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
  // Method for adding a note when the user clicks the arrow back button of AppBar()
  // --------------------------------------------------------------------
  void addingNote2() {
    // If TextFields are not empty
    if (textEditingController1.text.isNotEmpty || textEditingController2.text.isNotEmpty) {
      FireStoreCurdMethods.addNote(
        title: textEditingController1.text,
        note: textEditingController2.text,
      );
      Navigator.of(context).pop();
    }

    // If TextFields are empty
    if (textEditingController1.text.isEmpty && textEditingController2.text.isEmpty) {
      // Deleting empty note
      FireStoreCurdMethods.deleteNote(docID: widget.docID);

      // Popping out from the note page
      Navigator.of(context).pop();

      // Showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          key: UniqueKey(),
          duration: const Duration(milliseconds: 800),
          content: const Text("Empty note discarded"),
        ),
      );
    }
  }

  // ------------------------
  // Method for deleting a note
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        addingNote1(didPop);
      },
      //! We are wraping our scaffold with ShowCaseWidget();
      child: ShowCaseWidget(
        builder: (context) {
          return Scaffold(
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
                  Showcase(
                    key: globalKey3,
                    description: "Title of note",
                    child: TextField(
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
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController2,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      maxLines: 100,
                      // autofocus: true,
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
          );
        },
      ),
    );
  }
}
