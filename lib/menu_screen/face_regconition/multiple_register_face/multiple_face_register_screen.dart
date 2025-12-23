import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_service.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_user_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RegisterMultiFaceScreen extends StatefulWidget {
  const RegisterMultiFaceScreen({super.key});

  @override
  State<RegisterMultiFaceScreen> createState() =>
      _RegisterMultiFaceScreenState();
}

class _RegisterMultiFaceScreenState extends State<RegisterMultiFaceScreen> {
  final _nameCtrl = TextEditingController();
  final picker = ImagePicker();
  bool _loading = false;
  List<FaceUser> _users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _users = await FaceStorage.loadUsers();
    setState(() {});
  }

  Future<void> _register() async {
    if (_nameCtrl.text.trim().isEmpty) { 
      _showMessage("Vui long nhap ten");
      return;
    }

    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (picked == null) return;

    setState(() => _loading = true);

    final file = File(picked.path);
    final embedding = await FaceService.instance.extractEmbedding(file);

    if (embedding == null) {
      setState(() => _loading = false);
      _showMessage("❌ Anh khong hop le");
      return;
    }

    final user = FaceUser(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      embedding: embedding,
    );

    await FaceStorage.addUser(user);
    _nameCtrl.clear();
    await _load();

    _loading = false;
  }

  void _showMessage(String msg) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Thông báo"),
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký nhiều khuôn mặt")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    decoration:
                        const InputDecoration(labelText: "Nhap ten"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _loading ? null : _register,
                ),
              ],
            ),
          ),
          if (_loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (_, i) {
                final u = _users[i];
                return ListTile(
                  title: Text(u.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FaceStorage.deleteUser(u.id);
                      await _load();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
