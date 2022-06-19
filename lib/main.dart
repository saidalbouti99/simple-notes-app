import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import './src/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list',
      theme: ThemeData(
        // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{};
  final _notes = <String>[];

  void _pushSaved() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();

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
          final tiles2= _notes.map(
                (p) {
              return const ListTile(
              );
            },
          );
          final divided2 = tiles2.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];
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
            body: ListView(children: divided2),
          );
        },
      ),
    );
  }

  void _addList() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();

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
      prefs.setStringList('key', _notes);
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
                  _notes.remove('1');
                } else {
                  _saved.add(_suggestions[index]);
                  _notes.add('1');
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
