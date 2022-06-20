import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudTask {
  final String documentId;
  final String list;
  const CloudTask({
    required this.documentId,
    required this.list,
  });

  CloudTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        list = snapshot.data()[textFieldName] as String;
}

const textFieldName='list';