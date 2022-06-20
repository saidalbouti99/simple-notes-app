import 'package:flutter/material.dart';
import 'cloud_task.dart';

typedef TaskCallback = void Function(CloudTask task);

class TaskListView extends StatelessWidget {
  final Iterable<CloudTask> list;
  final TaskCallback onDeleteNote;
  final TaskCallback onTap;

  const TaskListView({
    Key? key,
    required this.list,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final task = list.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(task);
          },
          title: Text(
            task.list,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              onDeleteNote(task);
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}