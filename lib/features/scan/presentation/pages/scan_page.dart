import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_scan_page.dart';
import 'result_page.dart';
import '../../../../core/di/injection.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Tanaman',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 120,
                color: const Color(0xFF4CAF50).withOpacity(0.3),
              ),
              const SizedBox(height: 32),
              const Text(
                'Pilih Metode Scan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Ambil foto tanaman Anda untuk\nmendapatkan diagnosa penyakit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildScanOption(
                context,
                icon: Icons.camera_alt,
                title: 'Kamera',
                subtitle: 'Ambil foto langsung',
                onTap: () => _openCamera(context),
              ),
              const SizedBox(height: 16),
              _buildScanOption(
                context,
                icon: Icons.photo_library,
                title: 'Galeri',
                subtitle: 'Pilih dari galeri',
                onTap: () => _openGallery(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: const Color(0xFF4CAF50)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraScanPage()),
    );

    if (result != null && context.mounted) {
      _processImage(context, result);
    }
  }

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && context.mounted) {
      _processImage(context, image.path);
    }
  }

  Future<void> _processImage(BuildContext context, String imagePath) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await DI.scanBloc.scanImage(imagePath);

    if (context.mounted) {
      Navigator.pop(context);
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultPage(result: result)),
        );
      }
    }
  }
}
