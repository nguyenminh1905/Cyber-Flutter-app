import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller quản lý các icon đã được đặt
class CyberIconController extends ChangeNotifier {
  final List<PlacedIcon> _icons = [];

  List<PlacedIcon> get icons {
    return _icons;
  }

  Future<void> load() async {
    final loadIcons = await IconStorage.load();
    _icons.clear();
    _icons.addAll(loadIcons);
    notifyListeners();
  }

  void add(PlacedIcon icon) {
    _icons.add(icon);
    IconStorage.save(_icons);
    notifyListeners();
  }

  void remove(PlacedIcon icon) {
    _icons.remove(icon);
    IconStorage.save(_icons);
    notifyListeners();
  }

  void clear() {
    _icons.clear();
    IconStorage.clear();
    notifyListeners();
  }
}

class PlacedIcon {
  final IconData icon;
  final Color color;
  final Offset position;

  PlacedIcon({required this.icon, required this.color, required this.position});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json["icon"] = icon.codePoint;
    json["fontFamily"] = icon.fontFamily;
    json["color"] = color.value;
    json["dx"] = position.dx;
    json["dy"] = position.dy;

    return json;
  }
  // constructor tao tu json, factory tra ve gia tri tu json
  factory PlacedIcon.fromJson(Map<String, dynamic> json) {
    return PlacedIcon(
      icon: IconData(json["icon"], fontFamily: json["fontFamily"]),
      color: Color(json["color"]),
      position: Offset(
        (json["dx"] as num).toDouble(),
        (json["dy"] as num).toDouble(),
      ),
    );
  }
}

class IconStorage {
  static const _key = "placed_icon";

  static Future<void> save(List<PlacedIcon> icons) async {
    final prefs = await SharedPreferences.getInstance();
    final data = icons.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<List<PlacedIcon>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final List list = jsonDecode(raw);
    return list.map((e) => PlacedIcon.fromJson(e)).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
