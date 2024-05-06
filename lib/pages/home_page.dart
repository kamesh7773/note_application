import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Geting FireStore Collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  // -----------------------------------
  // Method for Create Note at FireStore
  // -----------------------------------
  Future<void> create(String title, String note) {
    return notes.add(
      {
        "title": title,
        "note": note,
        "timestamp": Timestamp.now(),
      },
    );
  }

  // -----------------------------------
  // Method for Update Note at FireStore
  // -----------------------------------
  Future<void> update(String docID, String title, String note) {
    return notes.doc(docID).update({
      "title": title,
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

  // -----------------------------------
  // Method for Read Note from FireStore
  // -----------------------------------
  Stream<QuerySnapshot> read() {
    final notesStream = notes.snapshots();
    return notesStream;
  }

  // ------------------------------------
  // Method for Delete Note fromFireStore
  // ------------------------------------
  Future<void> deleteNote(String? docID) {
    return notes.doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: const Text(
          "N  O  T  E  S",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: StreamBuilder(
          stream: read(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Storing Document into List
              List<QueryDocumentSnapshot> noteList = snapshot.data!.docs;
              debugPrint(noteList.toString());

              for (var i = 0; i < noteList.length; i++) {
                // geting indivisual document from List of Document's
                DocumentSnapshot document = noteList[i];
                // getting indivsual document ID
                String docID = document.id;

                // getting Map Data of each Document
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                // retiveing Data Map<String,Dynamic>
                String title = data['title'];
                String note = data['note'];
                var timeStamp = data['timestamp'];

                debugPrint("Doc ID : $docID");
                debugPrint("Title : $title");
                debugPrint("Note : $note");
                debugPrint("TIme : $timeStamp");
              }
            }
            return Column(
              children: [
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Create Note'),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Update Note'),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Delete Note'),
                ),
                const SizedBox(height: 80),
              ],
            );
          },
        ),
      ),
    );
  }
}
