import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFaceScreen extends StatefulWidget {
  const RegisterFaceScreen({super.key});

  @override
  State<RegisterFaceScreen> createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {
  File? _image;
  bool _loading = false;
  String _status = "";
  static const String kFaceEmbedding = "face_embedding";
  static const String kFaceImagePath = "face_image_path";

  @override
  void initState() {
    super.initState();
    _loadRegisteredFace();
  }

  Future<void> _loadRegisteredFace() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(kFaceImagePath);

    if (path != null && File(path).existsSync()) {
      setState(() {
        _image = File(path);
        _status = "Đã đăng ký khuôn mặt";
      });
    }
  }

  Future<void> _registerFace() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (picked == null) return;

    setState(() {
      _loading = true;
      _status = "";
    });

    final file = File(picked.path);
    final embedding = await FaceService.instance.extractEmbedding(file);

    if (embedding == null) {
      setState(() {
        _status = "❌ Ảnh không hợp lệ";
        _loading = false;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kFaceEmbedding, jsonEncode(embedding));
    await prefs.setString(kFaceImagePath, file.path);

    setState(() {
      _image = file;
      _status = "✅ Đăng ký khuôn mặt thành công";
      _loading = false;
    });
  }

  Future<void> _deleteFace() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kFaceEmbedding);
    await prefs.remove(kFaceImagePath);

    setState(() {
      _image = null;
      _status = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký khuôn mặt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Chưa đăng ký khuôn mặt",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : Image.file(_image!, fit: BoxFit.contain),
              ),
            ),

            if (_loading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),

            Text(
              _status,
              style: TextStyle(
                fontSize: 15,
                color: _status.contains("❌") ? Colors.red : Colors.green,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("Xóa"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _image == null ? null : _deleteFace,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Đăng ký"),
                    onPressed: _registerFace,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
