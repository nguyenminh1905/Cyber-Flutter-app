import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_service.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/face_user_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RecognizeMultiFaceScreen extends StatefulWidget {
  const RecognizeMultiFaceScreen({super.key});

  @override
  State<RecognizeMultiFaceScreen> createState() =>
      _RecognizeMultiFaceScreenState();
}

class _RecognizeMultiFaceScreenState extends State<RecognizeMultiFaceScreen> {
  CameraController? _controller;
  FaceDetector? _detector;
  List<String> _names = [];
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cams = await availableCameras();
    final front = cams.firstWhere(
      (e) => e.lensDirection == CameraLensDirection.front,
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

    if (!mounted) return;
    setState(() {});
    _loop();
  }

  Future<void> _loop() async {
    while (_running && mounted) {
      await _process();
      await Future.delayed(const Duration(milliseconds: 5000));
    }
  }

  Future<void> _process() async {
    if (!_running && mounted) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final users = await FaceStorage.loadUsers();
      if (users.isEmpty) return;

      final file = File((await _controller!.takePicture()).path);
      final faces = await _detector!.processImage(InputImage.fromFile(file));

      List<String> found = [];

      for (final face in faces) {
        final embed = await FaceService.instance.extractEmbeddingFromFace(file, face);
        if (embed == null) continue;
        double best = 0;
        String? name;

        for (final u in users) {
          final sim = FaceService.instance.cosineSimilarity(u.embedding, embed);
          if (sim > best) {
            best = sim;
            name = u.name;
          }
        }

        if (best > 0.7 && name != null) {
          found.add(name);
        }
      }
      if (!mounted) return;
      setState(() => _names = found);
    } catch (e) {
      //print("Error in recognition: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: _names
                        .map(
                          (n) => Text(
                            n,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
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
