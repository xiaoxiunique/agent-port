import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen camera QR scanner. Pops with the first non-empty decoded string,
/// or null if the user cancels. Only used on iOS/Android (guarded by callers).
class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final b in capture.barcodes) {
      final v = b.rawValue?.trim();
      if (v != null && v.isNotEmpty) {
        _handled = true;
        Navigator.of(context).pop(v);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('扫描二维码'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          // A simple viewfinder frame to aim the QR into.
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Text(
              '对准 Mac「服务端」页面上的二维码',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
