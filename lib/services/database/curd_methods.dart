import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreCurdMethods {
  // Geting FireStore Collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  //! CREATE: create a new "Note" at FireStore
  Future<void> addNote({String? title, String? note}) {
    // Reference to a CurrentUserID document in the main collection
    DocumentReference currentUserID = users.doc(
      FirebaseAuth.instance.currentUser!.uid.toString(),
    );

    // Creating Reference of Sub-Collection insdie currentUserID Document.
    CollectionReference notes = currentUserID.collection('notes');

    return notes.add(
      {
        "title": title,
        "note": note,
        "timestamp": Timestamp.now(),
      },
    );
  }

  //! UPDATE: updating "Note" at FireStore
  Future<void> updateNote({String? docID, String? title, String? note}) {
    // Reference to a CurrentUserID document in the main collection
    DocumentReference currentUserID = users.doc(
      FirebaseAuth.instance.currentUser!.uid.toString(),
    );

    // Creating Reference of Sub-Collection insdie currentUserID Document.
    CollectionReference notes = currentUserID.collection('notes');

    return notes.doc(docID).update({
      "title": title,
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

  //! READ: get notes from FireStore
  Stream<QuerySnapshot> read() {
    // Reference to a CurrentUserID document in the main collection
    DocumentReference currentUserID = users.doc(
      FirebaseAuth.instance.currentUser!.uid.toString(),
    );

    // Creating Reference of Sub-Collection insdie currentUserID Document.
    CollectionReference notes = currentUserID.collection('notes');

    final notesStream = notes.snapshots();
    return notesStream;
  }

  //! DELETE: deleting "Note" at FireStore
  Future<void> deleteNote({String? docID}) {
    // Reference to a CurrentUserID document in the main collection
    DocumentReference currentUserID = users.doc(
      FirebaseAuth.instance.currentUser!.uid.toString(),
    );

    // Creating Reference of Sub-Collection insdie currentUserID Document.
    CollectionReference notes = currentUserID.collection('notes');

    return notes.doc(docID).delete();
  }
}
