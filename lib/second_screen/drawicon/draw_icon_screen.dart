import 'package:flutter/material.dart';
import 'cyber_icon.dart';
import 'draw_icon_controller.dart';
import 'draw_icon_widget.dart';

class DrawIconScreen extends StatefulWidget {
  const DrawIconScreen({super.key});

  @override
  State<DrawIconScreen> createState() => _DrawIconScreenState();
}

class _DrawIconScreenState extends State<DrawIconScreen> {
  final controller = CyberIconController();

  /// ICON ĐANG ĐƯỢC CHỌN
  PlacedIcon? selectedIcon;

  /// ICON PICKER
  final List<PlacedIcon> listIcons = [
    PlacedIcon(icon: Icons.home, color: Colors.green, position: Offset.zero),
    PlacedIcon(icon: Icons.star, color: Colors.orange, position: Offset.zero),
    PlacedIcon(icon: Icons.settings, color: Colors.blue, position: Offset.zero),
    PlacedIcon(icon: Icons.person, color: Colors.pink, position: Offset.zero),
    PlacedIcon(icon: Icons.donut_small, color: Colors.yellow, position: Offset.zero),
    PlacedIcon(icon: Icons.alarm, color: Colors.red, position: Offset.zero),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: listIcons.map((item) {
              return CyberIcon(
                icon: item,
                onTap: () => selectedIcon = item,
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
                          icon: selectedIcon!.icon,
                          color: selectedIcon!.color,
                          position: d.localPosition,
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/images/Audi_A8L.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CyberIconLayer(controller: controller),
                ),
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
