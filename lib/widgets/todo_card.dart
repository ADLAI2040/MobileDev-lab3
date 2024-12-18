import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoCard extends StatefulWidget {
  final TodoItem todoItem;
  final VoidCallback onDelete;
  final VoidCallback onStatusChange;

  const TodoCard({
    super.key,
    required this.todoItem,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: widget.todoItem.finish ? Colors.blueGrey[100] : Colors.white,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.todoItem.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: !widget.todoItem.finish
                    ? null
                    : const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
                      ),
              ),
              subtitle: Text(
                widget.todoItem.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Checkbox(
                  checkColor: Colors.blue,
                  activeColor: Colors.white,
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  value: widget.todoItem.finish,
                  onChanged: (value) {
                    setState(() {
                      widget.todoItem.finish = value!;
                    });
                    widget.onStatusChange();
                  }),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: widget.todoItem.finish
                          ? Colors.red[600]
                          : Colors.blue,
                    ),
                    onPressed: () {
                      showEditDialog(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: widget.todoItem.finish
                            ? Colors.red[600]
                            : Colors.blue),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEditDialog(BuildContext context) {
    TextEditingController textController =
        TextEditingController(text: widget.todoItem.text);
    TextEditingController descriptionController =
        TextEditingController(text: widget.todoItem.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Редактировать задачу"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: "Название задачи"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Описание"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Отмена"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Сохранить"),
              onPressed: () {
                setState(() {
                  widget.todoItem.text = textController.text;
                  widget.todoItem.description = descriptionController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
