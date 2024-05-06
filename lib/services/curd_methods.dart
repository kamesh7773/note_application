import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreCurdMethods {
  // Geting FireStore Collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  // CREATE: create a new "Note" at FireStore
  Future<void> addNote({String? title, String? note}) {
    return notes.add({
      "title": title,
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

  // READ: get notes from FireStore
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes.snapshots();
    return notesStream;
  }

  // UPDATE: updating "Note" at FireStore

  // DELETE: deleting "Note" at FireStore
}
