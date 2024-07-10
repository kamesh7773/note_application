import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
import 'package:note_application/pages/notes%20pages/add_note_page.dart';
import 'package:note_application/pages/notes%20pages/update_note_page.dart';
import 'package:note_application/providers/layout_change_provider.dart';
import 'package:note_application/services/database/curd_methods.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Creating the Instance of Curd Operation class
  FireStoreCurdMethods firestoreservice = FireStoreCurdMethods();

  //! varibles for file data.
  String? imageUrl;

  //! Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imageUrl = prefs.getString('imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //? AppBar() widget
      appBar: AppBar(
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
                    padding:
                        const EdgeInsets.only(right: 10, left: 4, bottom: 2),
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
      drawer: const DrawerWidget(
        iconNumber: 1,
      ),
      //? Body() of App
      body: StreamBuilder(
        stream: firestoreservice.read(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Storeing List of Document from Collection
            // Here "snapshot.data!.docs" -> data == Collection & docs == List of Document
            List listOfDocs = snapshot.data!.docs;

            // flutter_staggered_grid_view
            return Selector<LayoutChangeProvider, bool>(
              selector: (context, isGridView) => isGridView.isGridView,
              builder: (context, value, child) {
                //! If Grid Layout == TRUE (SHOW GRIDVIEW LAYOUT)
                if (value) {
                  return MasonryGridView.builder(
                    itemCount: listOfDocs.length,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
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
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                      );
                    },
                  );
                }

                //! If Grid Layout == FALSE (SHOW LISTVIEW LAYOUT)
                else {
                  return ListView.builder(
                    itemCount: listOfDocs.length,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
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
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                      );
                    },
                  );
                }
              },
            );
          }

          // while snapshot fetching Data showing Loading Indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
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
