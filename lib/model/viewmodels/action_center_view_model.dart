import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatemate_mobile/app_constants.dart';
import 'package:http/http.dart' as http;

import '../data/action_item.dart';

class ActionCenterViewModel extends ChangeNotifier {
  var actionItems = fetchToDoItems();
}

Future<ActionItem> createToDoItem(String title) async {
  // TODO: The server should generate the item ID
  const id = 67;
  final response = await http.post(
    Uri.parse('${AppConstants.serverUrl}/add?id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': id.toString(),
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // TODO: Return item using id generated from backend
    return ActionItem(id: id.toString(), title: title);
  } else {
    // TODO: Handle this?
    throw Exception(
      'Failed to create to do item!'
      'Response status code: ${response.statusCode}',
    );
  }
}

Future<List<ActionItem>> fetchToDoItems() async {
  final response = await http.get(
    Uri.parse('${AppConstants.serverUrl}/list'),
  );

  if (response.statusCode == 200) {
    List<dynamic> rawDataList = jsonDecode(response.body);
    List<ActionItem> toDoItemList = [];

    for (var i = 0; i < rawDataList.length; i++) {
      toDoItemList.add(ActionItem.fromJson(rawDataList[i]));
    }

    return toDoItemList;
  } else {
    // TODO: Handle this
    throw Exception(
      'Failed to fetch to do items! '
      'Response status code: ${response.statusCode}',
    );
  }
}

Future<ActionItem> fetchToDoItemById(int id) async {
  final response = await http.get(
    Uri.parse('${AppConstants.serverUrl}/list?id=$id'),
  );

  if (response.statusCode == 200) {
    return ActionItem.fromJson(jsonDecode(response.body));
  } else {
    // TODO: Handle this?
    throw Exception(
      'Failed to load user data! '
      'Response status code: ${response.statusCode}',
    );
  }
}
