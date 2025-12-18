import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;

  const CustomInput({super.key, required this.title, this.hint, this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: title,  
        floatingLabelBehavior: FloatingLabelBehavior.always, 
        
        labelStyle: const TextStyle( 
          fontWeight: FontWeight.bold,
          color: Colors.black, 
          fontSize: 16,
        ),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
