import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class SaveScanResult {
  final ScanRepository repository;
  SaveScanResult(this.repository);

  Future<void> call(ScanResult result) async {
    await repository.saveResult(result);
  }
}
