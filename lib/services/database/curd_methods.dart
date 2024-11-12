import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreCurdMethods {
  // Getting FireStore Collection
  static final CollectionReference users = FirebaseFirestore.instance.collection("users");

  //! CREATE: Create a new "Note" in FireStore
  static Future<void> addNote({String? title, String? note}) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

      // Creating reference to notes sub-collection inside current user's document
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

  //! CREATE: Move deleted Note to Trash in FireStore
  static Future<void> addNoteToTrash({required Map<String, dynamic> deletedNotes}) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

      // Creating reference to trash sub-collection inside current user's document
      CollectionReference trash = currentUserID.collection('trash');

      return trash.add(deletedNotes);
    } catch (error) {
      throw error.toString();
    }
  }

  //! UPDATE: Update "Note" in FireStore
  static Future<void> updateNote({String? docID, String? title, String? note}) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to notes sub-collection inside current user's document
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

  //! READ: Get notes from FireStore
  static Stream<QuerySnapshot> read() {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to notes sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('notes');

      final notesStream = notes.orderBy("timestamp", descending: false).snapshots();
      return notesStream;
    } catch (error) {
      throw error.toString();
    }
  }

  //! READ: Get trash notes from FireStore
  static Stream<QuerySnapshot> readTrashNotes() {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to trash sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('trash');

      final notesStream = notes.snapshots();
      return notesStream;
    } catch (error) {
      throw error.toString();
    }
  }

  //! DELETE: Delete "Note" from FireStore
  static Future<void> deleteNote({String? docID}) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to notes sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('notes');

      return notes.doc(docID).delete();
    } catch (error) {
      throw error.toString();
    }
  }

  //! DELETE: Delete "TrashNote" from FireStore
  static Future<void> deleteTrashNote({String? docID}) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to trash sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('trash');

      return notes.doc(docID).delete();
    } catch (error) {
      throw error.toString();
    }
  }
}
