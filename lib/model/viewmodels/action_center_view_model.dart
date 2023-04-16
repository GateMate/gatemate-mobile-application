import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gatemate_mobile/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../data/action_item.dart';
import '../firebase/gatemate_auth.dart';

class ActionCenterViewModel extends ChangeNotifier {
  late var actionItems = fetchToDoItems();
  final _authProvider = GetIt.I<GateMateAuth>();

  /// TODO: This currently doesn't work, but I think it has something to do
  ///  with the server.
  Future<ActionItem> createToDoItem(String title) async {
    String authToken;
    try {
      authToken = await _authProvider.getAuthToken();
    } on GateMateAuthException catch (e) {
      Logger().e('Creating an action item failed:\n$e');
      throw Exception('GateMate authentication error! Message:\n$e');
    }

    final response = await http.post(
      Uri.parse('${AppConstants.serverUrl}/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authToken,
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    if (response.statusCode == 201) {
      // TODO: Return item using id generated from backend
      return ActionItem(title: title);
      // return ActionItem(id: id.toString(), title: title);
    } else {
      // TODO: Handle this?
      throw Exception(
        'Failed to create to do item!'
        'Response status code: ${response.statusCode}',
      );
    }
  }

  Future<List<ActionItem>> fetchToDoItems() async {
    String authToken;
    try {
      authToken = await _authProvider.getAuthToken();
    } on GateMateAuthException catch (e) {
      Logger().e('Fetching action items failed:\n$e');
      throw Exception('GateMate authentication error! Message:\n$e');
    }

    final response = await http.get(
      Uri.parse('${AppConstants.serverUrl}/list'),
      headers: {
        HttpHeaders.authorizationHeader: authToken,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rawDataList = jsonDecode(response.body);
      List<ActionItem> toDoItemList = [];

      for (var i = 0; i < rawDataList.length; i++) {
        toDoItemList.add(ActionItem.fromJson(rawDataList[i]));
      }

      return toDoItemList;
    } else {
      // TODO: Handle this!
      //  It's difficult to do anything when the codes coming from the server
      //  are largely unrelated to anything that is happening.
      throw Exception(
        'Failed to fetch to do items!'
        'Response status code: ${response.statusCode}',
      );
    }
  }
}
