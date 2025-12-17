import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_icon_menu.dart';

class CyberBuildService extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const CyberBuildService({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CyberIconMenu(
          backgroundColor: item["color"] as Color,
          icon: item["icon"] as IconData,
          name: item["name"] as String,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item["screen"]),
            );
          },
        );
      },
    );
  }
}
