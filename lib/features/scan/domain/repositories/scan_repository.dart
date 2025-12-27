import '../entities/scan_result.dart';

abstract class ScanRepository {
  Future<ScanResult> detectDisease(String imagePath);
  Future<List<ScanResult>> getHistory();
  Future<void> saveResult(ScanResult result);
  Future<void> clearHistory();
}
