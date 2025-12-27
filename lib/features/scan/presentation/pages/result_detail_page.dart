import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../domain/entities/scan_result.dart';

class ResultDetailPage extends StatelessWidget {
  final ScanResult result;

  const ResultDetailPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Scan'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.file(
                File(result.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!result.isDetected) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 60,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tanaman Tidak Terdeteksi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Tanaman',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow('Nama Tanaman', result.plantName),
                          const Divider(height: 32),
                          _buildInfoRow('Jenis Tanaman', result.plantType),
                          const Divider(height: 32),
                          _buildInfoRow('Penyakit', result.diseaseName),
                          const Divider(height: 32),
                          _buildInfoRow(
                            'Akurasi',
                            '${result.confidence.toStringAsFixed(1)}%',
                          ),
                          const Divider(height: 32),
                          _buildInfoRow(
                            'Waktu Scan',
                            DateFormat(
                              'dd MMMM yyyy, HH:mm',
                            ).format(result.timestamp),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: result.isHealthy
                                  ? Colors.green[50]
                                  : Colors.orange[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  result.isHealthy
                                      ? Icons.check_circle
                                      : Icons.info_outline,
                                  color: result.isHealthy
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    result.isHealthy
                                        ? 'Tanaman dalam kondisi sehat'
                                        : 'Tanaman memerlukan perawatan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: result.isHealthy
                                          ? Colors.green[900]
                                          : Colors.orange[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
