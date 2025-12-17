import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/second_screen/drawicon/draw_icon_controller.dart';
import 'package:flutter_cyber_app/second_screen/drawicon/draw_icon_widget.dart';

class DrawIconScreen extends StatefulWidget {
  const DrawIconScreen({super.key});

  @override
  State<DrawIconScreen> createState() => _DrawIconScreenState();
}

class _DrawIconScreenState extends State<DrawIconScreen> {
  final controller = CyberIconController();
  Map<String, dynamic>? selectedIcon;
  List<Map<String, dynamic>> listIcons = const [
    {"icon": Icons.home, "color": Colors.green},
    {"icon": Icons.star, "color": Colors.orange},
    {"icon": Icons.settings, "color": Colors.blue},
    {"icon": Icons.person, "color": Colors.pink},
    {"icon": Icons.donut_small, "color": Colors.yellow},
    {"icon": Icons.alarm, "color": Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test")),
      body: Column(
        children: [
          /// ICON PICKER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: listIcons.map((item) {
              return GestureDetector(
                onTap: () => selectedIcon = item,
                child: CircleAvatar(
                  backgroundColor: item["color"] as Color,
                  child: Icon(item["icon"] as IconData, color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          /// IMAGE + ICON LAYER
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (d) {
                      if (selectedIcon == null) return;
                      controller.add(
                        PlacedIcon(
                          icon: selectedIcon!["icon"],
                          color: selectedIcon!["color"],
                          position: d.localPosition,
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/images/Audi_A8L.png",
                      fit: BoxFit.cover,
                      // QUAN TRỌNG
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Positioned.fill(child: CyberIconLayer(controller: controller)),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: controller.clear,
                child: const Text("Clear All"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
