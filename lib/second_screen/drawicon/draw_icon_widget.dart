import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/second_screen/drawicon/cyber_icon.dart';
import 'package:flutter_cyber_app/second_screen/drawicon/draw_icon_controller.dart';

/// Lớp hiển thị các icon đã được đặt lên canvas
class CyberIconLayer extends StatelessWidget {
  final CyberIconController controller;
  final double iconSize;

  const CyberIconLayer({
    super.key,
    required this.controller,
    this.iconSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: controller.icons.map((p) {
            return Positioned(
              left: p.position.dx - iconSize / 2,
              top: p.position.dy - iconSize / 2,
              child: CyberIcon(
                icon: p,
                size: iconSize,
                onTap: () => controller.remove(p),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
