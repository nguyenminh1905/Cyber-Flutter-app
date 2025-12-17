import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget{
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;

  const CustomTextfield({
    super.key, 
    required this.controller, 
    required this.label, 
    this.obscure = false, 
    this.onToggleObscure,
    this.validator,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,   // <-- thêm vào đây
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onToggleObscure,
              )
            : null,
      ),
    );
  }
}
