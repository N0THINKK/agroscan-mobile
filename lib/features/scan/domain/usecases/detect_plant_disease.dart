import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class DetectPlantDisease {
  final ScanRepository repository;
  DetectPlantDisease(this.repository);

  Future<ScanResult> call(String imagePath) async {
    return await repository.detectDisease(imagePath);
  }
}
