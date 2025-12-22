import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_camera_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'register_face_screen.dart';

class FrMainMenuScreen extends StatelessWidget {
  const FrMainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showFailDialog(String title, String content) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Face Recognition Menu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Đăng ký khuôn mặt"),
              onPressed: () async {
                final picker = ImagePicker();

                final picked = await picker.pickImage(
                  source: ImageSource.camera,
                  preferredCameraDevice: CameraDevice.front,
                );

                if (!context.mounted || picked == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterFace(image: File(picked.path)),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Xác thực khuôn mặt"),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KYCCameraScreen()),
                );

                if (!context.mounted) return;

                if (result == "FAIL") {
                  showFailDialog("Xác thực thất bại", "Khuôn mặt không khớp.");
                }

                if (result == "NO_REGISTER") {
                  showFailDialog(
                    "Chưa đăng ký",
                    "Vui lòng đăng ký khuôn mặt trước.",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
