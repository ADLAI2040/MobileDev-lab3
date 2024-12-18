import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../widgets/todo_card.dart';

List<Widget> buildTodoCards(
    List<TodoItem> todoList, Function(TodoItem) onDelete, Function() onStatusChange) {
  List<Widget> todoCards = [];
  for (var todoItem in todoList) {
    final todoCard = TodoCard(
      todoItem: todoItem,
      onDelete: () => onDelete(todoItem),
      onStatusChange: onStatusChange,
    );

    todoCards.add(todoCard);
  }

  return todoCards;
}
