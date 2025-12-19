import 'package:flutter/material.dart';
import 'register_face_screen.dart';
import 'verify_face_screen.dart';

class FrMainMenuScreen extends StatelessWidget {
  const FrMainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Recognition Menu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Đăng ký khuôn mặt"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterFace()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Xác thực khuôn mặt"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VerifyFace()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
