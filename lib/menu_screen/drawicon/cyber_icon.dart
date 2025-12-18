import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/drawicon/draw_icon_controller.dart';

// widget de ve 1 icon
class CyberIcon extends StatelessWidget{
  final PlacedIcon icon;
  final double size;
  final VoidCallback? onTap;

  const CyberIcon({
    super.key,
    required this.icon,
    this.size = 36,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: icon.color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon.icon,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
