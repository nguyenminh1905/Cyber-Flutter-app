import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CyberSlidableAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final void Function(BuildContext)? onPressed;

  const CyberSlidableAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      flex: 1,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      onPressed: onPressed,
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: icon,
      label: label,
    );
  }
}
