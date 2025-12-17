import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/second_screen/drawicon/draw_icon_controller.dart';

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
      builder: (_, _) {
        return Stack(
          children: controller.icons.map((p) {
            return Positioned(
              left: p.position.dx - iconSize / 2,
              top: p.position.dy - iconSize / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque, 
                onTap: () {
                  controller.remove(p);
                },
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: p.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      p.icon,
                      size: iconSize * 0.45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
