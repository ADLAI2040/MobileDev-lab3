import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';
import '../models/todo_list.dart';

class TodoStorage {
  static Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('todoList');
    if (jsonString != null) {
      List<dynamic> decodedList = json.decode(jsonString);
      TodoList.clear();
      TodoList.addAll(
          decodedList.map((item) => TodoItem.fromJson(item)).toList());
    }
  }

  static Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString =
        json.encode(TodoList.map((item) => item.toJson()).toList());
    await prefs.setString('todoList', jsonString);
  }
}
