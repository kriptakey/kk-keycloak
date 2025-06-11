import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:e2ee_device_binding_demo_flutter/main.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/approval_register.dart';

class MobileScannerRegisterScreen extends StatefulWidget {
  const MobileScannerRegisterScreen({Key? key, this.username})
    : super(key: key);

  final String? username;

  @override
  State<MobileScannerRegisterScreen> createState() =>
      _MobileScannerRegisterScreenState();
}

class _MobileScannerRegisterScreenState
    extends State<MobileScannerRegisterScreen> {
  final MobileScannerController controller = MobileScannerController();

  // Variable to hold the scanned data
  bool _isScanning = true;
  String? _scannedData;

  void getAlert(String message) {
    if (!context.mounted) return;
    // Notify user that session creation is failed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Switch to main builder
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        backgroundColor: Colors.redAccent[100],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await controller.start();
        print("Camera started successfully");
      } catch (e) {
        print("Failed to start camera: $e");
        getAlert("Failed to start camera: $e");
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleQRCode(BarcodeCapture capture) {
    if (!_isScanning) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() async {
        _isScanning = false;
        _scannedData = barcodes.first.rawValue;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ApprovalRegister(
              scannedData: _scannedData!,
              username: widget.username!,
            ),
          ),
        );
      });
    }
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: _handleQRCode,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.flash_on),
        onPressed: () => controller.toggleTorch(),
      ),
    );
  }
}
