import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:showcaseview/showcaseview.dart';

class AddNotePage extends StatefulWidget {
  final String? docID;
  final GlobalKey globalKey3;
  final GlobalKey globalKey4;
  final GlobalKey globalKey5;
  final GlobalKey globalKey6;
  final VoidCallback initlizationOfKeys;

  const AddNotePage({
    super.key,
    required this.docID,
    required this.globalKey3,
    required this.globalKey4,
    required this.globalKey5,
    required this.globalKey6,
    required this.initlizationOfKeys,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  // TextField Controllers
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    //! Initlization of ShowcaseView widget with provided global keys.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        widget.globalKey3,
        widget.globalKey4,
        widget.globalKey5,
        widget.globalKey6,
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
      child: Scaffold(
        appBar: AppBar(
          leading: Showcase(
            key: widget.globalKey6,
            description: "Tap to save note",
            targetShapeBorder: const CircleBorder(),
            disposeOnTap: true,
            onTargetClick: () {
              addingNote2();
              widget.initlizationOfKeys();
            },
            onBarrierClick: () {
              addingNote2();
              widget.initlizationOfKeys();
            },
            child: IconButton(
              // Method for adding note
              onPressed: addingNote2,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          actions: [
            //! Showcasing how to delete note.
            Showcase(
              key: widget.globalKey5,
              description: "Tap to delete Note",
              targetShapeBorder: const CircleBorder(),
              child: IconButton(
                onPressed: deletingNote,
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            )
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              //! Showcasing how to add note title.
              Showcase(
                key: widget.globalKey3,
                blurValue: 0.1,
                description: "Tap to add Title",
                overlayOpacity: .75,
                showArrow: true,
                disposeOnTap: false,
                onTargetClick: () {
                  ShowCaseWidget.of(context).next();
                  textEditingController1.text = "New Note.";
                },
                onBarrierClick: () {
                  ShowCaseWidget.of(context).next();
                  textEditingController1.text = "New Note.";
                },
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
                //! Showcasing how to add note description.
                child: Showcase(
                  key: widget.globalKey4,
                  blurValue: 0.1,
                  description: "Tap to add note",
                  overlayOpacity: .75,
                  showArrow: true,
                  disposeOnTap: false,
                  onTargetClick: () {
                    ShowCaseWidget.of(context).next();
                    textEditingController2.text = "New Note created.";
                  },
                  onBarrierClick: () {
                    ShowCaseWidget.of(context).next();
                    textEditingController2.text = "New Note created.";
                  },
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
