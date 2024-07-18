import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreCurdMethods {
  // Geting FireStore Collection
  static final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  //! CREATE: create a new "Note" at FireStore
  static Future<void> addNote({String? title, String? note}) {
    try {
      // Reference to a CurrentUserID document in the main collection
      DocumentReference currentUserID =
          users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

      // Creating Reference of notes Sub-Collection insdie currentUserID Users Document.
      CollectionReference notes = currentUserID.collection('notes');

      return notes.add(
        {
          "title": title,
          "note": note,
          "timestamp": Timestamp.now(),
        },
      );
    } catch (error) {
      throw error.toString();
    }
  }

  //! CREATE: Move deleted Note to Trash at FireStore
  static Future<void> addNoteToTrash(
      {required Map<String, dynamic> deletedNotes}) {
    try {
      // Reference to a CurrentUserID document in the main collection
      DocumentReference currentUserID =
          users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

      // Creating Reference Trash  Sub-Collection insdie currentUserID Users Document.
      CollectionReference trash = currentUserID.collection('trash');

      return trash.add(deletedNotes);
    } catch (error) {
      throw error.toString();
    }
  }

  //! UPDATE: updating "Note" at FireStore
  static Future<void> updateNote({String? docID, String? title, String? note}) {
    try {
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
    } catch (error) {
      throw error.toString();
    }
  }

  //! READ: get notes from FireStore
  static Stream<QuerySnapshot> read() {
    try {
      // Reference to a CurrentUserID document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating Reference of Sub-Collection insdie currentUserID Document.
      CollectionReference notes = currentUserID.collection('notes');

      final notesStream = notes.snapshots();
      return notesStream;
    } catch (error) {
      throw error.toString();
    }
  }

  //! READ: get trash notes from FireStore
  static Stream<QuerySnapshot> readTrashNotes() {
    try {
      // Reference to a CurrentUserID document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating Reference of Sub-Collection insdie currentUserID Document.
      CollectionReference notes = currentUserID.collection('trash');

      final notesStream = notes.snapshots();
      return notesStream;
    } catch (error) {
      throw error.toString();
    }
  }

  //! DELETE: deleting "Note" at FireStore
  static Future<void> deleteNote({String? docID}) {
    try {
      // Reference to a CurrentUserID document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating Reference of Sub-Collection insdie currentUserID Document.
      CollectionReference notes = currentUserID.collection('notes');

      return notes.doc(docID).delete();
    } catch (error) {
      throw error.toString();
    }
  }

  //! DELETE: deleting "TrashNote" at FireStore
  static Future<void> deleteTrashNote({String? docID}) {
    try {
      // Reference to a CurrentUserID document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating Reference of Sub-Collection insdie currentUserID Document.
      CollectionReference notes = currentUserID.collection('trash');

      return notes.doc(docID).delete();
    } catch (error) {
      throw error.toString();
    }
  }
}
