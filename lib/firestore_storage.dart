import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_task.dart';

class FirebaseStorage {
  final task = FirebaseFirestore.instance.collection('todolist');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await task.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await task.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudTask>> allNotes() {
    final allNotes = task
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudTask.fromSnapshot(doc)));
    return allNotes;
  }

  Future<CloudTask> createNewNote() async {
    final document = await task.add({
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudTask(
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