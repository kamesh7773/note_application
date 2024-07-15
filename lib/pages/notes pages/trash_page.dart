import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/providers/layout_change_provider.dart';
import 'package:note_application/providers/toggle_provider.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/widgets/note_container.dart';
import 'package:provider/provider.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  //! Geting FireStore Collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  //! Controllar for DragSelectGridView
  final DragSelectGridViewController controller =
      DragSelectGridViewController();

  //! Set for Notes Document ID's [creating Set because it will be initlized with duplicate same type of document.id's]
  Set<String> documentIdList = {};

  //! List of Map of Selected Trash Notes Notes.
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
    //! Notes are selected or not Selected.
    final isSelected = controller.value.isSelecting;
    int selectedItems = controller.value.amount;

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
        appBar: isSelected
            ? AppBar(
                title: Text(
                  "$selectedItems",
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
                centerTitle: false,
                leading: isSelected
                    ? IconButton(
                        onPressed: () {
                          controller.clear();
                        },
                        icon: const Icon(Icons.close))
                    : const SizedBox(),
                actions: [
                  isSelected
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                //! we itrat through set of documentIdList and delete each notes with docID.
                                for (var element in documentIdList) {
                                  FireStoreCurdMethods.deleteTrashNote(
                                      docID: element);
                                }

                                //! Moveing List of Trash notes to Notes Data base.
                                try {
                                  // Reference to a CurrentUserID document in the main collection
                                  DocumentReference currentUserID = users.doc(
                                      FirebaseAuth.instance.currentUser!.uid
                                          .toString());

                                  // Creating Reference Trash  Sub-Collection insdie currentUserID Users Document.
                                  CollectionReference notes =
                                      currentUserID.collection('notes');

                                  // Adding deleted Notes to trash.
                                  for (var element in deletedNotes) {
                                    notes.add(element);
                                  }
                                } catch (error) {
                                  throw error.toString();
                                }

                                //! After Moving TrashNotes to Notes we clear our the TrashNotes list[].
                                deletedNotes.clear();
                                //! After deleting we clear the documentIdList set() data type.
                                documentIdList.clear();
                                //! Also clear out the Selcted Notes so selection AppBar get Removed.
                                controller.clear();
                              },
                              icon: const Icon(Icons.history),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    onTap: () {
                                      //! we itrat through set of documentIdList and delete each notes with docID.
                                      for (var element in documentIdList) {
                                        FireStoreCurdMethods.deleteTrashNote(
                                            docID: element);
                                      }

                                      //! After deleting we clear the documentIdList set() data type.
                                      documentIdList.clear();
                                      //! Also clear our the Selcted Notes so selection AppBar get Removed.
                                      controller.clear();
                                    },
                                    child: const Center(
                                        child: Text(
                                      "Delete notes permanently",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                  )
                                ];
                              },
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              )
            : AppBar(
                title: const Text("T R A S H"),
              ),
        drawer: const DrawerWidget(
          iconNumber: 2,
        ),
        body: StreamBuilder(
          stream: FireStoreCurdMethods.readTrashNotes(),
          builder: (context, snapshot) {
            //! if SnapShot is has Data.
            if (snapshot.hasData) {
              // Storeing List of trash documents from Collection
              // Here "snapshot.data!.docs" -> data == Collection & docs == List of Document
              List listOfTrashDocs = snapshot.data!.docs;

              //! IF listOfTrashDocs is Empty then.
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
              } else {
                //* Here we are useing Selector provider even we don't need this because
                //* When We select the Trash Notes then SetState get called and LinearProgressIndicator
                //* will show every time when we select the Trash Notes that's why we are using Selector.
                return Selector<LayoutChangeProvider, bool>(
                  selector: (context, isGridView) =>
                      isGridView.isGridViewForTrash,
                  builder: (context, value, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Selector<ToggleProvider, bool>(
                              selector: (context, autoDelete) =>
                                  autoDelete.notesAutoDelete,
                              builder: (context, value, child) {
                                return value
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Notes auto-delete after 7 days.",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                context
                                                    .read<ToggleProvider>()
                                                    .autoDeleteNotes();
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Color.fromARGB(
                                                    255, 71, 71, 71),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }),
                          Selector<ToggleProvider, bool>(
                              selector: (context, longPress) =>
                                  longPress.longPressToSelect,
                              builder: (context, value, child) {
                                return value
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Long press to select notes.",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                context
                                                    .read<ToggleProvider>()
                                                    .longPressToSelectNotes();
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Color.fromARGB(
                                                    255, 71, 71, 71),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }),
                          Expanded(
                            child: DragSelectGridView(
                              gridController: controller,
                              itemCount: listOfTrashDocs.length,
                              padding: const EdgeInsets.all(8),
                              physics: const BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              itemBuilder: (context, index, isSelected) {
                                // geting indivisual document from List of Document's
                                DocumentSnapshot document =
                                    listOfTrashDocs[index];

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
                                    DocumentSnapshot document =
                                        listOfTrashDocs[element];
                                    //! Here we are storing selected notes DocId into Declared Set() Data Type. (WE ARE USED SET() DATATYPE BECAUSE THIS METHOD CALLED SEVRAL TIMES AND IF WE USE LIST THEN IT WILL BE FILLED THE LIST WITH DUPLICATE DOCID'S)
                                    documentIdList.add(document.id);
                                  }
                                }

                                // //? THIS UNDER CODE IS LOGIC FOR TRASH NOTES.
                                if (controller.value.isSelecting) {
                                  //! It is very imp to clear the deletedNotes becuase when we select and again deselecte then deSeleect Notes not removed.
                                  deletedNotes.clear();

                                  //! this will return the selected notes number in the form of set() data type.
                                  var list =
                                      controller.value.selectedIndexes.toList();

                                  for (var element in list) {
                                    DocumentSnapshot document =
                                        listOfTrashDocs[element];
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

                                return NoteContainer(
                                  isSelected: isSelected,
                                  title: title,
                                  note: note,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }

            //! If Snapshot is fetching Data then we show LinearProgressIndicator.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey), // Change the color here
                backgroundColor:
                    Colors.white, // Optional: Change the background color
              );
            }

            //! if there is no Data then return no Notes
            if (snapshot.hasError) {
              return const Center(
                child: Text("No Notes..."),
              );
            }

            //! else condition
            else {
              return const Center(
                child: Text("This Condition will never execute."),
              );
            }
          },
        ),
      ),
    );
  }
}
