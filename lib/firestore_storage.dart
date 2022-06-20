import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_note.dart';

class FirebaseStorage {
  final notes = FirebaseFirestore.instance.collection('todolist');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes() {
    final allNotes = notes
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<CloudNote> createNewNote() async {
    final document = await notes.add({
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      list: '',
    );
  }


  static final FirebaseStorage _shared =
  FirebaseStorage._sharedInstance();
  FirebaseStorage._sharedInstance();
  factory FirebaseStorage() => _shared;
}

class CouldNotUpdateNoteException extends CloudStorageException {}
class CouldNotDeleteNoteException extends CloudStorageException{
}
class CloudStorageException implements Exception {
  const CloudStorageException();
}
const textFieldName='list';