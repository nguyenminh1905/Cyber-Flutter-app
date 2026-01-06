import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_service.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_user_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RealTimeRecognizeMultiFaceScreen extends StatefulWidget {
  const RealTimeRecognizeMultiFaceScreen({super.key});

  @override
  State<RealTimeRecognizeMultiFaceScreen> createState() =>
      _RecognizeMultiFaceScreenState();
}

class _RecognizeMultiFaceScreenState extends State<RealTimeRecognizeMultiFaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Test RealTime detection",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
    );
  }
}
