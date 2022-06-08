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
    setState(() {});
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    for (var i = 0; i < _todoList.length; i++) {
      todoWidgets.add(_buildTodoItem(i));
    }
    return todoWidgets;
  }

  Widget _buildTodoItem(int index) {
    return Text(_todoList.elementAt(index));
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
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }

  Future<dynamic> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
          );
        });
  }
}
