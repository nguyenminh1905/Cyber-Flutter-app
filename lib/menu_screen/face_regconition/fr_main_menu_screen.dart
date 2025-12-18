import 'package:flutter/material.dart';

class FrMainMenuScreen extends StatelessWidget{
  const FrMainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Recognition Menu"),
      ),
      body: const Center(
        child: Text("Face Recognition Main Menu Screen"),
      ),
    );
  }
}