import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/providers/layout_change_provider.dart';
import 'package:note_application/providers/toggle_provider.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:note_application/widgets/note_container.dart';
import 'package:provider/provider.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  //! Getting Firestore Collection
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  //! Controller for DragSelectGridView
  final DragSelectGridViewController controller = DragSelectGridViewController();

  //! Set for Note Document IDs [using Set to avoid duplicate document IDs]
  Set<String> documentIdList = {};

  //! List of Maps for Selected Trash Notes
  List<Map<String, dynamic>> deletedNotes = [];

  //! Method to Rebuild the UI Based on Selection
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
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! Access Theme Extension Colors
    final myColors = Theme.of(context).extension<MyColors>();

    //! Check if Notes are Selected
    final isSelected = controller.value.isSelecting;
    int selectedItems = controller.value.amount;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
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
                                //! Iterate through documentIdList and delete each note with docID
                                for (var element in documentIdList) {
                                  FireStoreCurdMethods.deleteTrashNote(docID: element);
                                }

                                //! Move List of Trash Notes to Notes Database
                                try {
                                  // Reference to the current user's document in the main collection
                                  DocumentReference currentUserID = users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

                                  // Creating Reference to Trash Sub-Collection inside currentUserID Users Document
                                  CollectionReference notes = currentUserID.collection('notes');

                                  // Adding deleted Notes to trash
                                  for (var element in deletedNotes) {
                                    notes.add(element);
                                  }
                                } catch (error) {
                                  throw error.toString();
                                }

                                //! After Moving Trash Notes to Notes, clear the Trash Notes list
                                deletedNotes.clear();
                                //! After deleting, clear the documentIdList set
                                documentIdList.clear();
                                //! Also clear the Selected Notes so the selection AppBar is removed
                                controller.clear();
                              },
                              icon: const Icon(Icons.history),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    onTap: () {
                                      //! Iterate through documentIdList and delete each note with docID
                                      for (var element in documentIdList) {
                                        FireStoreCurdMethods.deleteTrashNote(docID: element);
                                      }

                                      //! After deleting, clear the documentIdList set
                                      documentIdList.clear();
                                      //! Also clear the Selected Notes so the selection AppBar is removed
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
                leading: IconButton(
                  //! Zoom Drawer
                  onPressed: () => ZoomDrawer.of(context)!.toggle(),
                  icon: const Icon(Icons.menu),
                ),
                title: const Text("T R A S H"),
              ),
        body: StreamBuilder(
          stream: FireStoreCurdMethods.readTrashNotes(),
          builder: (context, snapshot) {
            //! If Snapshot has Data
            if (snapshot.hasData) {
              // Storing List of trash documents from Collection
              // Here "snapshot.data!.docs" -> data == Collection & docs == List of Document
              List listOfTrashDocs = snapshot.data!.docs;

              //! If listOfTrashDocs is Empty
              if (listOfTrashDocs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Trash.png",
                        width: 150,
                        fit: BoxFit.contain,
                        color: myColors!.commanColor,
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
                //* Using Selector provider to avoid showing LinearProgressIndicator every time when selecting Trash Notes
                return Selector<LayoutChangeProvider, bool>(
                  selector: (context, isGridView) => isGridView.isGridViewForTrash,
                  builder: (context, value, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Selector<ToggleProvider, bool>(
                              selector: (context, autoDelete) => autoDelete.notesAutoDelete,
                              builder: (context, value, child) {
                                return value
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Notes auto-delete after 7 days.",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                context.read<ToggleProvider>().autoDeleteNotes();
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }),
                          Selector<ToggleProvider, bool>(
                              selector: (context, longPress) => longPress.longPressToSelect,
                              builder: (context, value, child) {
                                return value
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Long press to select notes.",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                context.read<ToggleProvider>().longPressToSelectNotes();
                                              },
                                              icon: const Icon(
                                                Icons.close,
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
                                // Getting individual document from List of Documents
                                DocumentSnapshot document = listOfTrashDocs[index];

                                // Getting individual document ID
                                String docID = document.id;

                                // Getting Map Data of each Document
                                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                // Retrieving Data Map<String,Dynamic>
                                String title = data['title'];
                                String note = data['note'];

                                //? Logic for Deleting Notes while Selecting Multiple Notes
                                //! If Notes are selected, retrieve their docID
                                if (controller.value.isSelecting) {
                                  //! Important to clear the documentIdList because when we select and deselect, the deselected docID is not removed
                                  documentIdList.clear();

                                  //! This will return the selected notes number in the form of a set
                                  var set = controller.value.selectedIndexes;

                                  //! Storing List of Selected Notes docID into Set
                                  for (var element in set) {
                                    DocumentSnapshot document = listOfTrashDocs[element];
                                    //! Storing selected notes DocId into Declared Set (Using Set because this method is called several times and using List would fill it with duplicate docIDs)
                                    documentIdList.add(document.id);
                                  }
                                }

                                // //? Logic for Trash Notes
                                if (controller.value.isSelecting) {
                                  //! Important to clear the deletedNotes because when we select and deselect, the deselected Notes are not removed
                                  deletedNotes.clear();

                                  //! This will return the selected notes number in the form of a list
                                  var list = controller.value.selectedIndexes.toList();

                                  for (var element in list) {
                                    DocumentSnapshot document = listOfTrashDocs[element];
                                    // Getting Map Data of each Document
                                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

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

            //! If Snapshot is fetching Data, show LinearProgressIndicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Change the color here
                backgroundColor: Colors.white, // Optional: Change the background color
              );
            }

            //! If there is no Data, return no Notes
            if (snapshot.hasError) {
              return const Center(
                child: Text("No Notes..."),
              );
            }

            //! Else condition
            else {
              return const Center(
                child: Text("This condition will never execute."),
              );
            }
          },
        ),
      ),
    );
  }
}
