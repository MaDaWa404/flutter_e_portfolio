import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'To-Do List', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _todoList = <String>[];

  void loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList = (prefs.getStringList('todos') ?? <String>[]);
    });
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    for (var i = 0; i < _todoList.length; i++) {
      todoWidgets.add(_buildTodoItem(i));
    }
    return todoWidgets;
  }

  Widget _buildTodoItem(int index) {
    return Card(
      color: Colors.blue.shade100,
      child: ListTile(
        title: Text(_todoList.elementAt(index)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteTodoItem(index),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: ListView(children: _getItems()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList.add(title);
      prefs.setStringList('todos', _todoList);
    });
    _textFieldController.clear();
  }

  void _deleteTodoItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList.removeAt(index);
      prefs.setStringList('todos', _todoList);
    });
    _textFieldController.clear();
  }

  Future<dynamic> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
