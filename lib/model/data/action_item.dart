class ActionItem {
  final String id;
  final String title;

  const ActionItem({
    required this.id,
    required this.title,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      id: json['id'],
      title: json['title'],
    );
  }
}
