import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceService {
  FaceService._internal();
  static final FaceService instance = FaceService._internal();

  Interpreter? _interpreter;
  FaceDetector? _detector;
  bool _loading = false;

  Future<void> _ensureLoaded() async {
    if (_interpreter != null && _detector != null) return;

    if (_loading) {
      while (_interpreter == null) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }
    
    _loading = true;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/facenet.tflite',
      options: InterpreterOptions()..threads = 2,
    );

    _detector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    _loading = false;
  }

  Float32List _imageToFloat32(img.Image image) {
    final buffer = Float32List(160 * 160 * 3);
    int i = 0;

    for (int y = 0; y < 160; y++) {
      for (int x = 0; x < 160; x++) {
        final p = image.getPixel(x, y);
        buffer[i++] = (p.r - 127.5) / 128.0;
        buffer[i++] = (p.g - 127.5) / 128.0;
        buffer[i++] = (p.b - 127.5) / 128.0;
      }
    }
    return buffer;
  }

  Future<List<double>?> extractEmbedding(File file) async {
    await _ensureLoaded();

    final inputImage = InputImage.fromFile(file);
    final faces = await _detector!.processImage(inputImage);
    if (faces.length != 1) return null;

    final original = img.decodeImage(file.readAsBytesSync());
    if (original == null) return null;

    final box = faces.first.boundingBox;

    final x = max(0, box.left.toInt());
    final y = max(0, box.top.toInt());
    final w = min(box.width.toInt(), original.width - x);
    final h = min(box.height.toInt(), original.height - y);

    final cropped = img.copyCrop(original, x: x, y: y, width: w, height: h);

    final resized = img.copyResize(cropped, width: 160, height: 160);

    final input = _imageToFloat32(resized).reshape([1, 160, 160, 3]);
    final output = Float32List(512).reshape([1, 512]);

    _interpreter!.run(input, output);

    return List<double>.from(output[0]);
  }

  double cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0, na = 0, nb = 0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    return dot / (sqrt(na) * sqrt(nb));
  }
}
