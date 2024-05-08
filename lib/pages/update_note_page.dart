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

  // Method for removing Note
  void deletingNote() {
    firestoreservice.deleteNote(docID: widget.docID);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController1.text = widget.title!;
    textEditingController2.text = widget.note!;

    return PopScope(
      // Add the Note when user Press Back Navigation button of Android
      onPopInvoked: (didPop) {
        // firestoreservice.updateNote(
        //   docID: widget.docID,
        //   title: textEditingController1.text,
        //   note: textEditingController2.text,
        // );
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("U P D A T E  P A G E"),
          centerTitle: true,
          // Add the Note when user Press Back arrow button of AppBar()
          leading: IconButton(
            onPressed: () {
              firestoreservice.updateNote(
                docID: widget.docID,
                title: textEditingController1.text,
                note: textEditingController2.text,
              );

              Navigator.of(context).pop();
            },
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.black,
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
                    color: Colors.black,
                  ),
                  maxLines: 100,
                  autofocus: true,
                  cursorColor: Colors.black,
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
