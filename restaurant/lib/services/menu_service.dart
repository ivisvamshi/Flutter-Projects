//menu_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/menu_item.dart';

class MenuService {
  Future<List<MenuItem>> getMenuItems() async {
    final jsonString = await rootBundle.loadString('assets/menu_data.json');
    final jsonData = json.decode(jsonString);
    final menuItems = (jsonData['menu'] as List)
        .map((item) => MenuItem.fromJson(item))
        .toList();
    return menuItems;
  }
}