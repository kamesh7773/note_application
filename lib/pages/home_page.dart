import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_application/pages/add_note_page.dart';
import 'package:note_application/pages/update_note_page.dart';
import 'package:note_application/services/curd_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Creating the Instance of Curd Operation class
  FireStoreCurdMethods firestoreservice = FireStoreCurdMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "N  O  T  E  S",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: firestoreservice.read(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Storeing List of Document from Collection
            // Here "snapshot.data!.docs" -> data == Collection & docs == List of Document
            List listOfDocs = snapshot.data!.docs;

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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              note,
                              style: const TextStyle(
                                fontSize: 16,
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

          // while snapshot fetching Data showing Loading Indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          // if there is no Data then return no Notes
          if (snapshot.hasError) {
            return const Center(
              child: Text("No Notes..."),
            );
          } else {
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
