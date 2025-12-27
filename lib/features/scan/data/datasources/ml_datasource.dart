import 'package:flutter_tflite/flutter_tflite.dart';

abstract class MLDataSource {
  Future<void> initialize();
  Future<Map<String, dynamic>?> detectFromImage(String imagePath);
  Future<void> dispose();
}

class MLDataSourceImpl implements MLDataSource {
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Tflite.loadModel(
      model: "assets/models/agroscan_model.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: false,
    );

    _isInitialized = true;
  }

  @override
  Future<Map<String, dynamic>?> detectFromImage(String imagePath) async {
    if (!_isInitialized) await initialize();

    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.5,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      return recognitions[0];
    }
    return null;
  }

  @override
  Future<void> dispose() async {
    await Tflite.close();
    _isInitialized = false;
  }
}
