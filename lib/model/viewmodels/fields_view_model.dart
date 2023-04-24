import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gatemate_mobile/app_constants.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../data/field.dart';

class FieldsViewModel extends ChangeNotifier {
  late Future<Map<String, Field>> allFields;
  Field? currentFieldSelection;

  final _authProvider = GetIt.I<GateMateAuth>();

  FieldsViewModel() {
    allFields = fetchFields();
  }

  void selectField(String fieldId) {
    allFields.then((fields) {
      if (fields.containsKey(fieldId)) {
        currentFieldSelection = fields[fieldId];
      }
      notifyListeners();
    });
  }

  void refresh() {
    allFields = fetchFields();
    allFields.then((value) {
      notifyListeners();
    });
  }

  Future<Map<String, Field>> fetchFields() async {
    String authToken;
    try {
      authToken = await _authProvider.getAuthToken();
    } on GateMateAuthException catch (e) {
      Logger().e('Failed to fetch fields! User not signed in!');
      throw Exception('Failed to fetch fields! Error:\n$e');
    }

    // Use a persistent HTTP client since we have to query
    // potentially many fields by ID.
    final httpClient = http.Client();

    // Get all field ID's
    final fieldsResponse = await _fieldsHttpGet(
      '/getFields',
      authToken,
      httpClient: httpClient,
    );

    if (fieldsResponse.statusCode != 200) {
      final message = 'Failed to fetch fields. Response code: '
          '${fieldsResponse.statusCode}\n${fieldsResponse.body}';

      Logger().e(message);
      throw Exception(message);
    }

    // This is a list of field ID's (which are Strings), but Dart will not
    // allow immediately casting this to List<String>.
    final List<dynamic> decodedFieldIds = jsonDecode(fieldsResponse.body);

    // Time to get field object for each field ID
    final Map<String, Field> fields = {};
    for (var fieldId in decodedFieldIds.cast<String>()) {
      // Build and send HTTP request using persistent client from before
      final endpoint = '/getField?fieldID=$fieldId';
      final response = await _fieldsHttpGet(
        endpoint,
        authToken,
        httpClient: httpClient,
      );

      if (response.statusCode != 200) {
        Logger().e(
          'Error retrieving field (ID: $fieldId)!\n'
          'Response code: ${response.statusCode}\n'
          'Response body: ${response.body}',
        );
        continue;
      }

      // Decode field from JSON response and append to list of fields
      final jsonField = jsonDecode(response.body);
      fields[fieldId] = Field.fromDirectionalJson(fieldId, jsonField);
    }

    // Close HTTP client
    httpClient.close();

    return fields;
  }

  /// Makes a GET request to the app server at `endpoint`, setting `authToken`
  /// in the Authorization header. Can optionally be passed an HTTP client
  /// instance.
  /// TODO: Move this to a generic "utils" library for the rest of the app
  ///  to use.
  Future<http.Response> _fieldsHttpGet(
    String endpoint,
    String authToken, {
    http.Client? httpClient,
  }) {
    if (httpClient == null) {
      return http.get(
        Uri.parse('${AppConstants.serverUrl}$endpoint'),
        headers: {
          HttpHeaders.authorizationHeader: authToken,
        },
      );
    } else {
      return httpClient.get(
        Uri.parse('${AppConstants.serverUrl}$endpoint'),
        headers: {
          HttpHeaders.authorizationHeader: authToken,
        },
      );
    }
  }
}
