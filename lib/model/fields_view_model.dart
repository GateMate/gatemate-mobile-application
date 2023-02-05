import 'package:flutter/material.dart';

class FieldsViewModel extends ChangeNotifier {

  var fieldNamesPlaceholder = {'Field 1', 'Field B', 'Field of Real Numbers'};
  void addField(String fieldName) {
    fieldNamesPlaceholder.add(fieldName);
    notifyListeners();
  }

  var currentFieldSelection = 'Field 1';
  void selectField(String fieldName) {
    if (fieldNamesPlaceholder.contains(fieldName)) {
      currentFieldSelection = fieldName;
      notifyListeners();
    }
  }
}