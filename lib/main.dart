import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroScan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AgroScanHome(),
    );
  }
}

class AgroScanHome extends StatefulWidget {
  const AgroScanHome({super.key});

  @override
  State<AgroScanHome> createState() => _AgroScanHomeState();
}

class _AgroScanHomeState extends State<AgroScanHome> {
  CameraController? _controller;
  bool _isModelLoaded = false;
  String _result = "Arahkan kamera ke daun";
  String _confidence = "";
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Permission.camera.request();

    await Tflite.loadModel(
      model: "assets/models/agroscan_model.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );

    setState(() {
      _isModelLoaded = true;
    });

    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {});
    _controller!.startImageStream((CameraImage img) {
      if (!_isDetecting) {
        _isDetecting = true;
        _runModelOnFrame(img);
      }
    });
  }

  Future<void> _runModelOnFrame(CameraImage img) async {
    if (!_isModelLoaded) return;

    var recognitions = await Tflite.runModelOnFrame(
      bytesList: img.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.7,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      String label = recognitions[0]['label'];
      double conf = recognitions[0]['confidence'] * 100;

      String cleanLabel = label.replaceAll(RegExp(r'[0-9_]'), ' ').trim();

      setState(() {
        _result = cleanLabel;
        _confidence = "${conf.toStringAsFixed(1)}%";
      });
    } else {
      setState(() {
        _result = "Tidak dikenali / Daun Sehat";
        _confidence = "";
      });
    }

    await Future.delayed(const Duration(milliseconds: 100));
    _isDetecting = false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("AgroScan - Dokter Tanaman"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(_controller!),
          ),

          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hasil Diagnosa:",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_confidence.isNotEmpty)
                    Text(
                      "Akurasi: $_confidence",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
