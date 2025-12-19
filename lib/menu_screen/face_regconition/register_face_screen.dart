import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'face_service.dart';

class RegisterFace extends StatefulWidget {
  const RegisterFace({super.key});

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  final picker = ImagePicker();
  File? _image;
  bool _loading = false;
  String _status = "";

  Future<void> _pick(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _loading = true;
      _status = "";
    });

    final embedding =
        await FaceService.instance.extractEmbedding(_image!);

    _loading = false;

    if (embedding == null) {
      setState(() => _status = "Ảnh không hợp lệ (chỉ 1 khuôn mặt)");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("face_embedding", jsonEncode(embedding));

    setState(() => _status = "Đăng ký thành công ✅");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký khuôn mặt")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null)
            Image.file(_image!, height: 200),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          ElevatedButton(
            onPressed: () => _pick(ImageSource.camera),
            child: const Text("Chụp ảnh"),
          ),
          ElevatedButton(
            onPressed: () => _pick(ImageSource.gallery),
            child: const Text("Chọn ảnh"),
          ),
          const SizedBox(height: 20),
          Text(_status),
        ],
      ),
    );
  }
}
