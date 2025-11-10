import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentPickupQRScreen extends StatelessWidget {
  final String qrValue;
  const StudentPickupQRScreen({super.key, required this.qrValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D14),
        elevation: 0,
        title: const Text("Show this at counter"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: qrValue,
            size: 230,
            version: QrVersions.auto,
          ),
        ),
      ),
    );
  }
}
