import 'package:client/features/admin/presentation/providers/order_socket_provider.dart';
import 'package:client/features/orderHistory/presentation/providers/student_order_provider.dart';
import 'package:client/utils/verify_pickup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

class QRScanScreen extends ConsumerStatefulWidget {
  const QRScanScreen({super.key});

  @override
  ConsumerState<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends ConsumerState<QRScanScreen> {
  bool _locked = false;

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    formats: [BarcodeFormat.qrCode],
    detectionTimeoutMs: 600,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan Pickup QR"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (_locked) return;
          _locked = true;

          final code = capture.barcodes.first.rawValue;
          if (code == null) {
            _show("QR unreadable ❌");
            Navigator.pop(context);
            return;
          }

          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 80);
          }

          final ok = await ref.read(verifyPickupProvider(code).future);

          if (ok) {
            _show("Order Delivered ✅", success: true);

            ref.invalidate(adminOrdersStreamProvider);
            ref.invalidate(studentOrdersStreamProvider);

            Future.delayed(const Duration(milliseconds: 600), () {
              Navigator.pop(context);
            });
          } else {
            _show("Invalid / Expired QR ❌");
            Future.delayed(const Duration(milliseconds: 600), () {
              Navigator.pop(context);
            });
          }
        },
      ),
    );
  }

  void _show(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
