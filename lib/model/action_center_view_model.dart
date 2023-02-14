import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'data/to_do_item.dart';

class ActionCenterViewModel extends ChangeNotifier {
  // TODO: Read up on StreamBuilder for this!
  var actionItems = [
    fetchToDoItem(1),
    fetchToDoItem(3),
    fetchToDoItem(4),
    fetchToDoItem(6),
    fetchToDoItem(437),
  ];
}

Future<ToDoItem> fetchToDoItem(int id) async {
  final response = await http
      .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/list?id=$id'));

  if (response.statusCode == 200) {
    return ToDoItem.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user data');
  }
}
