import 'package:flutter/material.dart';

class CyberIconMenu extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String name;
  final VoidCallback onPressed;

  const CyberIconMenu({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 30)),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 100,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ),
      ],
    );
  }
}
