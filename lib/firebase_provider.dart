import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_projects/note_model.dart';

class FirebaseProvider {
  static FirebaseFirestore mFireStore = FirebaseFirestore.instance;
  static String collectionNotes = "notes";


  /// add note
  static addNote(NoteModel newNote){
    mFireStore
        .collection(collectionNotes)
        .add(newNote.toDoc())
        .then((value) {
          mFireStore.collection(collectionNotes).doc(value.id).update(
              {"noteId": value.id});

    })
        .onError((error, stackTrace){
          //error

    });
  }

  /// update note
  static Future<void> updateNote(NoteModel updateNote){
    return mFireStore
        .collection(collectionNotes)
        .doc(updateNote.noteId)
        .update(updateNote.toDoc())
    ;
  }

  /// delete note
  static Future<void> deleteNote(NoteModel note){
    return mFireStore
        .collection(collectionNotes)
        .doc(note.noteId)
        .delete()
    ;
  }

  /// fetch all notes
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllNotes(){
    return mFireStore.collection(collectionNotes).snapshots();
  }

}