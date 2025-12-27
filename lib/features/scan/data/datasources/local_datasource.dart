import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/scan_result_model.dart';

abstract class LocalDataSource {
  Future<List<ScanResultModel>> getHistory();
  Future<void> saveResult(ScanResultModel result);
  Future<void> clearHistory();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences prefs;
  static const String _historyKey = 'scan_history';

  LocalDataSourceImpl(this.prefs);

  @override
  Future<List<ScanResultModel>> getHistory() async {
    final List<String>? historyJson = prefs.getStringList(_historyKey);
    if (historyJson == null) return [];

    return historyJson
        .map((json) => ScanResultModel.fromJsonString(json))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> saveResult(ScanResultModel result) async {
    final history = await getHistory();
    history.insert(0, result);

    // Keep only last 50 results
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }

    final historyJson = history.map((e) => e.toJsonString()).toList();
    await prefs.setStringList(_historyKey, historyJson);
  }

  @override
  Future<void> clearHistory() async {
    await prefs.remove(_historyKey);
  }
}
