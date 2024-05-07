import 'package:flutter/material.dart';
import 'package:note_application/services/curd_methods.dart';

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

  // Method for removing Note
  void deletingNote() {
    firestoreservice.deleteNote(docID: widget.docID);
    Navigator.of(context).popAndPushNamed("/HomePage");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Add the Note when user Press Back Navigation button of Android
      onPopInvoked: (didPop)  {
        // // If Note Empty
        // if (textEditingController1.text.isEmpty &&
        //     textEditingController2.text.isEmpty) {
        //   showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         actionsPadding: const EdgeInsets.all(0),
        //         content: const Text("Do you want to add empty note ?"),
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               firestoreservice.addNote(
        //                 title: textEditingController1.text,
        //                 note: textEditingController2.text,
        //               );

        //               // pushing user to HomePage
        //               Navigator.of(context).pop();
        //               Navigator.of(context).pop();
        //             },
        //             child: Text(
        //               "yes",
        //               style: Theme.of(context).textTheme.bodyMedium,
        //             ),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               // pushing user to HomePage
        //               Navigator.of(context).pop();
        //             },
        //             child: Text(
        //               "no",
        //               style: Theme.of(context).textTheme.bodyMedium,
        //             ),
        //           )
        //         ],
        //       );
        //     },
        //   );
        // }
        // // If Note is not Empty
        // else {
        //   firestoreservice.addNote(
        //     title: textEditingController1.text,
        //     note: textEditingController2.text,
        //   );

        //   // pushing user to HomePage
        //   Navigator.of(context).pop();
        // }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("A D D  P A G E"),
          centerTitle: true,
          // Add the Note when user Press Back arrow button of AppBar()
          leading: IconButton(
            onPressed: () {
              // If Note Empty
              if (textEditingController1.text.isEmpty &&
                  textEditingController2.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsPadding: const EdgeInsets.all(0),
                      content: const Text("Do you want to add empty note ?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              firestoreservice.addNote(
                                title: textEditingController1.text,
                                note: textEditingController2.text,
                              );

                              // pushing user to HomePage
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/MainPage", (route) => true);
                            },
                            child: Text(
                              "yes",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                        TextButton(
                          onPressed: () {
                            // pushing user to HomePage
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "no",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      ],
                    );
                  },
                );
              }
              // If Note is not Empty
              else {
                firestoreservice.addNote(
                  title: textEditingController1.text,
                  note: textEditingController2.text,
                );

                // pushing user to HomePage
                Navigator.of(context).pop();
              }
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
