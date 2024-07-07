import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreCurdMethods {
  // Geting FireStore Collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  // CREATE: create a new "Note" at FireStore
  Future<void> addNote({String? title, String? note}) {
    return notes.add(
      {
        "title": title,
        "note": note,
        "timestamp": Timestamp.now(),
      },
    );
  }

  // UPDATE: updating "Note" at FireStore
  Future<void> updateNote({String? docID, String? title, String? note}) {
    return notes.doc(docID).update({
      "title": title,
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

  // READ: get notes from FireStore
  Stream<QuerySnapshot> read() {
    final notesStream = notes.snapshots();
    return notesStream;
  }

  // DELETE: deleting "Note" at FireStore
  Future<void> deleteNote({String? docID}) {
    return notes.doc(docID).delete();
  }
}
