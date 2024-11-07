import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:note_application/pages/notes%20pages/add_note_page.dart';
import 'package:note_application/pages/notes%20pages/update_note_page.dart';
import 'package:note_application/providers/layout_change_provider.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:note_application/widgets/note_container.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:showcaseview/showcaseview.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  // Declaration of Global Key's for showCaseView.
  final GlobalKey globalKey1 = GlobalKey();
  final GlobalKey globalKey2 = GlobalKey();
  final GlobalKey globalKey3 = GlobalKey();
  final GlobalKey globalKey4 = GlobalKey();
  final GlobalKey globalKey5 = GlobalKey();
  final GlobalKey globalKey6 = GlobalKey();
  final GlobalKey globalKey7 = GlobalKey();
  final GlobalKey globalKey8 = GlobalKey();
  final GlobalKey globalKey9 = GlobalKey();
  final GlobalKey globalKey10 = GlobalKey();

  //! Getting Firestore Collection
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  //! Controller for DragSelectGridView
  final DragSelectGridViewController controller = DragSelectGridViewController();

  //! SharedPreferences object
  late final SharedPreferences prefs;

  //! Set for storing unique Note Document IDs
  Set<String> documentIdList = {};

  //! List of Maps for Deleted Notes
  List<Map<String, dynamic>> deletedNotes = [];

  //! Variable for file data
  String? imageUrl;

  //! Method for fetching current user data from Provider
  Future<void> getUserData() async {
    // Creating an instance of SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imageUrl = prefs.getString('imageUrl');
  }

  //! Method to initialize SharedPreferences object
  Future<void> initSharePref() async {
    prefs = await SharedPreferences.getInstance();
  }

  //! Method to rebuild the UI based on selection of Notes.
  void listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    initSharePref();
    //! Initlization of ShowcaseView widget with provided global keys.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        globalKey1,
        globalKey2,
      ]);
    });
  }

  //! This Method get called when we come back from AddNote Page because we have to initlized the Global in perticular Sequence
  //! So after completing the showcasing of Add Note Page this method get fired for showing the next ShowCase Method.
  void initlizationOfKeys() {
    //! Initlization of ShowcaseView widget with provided global keys.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        globalKey7,
        globalKey8,
      ]);
    });
  }

  @override
  void dispose() {
    controller.addListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! Access Theme Extension Colors
    final myColors = Theme.of(context).extension<MyColors>();

    //! Check if notes are selected
    final isSelected = controller.value.isSelecting;
    int selectedItems = controller.value.amount;

    return Scaffold(
      //? AppBar widget
      appBar: isSelected
          ? AppBar(
              title: selectedItems > 1
                  ? Text(
                      "$selectedItems notes are selected",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    )
                  : Text(
                      "$selectedItems note is selected",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
              centerTitle: true,
              leading: isSelected
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: const Icon(Icons.close))
                  : const SizedBox(),
              actions: [
                isSelected
                    ? IconButton(
                        onPressed: () {
                          //! Iterate through documentIdList and delete each note with docID
                          for (var element in documentIdList) {
                            FireStoreCurdMethods.deleteNote(docID: element);
                          }

                          //! Move list of deleted notes to Trash database
                          for (var element in deletedNotes) {
                            FireStoreCurdMethods.addNoteToTrash(deletedNotes: element);
                          }

                          //! Clear the deletedNotes list after moving to Trash
                          deletedNotes.clear();
                          //! Clear the documentIdList set after deletion
                          documentIdList.clear();
                          //! Clear selected notes to remove the selection AppBar
                          controller.clear();
                        },
                        icon: const Icon(Icons.delete))
                    : const SizedBox()
              ],
            )
          : AppBar(
              leading: IconButton(
                //! Zoom Drawer
                onPressed: () => ZoomDrawer.of(context)!.toggle(),
                icon: const Icon(Icons.menu),
              ),
              title: const Text(
                "N  O  T  E  S",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              actions: [
                //! Change Layout Provider
                Selector<LayoutChangeProvider, bool>(
                  selector: (context, isGridView) => isGridView.isGridView,
                  builder: (context, value, child) {
                    //! ShowCase for Changing Layout (Grid View & List View)
                    return Showcase(
                      key: globalKey1,
                      blurValue: 0.1,
                      description: "Tap to change Layout",
                      targetShapeBorder: const CircleBorder(),
                      overlayOpacity: .75,
                      showArrow: true,
                      child: IconButton(
                        onPressed: () {
                          context.read<LayoutChangeProvider>().changeLayout();
                        },
                        icon: value
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Transform.rotate(
                                  angle: 20.42,
                                  child: Image.asset(
                                    "assets/images/ListView_logo.png",
                                    fit: BoxFit.contain,
                                    isAntiAlias: true,
                                    width: 28,
                                    cacheWidth: 100,
                                    color: myColors!.commanColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Image.asset(
                                  "assets/images/GridView_logo.png",
                                  fit: BoxFit.contain,
                                  isAntiAlias: true,
                                  width: 28,
                                  cacheWidth: 100,
                                  color: myColors!.commanColor,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    // Snapshot is loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(),
                      );
                    }
                    // If snapshot has data
                    else {
                      return GestureDetector(
                        onTap: () {
                          ZoomDrawer.of(context)!.open();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 4, bottom: 2, top: 4),
                          //! For image caching
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
      //? Drawer widget
      // drawer: const DrawerWidget(iconNumber: 1),
      //? Body of App
      body: StreamBuilder(
        stream: FireStoreCurdMethods.read(),
        builder: (context, snapshot) {
          //! If snapshot has data
          if (snapshot.hasData) {
            // Storing list of documents from collection
            List listOfDocs = snapshot.data!.docs;

            return Selector<LayoutChangeProvider, bool>(
              selector: (context, isGridView) => isGridView.isGridView,
              builder: (context, value, child) {
                //! If Grid Layout is TRUE (SHOW GRIDVIEW LAYOUT)
                if (value) {
                  //* DragSelectGridView [This package is modified; do not update as it will break the code]
                  return DragSelectGridView(
                    gridController: controller,
                    itemCount: listOfDocs.length,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    itemBuilder: (context, index, isSelected) {
                      // Getting individual document from list of documents
                      DocumentSnapshot document = listOfDocs[index];

                      // Getting individual document ID
                      String docID = document.id;

                      // Getting map data of each document
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                      // Retrieving data Map<String, Dynamic>
                      String title = data['title'];
                      String note = data['note'];

                      //? Logic for deleting notes while selecting multiple notes
                      // If notes are selected, retrieve their docID
                      if (controller.value.isSelecting) {
                        // Important to clear documentIdList because when we select and deselect, the deselected docID is not removed
                        documentIdList.clear();

                        // This will return the selected notes number in the form of a set
                        var set = controller.value.selectedIndexes;

                        // Storing list of selected notes docID into a set
                        for (var element in set) {
                          DocumentSnapshot document = listOfDocs[element];
                          //! Storing selected notes docID into declared set (using set to avoid duplicates)
                          documentIdList.add(document.id);
                        }
                      }

                      // //? Logic for trash notes
                      if (controller.value.isSelecting) {
                        // Important to clear deletedNotes because when we select and deselect, the deselected notes are not removed
                        deletedNotes.clear();

                        // This will return the selected notes number in the form of a list
                        var list = controller.value.selectedIndexes.toList();

                        for (var element in list) {
                          DocumentSnapshot document = listOfDocs[element];
                          // Getting map data of each document
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

                      return index == 0
                          //! Showcase for showing tap to update note
                          ? Showcase(
                              key: globalKey7,
                              description: "Tap to Update Note",
                              targetShapeBorder: const RoundedRectangleBorder(),
                              disposeOnTap: true,
                              onTargetClick: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ShowCaseWidget(builder: (context) {
                                        return UpdateNotePage(
                                          docID: docID,
                                          title: title,
                                          note: note,
                                          globalKey8: globalKey8,
                                          globalKey9: globalKey9,
                                          globalKey10: globalKey10,
                                        );
                                      });
                                    },
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return ShowCaseWidget(builder: (context) {
                                        return UpdateNotePage(
                                          docID: docID,
                                          title: title,
                                          note: note,
                                          globalKey8: globalKey8,
                                          globalKey9: globalKey9,
                                          globalKey10: globalKey10,
                                        );
                                      });
                                    },
                                  ));
                                },
                                child: NoteContainer(
                                  isSelected: isSelected,
                                  title: title,
                                  note: note,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return ShowCaseWidget(builder: (context) {
                                      return UpdateNotePage(
                                        docID: docID,
                                        title: title,
                                        note: note,
                                        globalKey8: globalKey8,
                                        globalKey9: globalKey9,
                                        globalKey10: globalKey10,
                                      );
                                    });
                                  },
                                ));
                              },
                              child: NoteContainer(
                                isSelected: isSelected,
                                title: title,
                                note: note,
                              ),
                            );
                    },
                  );
                }

                //! If Grid Layout is FALSE (SHOW LISTVIEW LAYOUT)
                //? (Mimicking GridView as ListView by setting "crossAxisCount: 1")
                else {
                  //* DragSelectGridView [This package is modified; do not update as it will break the code]
                  return DragSelectGridView(
                    gridController: controller,
                    itemCount: listOfDocs.length,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 1,
                    itemBuilder: (context, index, isSelected) {
                      // Getting individual document from list of documents
                      DocumentSnapshot document = listOfDocs[index];

                      // Getting individual document ID
                      String docID = document.id;

                      // Getting map data of each document
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                      // Retrieving data Map<String, Dynamic>
                      String title = data['title'];
                      String note = data['note'];

                      //? Logic for deleting notes while selecting multiple notes
                      // If notes are selected, retrieve their docID
                      if (controller.value.isSelecting) {
                        // Important to clear documentIdList because when we select and deselect, the deselected docID is not removed
                        documentIdList.clear();

                        // This will return the selected notes number in the form of a set
                        var set = controller.value.selectedIndexes;

                        // Storing list of selected notes docID into a set
                        for (var element in set) {
                          DocumentSnapshot document = listOfDocs[element];
                          // Storing selected notes docID into declared set (using set to avoid duplicates)
                          documentIdList.add(document.id);
                        }
                      }

                      //? Logic for trash notes
                      if (controller.value.isSelecting) {
                        // Important to clear deletedNotes because when we select and deselect, the deselected notes are not removed
                        deletedNotes.clear();

                        // This will return the selected notes number in the form of a list
                        var list = controller.value.selectedIndexes.toList();

                        for (var element in list) {
                          DocumentSnapshot document = listOfDocs[element];
                          // Getting map data of each document
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

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ShowCaseWidget(builder: (context) {
                                return UpdateNotePage(
                                  docID: docID,
                                  title: title,
                                  note: note,
                                  globalKey8: globalKey8,
                                  globalKey9: globalKey9,
                                  globalKey10: globalKey10,
                                );
                              });
                            },
                          ));
                        },
                        child: NoteContainer(
                          isSelected: isSelected,
                          title: title,
                          note: note,
                        ),
                      );
                    },
                  );
                }
              },
            );
          }

          // While snapshot is fetching data, show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Change the color here
              backgroundColor: Colors.white, // Optional: Change the background color
            );
          }

          // If there is no data, return "No Notes"
          if (snapshot.hasError) {
            return const Center(
              child: Text("No Notes..."),
            );
          }
          // Else condition
          else {
            return const Center(
              child: Text("else Condition"),
            );
          }
        },
      ),
      //! Showcase widget for showing how to add a new note.
      floatingActionButton: Showcase(
        key: globalKey2,
        description: "Tap to create new Note",
        targetShapeBorder: const RoundedRectangleBorder(),
        targetBorderRadius: BorderRadius.circular(16),
        overlayOpacity: .75,
        showArrow: true,
        disposeOnTap: true,
        onTargetClick: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              //! Here it is ensential to wrap our AddNotePage() with ShowCaseWidget Builder becuase AddNotePage() does not have the context of ShowCase.
              return ShowCaseWidget(builder: (context) {
                return AddNotePage(
                  initlizationOfKeys: initlizationOfKeys,
                  globalKey3: globalKey3,
                  globalKey4: globalKey4,
                  globalKey5: globalKey5,
                  globalKey6: globalKey6,
                  docID: null,
                );
              });
            },
          ));
        },
        child: FloatingActionButton(
          tooltip: "ADD NOTE",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ShowCaseWidget(builder: (context) {
                    return AddNotePage(
                      initlizationOfKeys: initlizationOfKeys,
                      globalKey3: globalKey3,
                      globalKey4: globalKey4,
                      globalKey5: globalKey5,
                      globalKey6: globalKey6,
                      docID: null,
                    );
                  });
                },
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
