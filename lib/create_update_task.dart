import 'package:flutter/material.dart';
import 'cloud_task.dart';
import 'firestore_storage.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart' show BuildContext, ModalRoute;


class CreateUpdateTaskView extends StatefulWidget {
  const CreateUpdateTaskView({Key? key}) : super(key: key);

  @override
  _CreateUpdateTaskViewState createState() => _CreateUpdateTaskViewState();
}

class _CreateUpdateTaskViewState extends State<CreateUpdateTaskView> {
  CloudTask? _task;
  late final FirebaseStorage _taskService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _taskService = FirebaseStorage();
    _textController = TextEditingController();
    super.initState();
  }


  void _textControllerListener() async {
    final task = _task;
    if (task == null) {
      return;
    }
    final text = _textController.text;
    await _taskService.updateNote(
      documentId: task.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudTask> createOrGetExistingNote(BuildContext context) async {
    final widgetTask = context.getArgument<CloudTask>();

    if (widgetTask != null) {
      _task = widgetTask;
      _textController.text = widgetTask.list;
      return widgetTask;
    }

    final existingNote = _task;
    if (existingNote != null) {
      return existingNote;
    }

    final newNote = await _taskService.createNewNote();
    _task = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _task;
    if (_textController.text.isEmpty && note != null) {
      _taskService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _task;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _taskService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.task,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Task',
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}