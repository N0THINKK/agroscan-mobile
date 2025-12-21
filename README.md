# 🌿 AgroScan: Home Plant Disease Detection

![Flutter](https://img.shields.io/badge/Flutter-3.0-blue?logo=flutter)
![TensorFlow](https://img.shields.io/badge/TensorFlow-2.0-orange?logo=tensorflow)
![Python](https://img.shields.io/badge/Python-3.8-yellow?logo=python)
![Status](https://img.shields.io/badge/Status-In%20Development-green)

**AgroScan** adalah aplikasi mobile berbasis AI untuk mendeteksi penyakit pada tanaman rumahan dan sayuran pekarangan. Aplikasi ini dirancang khusus untuk membantu masyarakat urban (seperti di Surabaya & Blitar) dalam merawat tanaman hias dan tanaman pangan skala rumah tangga.

## 📱 Features

- **Real-time Detection:** Deteksi penyakit tanaman secara instan menggunakan kamera smartphone.
- **Offline Mode:** Model AI berjalan di perangkat (On-Device) menggunakan **TensorFlow Lite**, tidak perlu koneksi internet saat scan.
- **Hybrid Classification:** Mendukung deteksi untuk tanaman hias (_Ornamental_) dan tanaman sayur (_Vegetables_).
- **Disease Info:** Memberikan informasi nama penyakit dan saran penanganan awal.

## 🧠 Machine Learning Model

Proyek ini menggunakan teknik **Transfer Learning** dengan arsitektur **MobileNetV2**. Model ini dipilih karena ringan (_lightweight_) dan memiliki latensi rendah, sangat cocok untuk dijalankan di perangkat mobile (Android/iOS).

### Dataset Strategy

Dataset yang digunakan adalah **Custom Combined Dataset** yang menggabungkan dua sumber untuk relevansi maksimal dengan iklim tropis Indonesia:

1.  **Indoor Plant Disease Dataset:** Untuk tanaman hias seperti _Sansevieria_ (Lidah Mertua), _Aloe Vera_, dan _Money Plant_.
2.  **PlantVillage (Selected Classes):** Mengambil kelas spesifik _Tomato_ (Tomat) dan _Pepper/Chili_ (Cabai) yang umum ditanam di pekarangan rumah.

### Model Performance

- **Architecture:** MobileNetV2 (Pre-trained on ImageNet)
- **Training Accuracy:** ~96% (Epoch 10)
- **Format:** `.tflite` (Quantized for size optimization)
- **Augmentation:** Rotation, Zoom, Width/Height Shift, Horizontal Flip.

## 🛠 Tech Stack

### Mobile App (Client)

- **Framework:** Flutter (Dart)
- **State Management:** Provider / Bloc (sesuaikan dengan kodemu)
- **ML Plugin:** `tflite_flutter` atau `google_ml_kit`

### Machine Learning (Backend/Training)

- **Environment:** Google Colab (T4 GPU)
- **Library:** TensorFlow, Keras, NumPy, Pandas
- **Language:** Python

## 📂 Project Structure

```text
AgroScan/
├── assets/
│   ├── models/
│   │   ├── agroscan_model.tflite   # File model hasil convert
│   │   └── labels.txt              # Label kelas (Tanaman + Penyakit)
│   └── images/
├── lib/
│   ├── screens/                    # UI Halaman (Home, Scan, Result)
│   ├── services/                   # Logic untuk load TFLite
│   └── main.dart
├── pubspec.yaml
└── README.md
```
