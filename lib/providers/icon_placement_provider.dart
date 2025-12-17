import 'package:flutter/material.dart';

class IconPlacementProvider extends ChangeNotifier {
  IconData? selectedIcon;
  Color? selectedColor;

  final List<Map<String, dynamic>> placedIcons = [];

  void select(IconData icon, Color color) {
    selectedIcon = icon;
    selectedColor = color;
    notifyListeners();
  }

  void addIcon(double x, double y) {
    if (selectedIcon == null) return;

    placedIcons.add({
      "icon": selectedIcon,
      "color": selectedColor,
      "x": x,
      "y": y,
    });

    notifyListeners();
  }

  void clear() {
    placedIcons.clear();
    notifyListeners();
  }
}
