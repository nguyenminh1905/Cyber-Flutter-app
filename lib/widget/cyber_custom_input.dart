import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String title;
  final String? hint;

  const CustomInput({super.key, required this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
