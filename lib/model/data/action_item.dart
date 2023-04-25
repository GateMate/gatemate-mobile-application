class ActionItem {
  final String title;
  final String? id;

  const ActionItem({
    required this.title,
    this.id,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      title: json['title'],
      id: json['id'],
    );
  }
}
