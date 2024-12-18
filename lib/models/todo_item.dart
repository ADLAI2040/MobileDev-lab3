
class TodoItem {
  bool finish = false;
  String text = "";
  String description = "";

  TodoItem({
    required this.finish,
    required this.text,
    required this.description,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      finish: json['finish'],
      text: json['text'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finish': finish,
      'text': text,
      'description': description,
    };
  }
}

