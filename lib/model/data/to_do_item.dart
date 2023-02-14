class ToDoItem {
  final String id;
  final String title;

  const ToDoItem({
    required this.id,
    required this.title,
  });

  factory ToDoItem.fromJson(Map<String, dynamic> json) {
    return ToDoItem(
      id: json['id'],
      title: json['title'],
    );
  }
}