import 'dart:convert';
import '../../domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
  ScanResultModel({
    required super.id,
    required super.plantName,
    required super.plantType,
    required super.diseaseName,
    required super.confidence,
    required super.imagePath,
    required super.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantName': plantName,
      'plantType': plantType,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'],
      plantName: json['plantName'],
      plantType: json['plantType'],
      diseaseName: json['diseaseName'],
      confidence: json['confidence'],
      imagePath: json['imagePath'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  String toJsonString() => json.encode(toJson());

  factory ScanResultModel.fromJsonString(String str) =>
      ScanResultModel.fromJson(json.decode(str));
}
