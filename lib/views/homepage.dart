import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/todo_list.dart';
import '../utils/build_todoCard.dart';
import '../utils/todo_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String filter = 'all';

  void addNewTodo(String text, String description) {
    setState(() {
      TodoList.add(TodoItem(
        finish: false,
        text: text,
        description: description,
      ));
      TodoStorage.saveTodos();
    });
  }

  void showAddTodoDialog() {
    final TextEditingController _textController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Добавить новое задание"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: "Текст задания",
                  hintText: "Введите текст задания",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Описание задания",
                  hintText: "Введите описание задания",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                final text = _textController.text.trim();
                final description = _descriptionController.text.trim();

                if (text.isNotEmpty) {
                  addNewTodo(text, description);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Текст задания не может быть пустым")),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text("Добавить"),
            ),
          ],
        );
      },
    );
  }

  List<TodoItem> getFilteredTodoList() {
    switch (filter) {
      case 'completed':
        return TodoList.where((item) => item.finish).toList();
      case 'incomplete':
        return TodoList.where((item) => !item.finish).toList();
      default:
        return TodoList;
    }
  }

  @override
  void initState() {
    super.initState();
    TodoStorage.loadTodos().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          "TODO",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Все'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Выполненные'),
              ),
              const PopupMenuItem(
                value: 'incomplete',
                child: Text('Невыполненные'),
              ),
            ],
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: buildTodoCards(getFilteredTodoList(), (item) {
              setState(() {
                TodoList.remove(item);
                TodoStorage.saveTodos();
              });
            },
            () {
              setState(() {});
            },
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: showAddTodoDialog,
            child: const Icon(Icons.add, color: Colors.blue),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
