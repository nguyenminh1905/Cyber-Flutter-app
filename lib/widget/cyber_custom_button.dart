//khoi tao 1 button custom
import 'package:flutter/material.dart';

class CyberButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const CyberButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
