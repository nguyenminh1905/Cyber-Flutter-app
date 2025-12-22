import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_service.dart';
import 'package:flutter_cyber_app/menu_screen/test_screen.dart';
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

  bool _running = true;
  bool _capturing = false;
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

    try {
      final xfile = await _controller!.takePicture();
      final file = File(xfile.path);

      final input = InputImage.fromFilePath(file.path);
      final faces = await _detector!.processImage(input);

      if (faces.isEmpty) return;

      _verifying = true;
      await _verifyFace(file);
    } catch (e) {
      debugPrint("KYC error: $e");
    } finally {
      _capturing = false;
      _verifying = false;
    }
  }

  Future<void> _verifyFace(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("face_embedding");

    if (saved == null) {
      _running = false;
      Navigator.pop(context, "NO_REGISTER");
      return;
    }

    final registered = List<double>.from(jsonDecode(saved));
    final current = await FaceService.instance.extractEmbedding(image) as List<double>;

    final sim = FaceService.instance.cosineSimilarity(registered, current);

    _running = false;

    if (!mounted) return;

    if (sim > 0.7) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TestScreen()),
      );
    } else {
      Navigator.pop(context, "FAIL");
    }
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
