import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25, color: Colors.blue),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis, 
            ),
          ],
        ),
      ),
    );
  }
}
