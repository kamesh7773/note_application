import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
import 'package:note_application/pages/notes%20pages/add_note_page.dart';
import 'package:note_application/pages/notes%20pages/update_note_page.dart';
import 'package:note_application/providers/layout_change_provider.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //! Geting FireStore Collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  //! Controllar for DragSelectGridView
  final DragSelectGridViewController controller =
      DragSelectGridViewController();

  //! Create object of SharedPreferences
  late final SharedPreferences prefs;

  //! Set for Notes Document ID's [creating Set because it will be initlized with duplicate same type of document.id's]
  Set<String> documentIdList = {};

  //! List of Map of Deleted Notes.
  List<Map<String, dynamic>> deletedNotes = [];

  //! varibles for file data.
  String? imageUrl;

  //! Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imageUrl = prefs.getString('imageUrl');
  }

  //! ethid for initlized SharedPrefernce Object
  Future<void> initSharePref() async {
    prefs = await SharedPreferences.getInstance();
  }

  //! Method that Rebuild the UI Based on the Selection.
  void listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    initSharePref();
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

    return Scaffold(
      //? AppBar() widget
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
                          //! we itrat through set of documentIdList and delete each notes with docID.
                          for (var element in documentIdList) {
                            FireStoreCurdMethods.deleteNote(docID: element);
                          }

                          //! Moveing List of Deleted notes to Trash Data base.
                          try {
                            // Reference to a CurrentUserID document in the main collection
                            DocumentReference currentUserID = users.doc(
                                FirebaseAuth.instance.currentUser!.uid
                                    .toString());

                            // Creating Reference Trash  Sub-Collection insdie currentUserID Users Document.
                            CollectionReference trash =
                                currentUserID.collection('trash');

                            // Adding deleted Notes to trash.
                            for (var element in deletedNotes) {
                              trash.add(element);
                            }
                          } catch (error) {
                            throw error.toString();
                          }

                          //! After Moving deleteNotes to Trash we clear our the deletedNotes list[].
                          deletedNotes.clear();
                          //! After deleting we clear the documentIdList set() data type.
                          documentIdList.clear();
                          //! Also clear our the Selcted Notes so selection AppBar get Removed.
                          controller.clear();
                        },
                        icon: const Icon(Icons.delete))
                    : const SizedBox()
              ],
            )
          : AppBar(
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
                    return IconButton(
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
                              ),
                            ),
                    );
                  },
                ),
                FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    // snapshot begin loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // If snapshot has Data
                    else {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 4, bottom: 2),
                          //! for Image caching
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
      //? Drawer() widget
      drawer: const DrawerWidget(iconNumber: 1),
      //? Body() of App
      body: StreamBuilder(
        stream: FireStoreCurdMethods.read(),
        builder: (context, snapshot) {
          //! IF SnapShot Has Data.
          if (snapshot.hasData) {
            // Storeing List of Document from Collection
            // Here "snapshot.data!.docs" -> data == Collection & docs == List of Document
            List listOfDocs = snapshot.data!.docs;

            return Selector<LayoutChangeProvider, bool>(
              selector: (context, isGridView) =>
                  prefs.getBool('isGridView') ?? false,
              builder: (context, value, child) {
                //! If Grid Layout == TRUE (SHOW GRIDVIEW LAYOUT)
                if (value) {
                  //* DragSelectGridView [This Package is modified do not update this package updation will broke the code]
                  return DragSelectGridView(
                    gridController: controller,
                    itemCount: listOfDocs.length,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    itemBuilder: (context, index, isSelected) {
                      // geting indivisual document from List of Document's
                      DocumentSnapshot document = listOfDocs[index];

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
                          DocumentSnapshot document = listOfDocs[element];
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
                          DocumentSnapshot document = listOfDocs[element];
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

                //! If Grid Layout == FALSE (SHOW LISTVIEW LAYOUT)
                //? (It is not ListView we are mimiking GridView As ListView by providing "crossAxisCount: 1" )
                else {
                  //* DragSelectGridView [This Package is modified do not update this package updation will broke the code]
                  return DragSelectGridView(
                    gridController: controller,
                    itemCount: listOfDocs.length,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 1,
                    itemBuilder: (context, index, isSelected) {
                      // geting indivisual document from List of Document's
                      DocumentSnapshot document = listOfDocs[index];

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
                          DocumentSnapshot document = listOfDocs[element];
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
                          DocumentSnapshot document = listOfDocs[element];
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
            );
          }

          // while snapshot fetching Data showing Loading Indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.grey), // Change the color here
              backgroundColor:
                  Colors.white, // Optional: Change the background color
            );
          }

          // if there is no Data then return no Notes
          if (snapshot.hasError) {
            return const Center(
              child: Text("No Notes..."),
            );
          }
          // else condition
          else {
            return const Center(
              child: Text("else Condition"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "ADD NOTE",
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const AddNotePage(docID: null);
            },
          ));
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
