import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'face_service.dart';

class RegisterFace extends StatefulWidget {
  final File image;

  const RegisterFace({super.key, required this.image});

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  bool _loading = true;
  String _status = "";

  @override
  void initState() {
    super.initState();
    _register();
  }

  Future<void> _register() async {
    final embedding = await FaceService.instance.extractEmbedding(widget.image);

    if (embedding == null) {
      setState(() {
        _status = "❌ Ảnh không hợp lệ (chỉ 1 khuôn mặt)";
        _loading = false;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("face_embedding", jsonEncode(embedding));

    setState(() {
      _status = "✅ Đăng ký thành công";
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký khuôn mặt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                child: Image.file(widget.image, fit: BoxFit.contain),
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 12),
              Text(
                _status,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _status.contains("❌") ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
