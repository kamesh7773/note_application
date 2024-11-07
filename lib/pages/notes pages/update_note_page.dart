import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colored_print/colored_print.dart';
import 'package:flutter/material.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:showcaseview/showcaseview.dart';

class UpdateNotePage extends StatefulWidget {
  final String? docID;
  final String? title;
  final String? note;
  final GlobalKey globalKey8;
  final GlobalKey globalKey9;
  final GlobalKey globalKey10;
  const UpdateNotePage({
    super.key,
    required this.docID,
    this.title,
    this.note,
    required this.globalKey8,
    required this.globalKey9,
    required this.globalKey10,
  });

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  // TextField Controllers
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    //! Initlization of ShowcaseView widget with provided global keys.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        widget.globalKey8,
        widget.globalKey9,
        widget.globalKey10,
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

  // --------------------------------------------------------------------
  // Method for updating the note when the Android back button is pressed
  // --------------------------------------------------------------------
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

  // -------------------------------------------------------------------------
  // Method for updating the note when the AppBar back arrow button is pressed
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
  // Method for deleting the note
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
    // Show a SnackBar
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
    //! Access theme extension colors.
    final myColors = Theme.of(context).extension<MyColors>();

    //! Assign Firestore data to TextEditingControllers.
    textEditingController1.text = widget.title!;
    textEditingController2.text = widget.note!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Update the note using PopScope()
        updatingNote1(didPop);
      },
      child: Scaffold(
        appBar: AppBar(
          // Update the note when the AppBar back arrow button is pressed
          leading: IconButton(
            onPressed: updatingNote2,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              // Delete the note using the AppBar delete button
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
                key: widget.globalKey8,
                blurValue: 0.1,
                description: "Tap to update Title",
                overlayOpacity: .75,
                showArrow: true,
                disposeOnTap: false,
                onTargetClick: () {
                  ColoredPrint.warning("Updated Note.");
                  ShowCaseWidget.of(context).next();
                  textEditingController1.text = "Updated Note.";
                },
                onBarrierClick: () {
                  ColoredPrint.warning("Updated Note.");
                  ShowCaseWidget.of(context).next();
                  textEditingController1.text = "Updated Note.";
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
                child: Showcase(
                  key: widget.globalKey9,
                  blurValue: 0.1,
                  description: "Tap to update note",
                  overlayOpacity: .75,
                  showArrow: true,
                  disposeOnTap: false,
                  onTargetClick: () {
                    ColoredPrint.warning("This is a updated note.");
                    ShowCaseWidget.of(context).next();
                    textEditingController1.clear();
                    textEditingController2.text = "This is a updated note.";
                  },
                  onBarrierClick: () {
                    ColoredPrint.warning("This is a updated note.");
                    ShowCaseWidget.of(context).next();
                    textEditingController1.clear();
                    textEditingController2.text = "This is a updated note.";
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
                      hintText: "Note:",
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
