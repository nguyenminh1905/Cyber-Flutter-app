import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KYCCameraScreen extends StatefulWidget {
  const KYCCameraScreen({super.key});

  @override
  State<KYCCameraScreen> createState() => _KYCCameraScreenState();
}

class _KYCCameraScreenState extends State<KYCCameraScreen> {
  CameraController? _controller;
  FaceDetector? _detector;

  // running trạng thái camera
  bool _running = true;

  // capture trạng thái chụp ảnh
  bool _capturing = false;

  // verifying trạng thái xác thực
  bool _verifying = false;


  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    _detector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );

    if (mounted) setState(() {});
    _loop();
  }

  Future<void> _loop() async {
    while (_running && mounted) {
      await _captureAndVerify();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  Future<void> _captureAndVerify() async {
    if (_capturing || _verifying) return;
    if (!_controller!.value.isInitialized) return;

    _capturing = true;

    final xfile = await _controller!.takePicture();
    final file = File(xfile.path);

    final input = InputImage.fromFilePath(file.path);
    final faces = await _detector!.processImage(input);

    if (faces.isEmpty) return;

    _verifying = true;
    await _verifyFace(file);

    _capturing = false;
    _verifying = false;
  }

  Future<void> _verifyFace(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("face_embedding");

    // FREEZE camera ngay khi bắt đầu xử lý kết quả
    _running = false;

    if (saved == null) {
      _showDialog(
        "Chưa đăng ký",
        "Vui lòng đăng ký khuôn mặt trước",
        stop: true,
      );
      return;
    }

    final registered = List<double>.from(jsonDecode(saved));
    final current = await FaceService.instance.extractEmbedding(image) as List<double>;

    final sim = FaceService.instance.cosineSimilarity(registered, current);

    if (!mounted) return;

    if (sim > 0.7) {
      _showDialog(
        "Thành công",
        "Xác thực thành công",
        stop: true, // OK → thoát
      );
    } else {
      _showDialog(
        "Thất bại",
        "Khuôn mặt không khớp",
        stop: false, // OK → chụp lại
      );
    }
  }

  void _showDialog(String title, String msg, {required bool stop}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              if (stop) {
                Navigator.pop(context); // thoát màn chấm công
              } else {
                // RESUME camera sau khi user bấm OK
                _running = true;
                _loop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_controller!),
                if (_verifying)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _running = false;
    _detector?.close();
    _controller?.dispose();
    super.dispose();
  }
}
