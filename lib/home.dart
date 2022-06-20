import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'extensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{};

  late final TextEditingController _task;
  late final TextEditingController _description;

  @override
  void initState(){
    _task=TextEditingController();
    _description=TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _task.dispose();
    _description.dispose();
    super.dispose();
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Done Tasks'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _addList() {

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map(
            (pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList()
          : <Widget>[];
      return Scaffold(
        appBar: AppBar(
            title: Text(
              'Add Task',
              style: context.titleLarge,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _task,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.task,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Task',
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(
                      Icons.info,
                    ),
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    debugPrint('Received click');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text(
                      'Add Task',
                      style: TextStyle(
                        color: Colors.white,
                      )
                  ),

                ),
              ),
            ],
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: context.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: context.labelLarge,
            ),
            leading: Icon(
              alreadySaved ? Icons.check : Icons.circle_outlined,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _addList,
        child: const Icon(Icons.add),
      ),
    );
  }
}
