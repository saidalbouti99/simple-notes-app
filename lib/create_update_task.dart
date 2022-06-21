import 'package:flutter/material.dart';
import 'cloud_task.dart';
import 'firestore_storage.dart';
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
    await _taskService.updateTask(
      documentId: task.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudTask> createOrGetExistingTask(BuildContext context) async {
    final widgetTask = context.getArgument<CloudTask>();

    if (widgetTask != null) {
      _task = widgetTask;
      _textController.text = widgetTask.list;
      return widgetTask;
    }

    final existingTask = _task;
    if (existingTask != null) {
      return existingTask;
    }

    final newTask = await _taskService.createNewTask();
    _task = newTask;
    return newTask;
  }

  void _deleteTaskIfTextIsEmpty() {
    final task = _task;
    if (_textController.text.isEmpty && task != null) {
      _taskService.deleteTask(documentId: task.documentId);
    }
  }

  void _saveTaskIfTextNotEmpty() async {
    final task = _task;
    final text = _textController.text;
    if (task != null && text.isNotEmpty) {
      await _taskService.updateTask(
        documentId: task.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteTaskIfTextIsEmpty();
    _saveTaskIfTextNotEmpty();
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
        future: createOrGetExistingTask(context),
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