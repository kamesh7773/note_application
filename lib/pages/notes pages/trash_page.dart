import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colored_print/colored_print.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/pages/notes%20pages/update_note_page.dart';
import 'package:note_application/services/database/curd_methods.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  //! Controllar for DragSelectGridView
  final DragSelectGridViewController controller =
      DragSelectGridViewController();

  //! Set for Notes Document ID's [creating Set because it will be initlized with duplicate same type of document.id's]
  Set<String> documentIdList = {};

  //! List of Map of Deleted Notes.
  List<Map<String, dynamic>> deletedNotes = [];

  //! Method that Rebuild the UI Based on the Selection.
  void listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.addListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (!value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("T R A S H"),
        ),
        drawer: const DrawerWidget(
          iconNumber: 2,
        ),
        body: StreamBuilder(
          stream: FireStoreCurdMethods.readTrashNotes(),
          builder: (context, snapshot) {
            // Storeing List of trash documents from Collection
            // Here "snapshot.data!.docs" -> data == Collection & docs == List of Document
            List listOfTrashDocs = snapshot.data!.docs;

            //! If there is not Documents in Trash DB Collections.
            if (listOfTrashDocs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/Trash.png",
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "E M P T Y    T R A S H",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              );
            }

            //! IF there is Trash Notes are avaible in Trash DB Collection.
            else {
              if (snapshot.data == null) {
                return const LinearProgressIndicator();
              }
              return DragSelectGridView(
                gridController: controller,
                itemCount: listOfTrashDocs.length,
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                itemBuilder: (context, index, isSelected) {
                  // geting indivisual document from List of Document's
                  DocumentSnapshot document = listOfTrashDocs[index];

                  // getting indivsual document ID
                  String docID = document.id;

                  // getting Map Data of each Document
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  // retiveing Data Map<String,Dynamic>
                  String title = data['title'];
                  String note = data['note'];

                  //? THIS UNDER CODE IS LOGIC FOR DELETE NOTES WHILE SELECTING MULTIPLE NOTES.
                  //! if Notes are selected then retrive there docID
                  if (controller.value.isSelecting) {
                    //! It is very imp to clear the documentIdList becuase when we select and again deselecte then deSeleect docID not removed.
                    documentIdList.clear();

                    //! this will return the selected notes number in the form of set() data type.
                    var set = controller.value.selectedIndexes;

                    //! Storing List of Selected Notes docID into Set()
                    for (var element in set) {
                      DocumentSnapshot document = listOfTrashDocs[element];
                      //! Here we are storing selected notes DocId into Declared Set() Data Type. (WE ARE USED SET() DATATYPE BECAUSE THIS METHOD CALLED SEVRAL TIMES AND IF WE USE LIST THEN IT WILL BE FILLED THE LIST WITH DUPLICATE DOCID'S)
                      documentIdList.add(document.id);
                    }
                  }

                  // //? THIS UNDER CODE IS LOGIC FOR TRASH NOTES.
                  if (controller.value.isSelecting) {
                    //! It is very imp to clear the deletedNotes becuase when we select and again deselecte then deSeleect Notes not removed.
                    deletedNotes.clear();

                    //! this will return the selected notes number in the form of set() data type.
                    var list = controller.value.selectedIndexes.toList();

                    for (var element in list) {
                      DocumentSnapshot document = listOfTrashDocs[element];
                      // getting Map Data of each Document
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      deletedNotes.add(
                        {
                          "title": data['title'],
                          "note": data['note'],
                          "timestamp": Timestamp.now().toString(),
                        },
                      );
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return UpdateNotePage(
                            docID: docID,
                            title: title,
                            note: note,
                          );
                        },
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: isSelected ? 2.2 : 1.5,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade800,
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
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
