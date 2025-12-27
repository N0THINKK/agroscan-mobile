import 'package:flutter/foundation.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/detect_plant_disease.dart';
import '../../domain/usecases/get_scan_history.dart';
import '../../domain/usecases/save_scan_result.dart';

class ScanBloc extends ChangeNotifier {
  final DetectPlantDisease detectPlantDisease;
  final GetScanHistory getScanHistory;
  final SaveScanResult saveScanResult;

  ScanBloc({
    required this.detectPlantDisease,
    required this.getScanHistory,
    required this.saveScanResult,
  });

  List<ScanResult> _history = [];
  bool _isLoading = false;
  String? _error;

  List<ScanResult> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _history = await getScanHistory();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<ScanResult?> scanImage(String imagePath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await detectPlantDisease(imagePath);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> saveResult(ScanResult result) async {
    await saveScanResult(result);
    await loadHistory();
  }
}
