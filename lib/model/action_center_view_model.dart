import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActionCenterViewModel extends ChangeNotifier {
  
  var actionItems = [
    'Severe weather alert',
    'Scheduled gate raise...',
    'Crop measurement reminder',
  ];
}