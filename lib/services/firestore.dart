import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_keep_note_clone/model/myNoteModel.dart';
import 'package:google_keep_note_clone/services/db.dart';
import 'package:google_keep_note_clone/services/login_info.dart';

class FireDB {
  //CRUD

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create
  createNewNoteFirestore(Note note,String id) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("userNotes")
            .doc(id)
            .set({
          "Title": note.title,
          "Content": note.content,
          "Date": note.createdTime,
        }).then((_) {
          print("DATA ADDED SUCCESSFULLY");
        });
      }
    });
  }
  // Read
  getAllStoredNotes() async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user!.email)
        .collection("userNotes")
        .orderBy("Date")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map note = result.data();

        // Convert Timestamp to DateTime
        DateTime dateTime = note["Date"].toDate();
        NotesDatabase.instance.InsertEntry(Note(
            title: note["Title"],
            content: note["Content"],
            createdTime: dateTime,
            pin: false,
            isArchive: false));

      });

    });
  }

  // Update
  updateNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if(isSyncOn.toString() == "true"){
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("userNotes")
            .doc(note.id.toString())
            .update({"Title": note.title.toString(), "Content": note.content}).then((_) {
          print("Added Successfully");
        });
      }
    });
  }

  // Delete
  deleteNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("userNotes")
            .doc(note.id.toString())
            .delete()
            .then((_) {
          print("Data deleted successfully");
        });
      }
    });
}
}
