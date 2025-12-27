class ScanResult {
  final String id;
  final String plantName;
  final String plantType;
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final DateTime timestamp;

  ScanResult({
    required this.id,
    required this.plantName,
    required this.plantType,
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.timestamp,
  });

  bool get isHealthy => diseaseName.toLowerCase().contains('sehat');
  bool get isDetected => plantName.isNotEmpty;
}
