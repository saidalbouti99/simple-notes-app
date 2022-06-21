import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_task.dart';

class FirebaseStorage {
  final task = FirebaseFirestore.instance.collection('todolist');

  Future<void> deleteTask({required String documentId}) async {
    try {
      await task.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTaskException();
    }
  }

  Future<void> updateTask({
    required String documentId,
    required String text,
  }) async {
    try {
      await task.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateTaskException();
    }
  }

  Stream<Iterable<CloudTask>> allTasks() {
    final allTask = task
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudTask.fromSnapshot(doc)));
    return allTask;
  }

  Future<CloudTask> createNewTask() async {
    final document = await task.add({
      textFieldName: '',
    });
    final fetchedTask = await document.get();
    return CloudTask(
      documentId: fetchedTask.id,
      list: '',
    );
  }


  static final FirebaseStorage _shared =
  FirebaseStorage._sharedInstance();
  FirebaseStorage._sharedInstance();
  factory FirebaseStorage() => _shared;
}

class CouldNotUpdateTaskException extends CloudStorageException {}
class CouldNotDeleteTaskException extends CloudStorageException{
}
class CloudStorageException implements Exception {
  const CloudStorageException();
}
const textFieldName='list';