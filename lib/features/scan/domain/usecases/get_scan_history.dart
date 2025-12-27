import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class GetScanHistory {
  final ScanRepository repository;
  GetScanHistory(this.repository);

  Future<List<ScanResult>> call() async {
    return await repository.getHistory();
  }
}
