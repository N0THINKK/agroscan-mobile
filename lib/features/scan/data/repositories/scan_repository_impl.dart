import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/ml_datasource.dart';
import '../models/scan_result_model.dart';

class ScanRepositoryImpl implements ScanRepository {
  final MLDataSource mlDataSource;
  final LocalDataSource localDataSource;

  ScanRepositoryImpl({
    required this.mlDataSource,
    required this.localDataSource,
  });

  @override
  Future<ScanResult> detectDisease(String imagePath) async {
    final detection = await mlDataSource.detectFromImage(imagePath);

    if (detection == null) {
      return ScanResultModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        plantName: '',
        plantType: '',
        diseaseName: 'Tidak Terdeteksi',
        confidence: 0.0,
        imagePath: imagePath,
        timestamp: DateTime.now(),
      );
    }

    String label = detection['label'] ?? '';
    double confidence = (detection['confidence'] ?? 0.0) * 100;

    // Parse label (format: "plantType_plantName_disease")
    List<String> parts = label.split('_');
    String plantType = parts.isNotEmpty ? _cleanLabel(parts[0]) : 'Unknown';
    String plantName = parts.length > 1 ? _cleanLabel(parts[1]) : 'Unknown';
    String disease = parts.length > 2
        ? _cleanLabel(parts.sublist(2).join(' '))
        : 'Healthy';

    return ScanResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantName: plantName,
      plantType: plantType,
      diseaseName: disease,
      confidence: confidence,
      imagePath: imagePath,
      timestamp: DateTime.now(),
    );
  }

  String _cleanLabel(String label) {
    return label
        .replaceAll(RegExp(r'[0-9_-]'), ' ')
        .trim()
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  @override
  Future<List<ScanResult>> getHistory() async {
    return await localDataSource.getHistory();
  }

  @override
  Future<void> saveResult(ScanResult result) async {
    await localDataSource.saveResult(result as ScanResultModel);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
  }
}
