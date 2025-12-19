import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'face_service.dart';

class VerifyFace extends StatefulWidget {
  const VerifyFace({super.key});

  @override
  State<VerifyFace> createState() => _VerifyFaceState();
}

class _VerifyFaceState extends State<VerifyFace> {
  final picker = ImagePicker();
  File? _image;
  bool _loading = false;
  String _result = "";
  bool _hasRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkRegister();
  }

  Future<void> _checkRegister() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasRegistered = prefs.containsKey("face_embedding");
    });
  }

  Future<void> _verify(ImageSource source) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("face_embedding");
    if (saved == null) return;

    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _loading = true;
      _result = "";
    });

    final current =
        await FaceService.instance.extractEmbedding(_image!);

    _loading = false;

    if (current == null) {
      setState(() => _result = "Ảnh không hợp lệ");
      return;
    }

    final registered = List<double>.from(jsonDecode(saved));
    final sim = FaceService.instance
        .cosineSimilarity(registered, current);

    setState(() {
      _result = sim > 0.7
          ? "Xác thực thành công ✅ ($sim)"
          : "Xác thực thất bại ❌ ($sim)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác thực khuôn mặt")),
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
            onPressed: _hasRegistered
                ? () => _verify(ImageSource.camera)
                : null,
            child: const Text("Chụp ảnh"),
          ),
          ElevatedButton(
            onPressed: _hasRegistered
                ? () => _verify(ImageSource.gallery)
                : null,
            child: const Text("Chọn ảnh"),
          ),
          const SizedBox(height: 20),
          Text(_hasRegistered
              ? _result
              : "Chưa đăng ký khuôn mặt ❌"),
        ],
      ),
    );
  }
}
