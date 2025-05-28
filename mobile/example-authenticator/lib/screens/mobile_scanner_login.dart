import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:e2ee_device_binding_demo_flutter/main.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/approval_login.dart';

import 'package:kms_e2ee_package/api.dart';

class MobileScannerLoginScreen extends StatefulWidget {
  const MobileScannerLoginScreen({
    Key? key,
    this.username,
  }) : super(key: key);

  final String? username;

  @override
  State<MobileScannerLoginScreen> createState() =>
      _MobileScannerLoginScreenState();
}

class _MobileScannerLoginScreenState extends State<MobileScannerLoginScreen> {
  final MobileScannerController controller = MobileScannerController(
    // Optional parameters;
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  // Variable to hold the scanned data
  String? _scannedData;

  void getAlert(String message) {
    if (!context.mounted) return;
    // Notify user that session creation is failed
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Switch to main builder
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        },
      ),
      backgroundColor: Colors.redAccent[100],
    ));
  }

  Future<void> decodeScannedPayload(String scannedData) async {
    try {
      final parsedData = scannedData.isNotEmpty ? scannedData : null;
      if (parsedData != null) {
        // Deserialize scanned data to get pre-authentication data
        final response = jsonDecode(parsedData) as Map<String, dynamic>;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ApprovalLogin(
                  clientId: response['clientId'],
                  sessionId: response['sessionId'],
                  nonce: response['nonce'],
                  username: widget.username!)),
        );
      }
    } on KKException catch (e) {
      print("Error: ${e.message}, error code: ${e.code}");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  setState(() async {
                    _scannedData = barcodes.first.rawValue;
                    await decodeScannedPayload(_scannedData!);
                  });
                }
              },
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
