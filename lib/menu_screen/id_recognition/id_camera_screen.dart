import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/id_recognition/id_result_screen.dart';
import 'package:image_picker/image_picker.dart';

class ReadCCCDCardScreen extends StatefulWidget {
  @override
  State<ReadCCCDCardScreen> createState() => _ReadCCCDCardScreenState();
}

class _ReadCCCDCardScreenState extends State<ReadCCCDCardScreen> {
  File? frontImage;
  File? backImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool isFront) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() {
        if (isFront) {
          frontImage = File(file.path);
        } else {
          backImage = File(file.path);
        }
      });
    }
  }

  bool get canRecognize => frontImage != null || backImage != null;

//   bool isCccd(String text) {
//   final t = text.toLowerCase();
//   int score = 0;

//   if (t.contains('can cuoc cong dan')) score++;
//   if (RegExp(r'\b\d{12}\b').hasMatch(t)) score++;
//   if (t.contains('viet nam')) score++;
//   if (t.contains('date of birth') || t.contains('ngay sinh')) score++;
//   if (t.contains('<<<')) score++; // MRZ

//   return score >= 3;
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhận diện CCCD')),
      body: Column(
        children: [
          Row(
            children: [
              _buildImageBox(
                title: 'Mặt trước',
                image: frontImage,
                onPick: () => pickImage(true),
              ),
              _buildImageBox(
                title: 'Mặt sau',
                image: backImage,
                onPick: () => pickImage(false),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: canRecognize
                  ? () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CCCDResultScreen(
                            frontImage: frontImage,
                            backImage: backImage,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Nhận dạng'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBox({
    required String title,
    required File? image,
    required VoidCallback onPick,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Chưa có ảnh',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 8),
            Text(title),
            TextButton(onPressed: onPick, child: const Text('Tải ảnh')),
          ],
        ),
      ),
    );
  }
}
