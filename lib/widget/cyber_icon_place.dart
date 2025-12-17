import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CyberIconDraw extends StatefulWidget {
  final String imagePath;
  final double height;
  final double iconSize;
  /// danh sách icon chọn
  final List<Map<String, dynamic>> listIcons;

  final ValueNotifier<List<PlacedIcon>> placedIconsNotifier;

  const CyberIconDraw({
    super.key,
    required this.imagePath,
    required this.listIcons,
    required this.placedIconsNotifier,
    this.height = 300,
    this.iconSize = 36,
  });

  @override
  State<CyberIconDraw> createState() => _CyberIconDrawState();
}

class _CyberIconDrawState extends State<CyberIconDraw> {
  Map<String, dynamic>? selectedIcon;

  void _update(List<PlacedIcon> list) {
    widget.placedIconsNotifier.value = list;
    IconStorage.save(list);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.listIcons.map((item) {
            return _buildIcon(
              icon: item["icon"],
              color: item["color"],
              onTap: () => selectedIcon = item,
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        //image
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (details) {
                    if (selectedIcon == null) return;
                    final list = List<PlacedIcon>.from(
                      widget.placedIconsNotifier.value,
                    );

                    list.add(
                      PlacedIcon(
                        icon: selectedIcon!["icon"],
                        color: selectedIcon!["color"],
                        position: details.localPosition,
                      ),
                    );

                    _update(list);
                  },
                  child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                ),
              ),

              /// icon đã đặt
              ValueListenableBuilder<List<PlacedIcon>>(
                valueListenable: widget.placedIconsNotifier,
                builder: (_, icons, _) {
                  return Stack(
                    children: icons.map((p) {
                      return Positioned(
                        left: p.position.dx - widget.iconSize / 2,
                        top: p.position.dy - widget.iconSize / 2,
                        child: _buildIcon(
                          icon: p.icon,
                          color: p.color,
                          onTap: () {
                            final list = List<PlacedIcon>.from(icons)
                              ..remove(p);
                            _update(list);
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: () async {
            _update([]);
            await IconStorage.clear();
          },
          child: const Text("Clear All"),
        ),
      ],
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: widget.iconSize,
        height: widget.iconSize,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: widget.iconSize * 0.45, color: Colors.white),
      ),
    );
  }
}

class PlacedIcon {
  final IconData icon;
  final Color color;
  final Offset position;

  PlacedIcon({required this.icon, required this.color, required this.position});

  Map<String, dynamic> toJson() => {
    "icon": icon.codePoint,
    "fontFamily": icon.fontFamily,
    "color": color.value,
    "dx": position.dx,
    "dy": position.dy,
  };

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
  static const _key = "placed_icons";

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
