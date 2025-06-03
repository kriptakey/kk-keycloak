import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'package:kms_e2ee_package/api.dart';

import 'package:e2ee_device_binding_demo_flutter/main.dart';
import 'package:e2ee_device_binding_demo_flutter/core/api_client.dart';
import 'package:e2ee_device_binding_demo_flutter/core/structure.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/error.dart';

class ApprovalRegister extends StatefulWidget {
  const ApprovalRegister({
    Key? key,
    this.scannedData,
    this.username,
    this.initialLink,
  }) : super(key: key);

  final String? scannedData;
  final String? username;
  final String? initialLink;

  @override
  State<ApprovalRegister> createState() => _ApprovalRegisterState();
}

class _ApprovalRegisterState extends State<ApprovalRegister> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final String _authenticationMessage = "Please authenticate yourself";
  final ApiClient _apiClient = ApiClient();

  // Variable to hold the scanned data
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
              MaterialPageRoute(builder: (context) => const ApprovalRegister()),
            );
          },
        ),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  Future<void> _processRegistration(dynamic preAuthenticationData) async {
    // Generate key pair and CSR
    // CertificateInformation: CN (Common Name), C (Country), L (Location), ST (State), O (Organization), OU (Organizational Unit)
    final DistinguishedName distinguishedName = DistinguishedName(
      "www.example.com",
      "ID",
      "Jakarta",
      "South Jakarta",
      "Company A",
      "Core Banking",
    );

    // 1. Call API generate key pair in secure storage and return CSR
    String? applicationCsr;
    try {
      applicationCsr = await E2eeSdkPackage()
          .generateDeviceIdKeypairInSecureStorage(distinguishedName);
    } on KKException catch (e) {
      // print("Error: ${e.message}, error code: ${e.code}");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorScreen(
              error: "Error: ${e.message}, error code: ${e.code}",
            ),
          ),
        );
      }
      // rethrow;
    }

    print(applicationCsr);
    print(preAuthenticationData['publicKey']);
    ////////////////////////////////////////////////////////////
    // Call API e2eeEncrypt to encrypt CSR before sending to user
    Uint8List csrUint8List = Uint8List.fromList(utf8.encode(applicationCsr!));
    final RequestE2eeEncrypt requestE2eeEncrypt = RequestE2eeEncrypt(
      preAuthenticationData['publicKey'],
      preAuthenticationData['oaepLabel'],
      [csrUint8List],
    );
    ResponseE2eeEncrypt? responseE2eeEncrypt;
    try {
      responseE2eeEncrypt = await E2eeSdkPackage().e2eeEncrypt(
        requestE2eeEncrypt,
      );
      print(
        "Response ciphertext: ${responseE2eeEncrypt.encryptedDataBlockList[0]}",
      );
      print("Response metadata: ${responseE2eeEncrypt.metadata}");
    } on KKException catch (e) {
      // print("Error: ${e.message}, error code: ${e.code}");
      // rethrow;
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorScreen(
              error: "Error: ${e.message}, error code: ${e.code}",
            ),
          ),
        );
      }
    }
    ///////////////////////////////////////////////////////////

    // Send request to app server to sign the CSR
    final RequestEncryptedSecretObject requestSecretObject =
        RequestEncryptedSecretObject(
          preAuthenticationData['e2eeSessionId'],
          "AES",
          "HMAC-SHA512",
          responseE2eeEncrypt!.encryptedDataBlockList[0],
          responseE2eeEncrypt.metadata,
        );
    Map<String, dynamic> certificateRequestData = {
      "username": widget.username!,
      "sessionMetadata": requestSecretObject,
    };

    dynamic certificateSigningResponse = await _apiClient.processQRCodeRegister(
      certificateRequestData,
    );
    print("Certificate signing response: ${certificateSigningResponse}");
    print("Success response: ${certificateSigningResponse['success']}");
    if (certificateSigningResponse['success'] != true) {
      print("Get into failure fallback.");
      // final String errorMessage = certificateSigningResponse['message'];
      getAlert("Alert: ${certificateSigningResponse}");
    } else if (certificateSigningResponse['success'] == true && widget.initialLink != null) {
      try {
        await E2eeSdkPackage().storeSecretInSecureStorage(
          "username",
          widget.username!,
        );
        await E2eeSdkPackage().storeSecretInSecureStorage(
          "certificate",
          certificateSigningResponse['certificate'],
        );
        SystemNavigator.pop();
      } on KKException catch (e) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorScreen(
                error: "Error: ${e.message}, error code: ${e.code}",
              ),
            ),
          );
        }
      }
    } else {
      try {
        await E2eeSdkPackage().storeSecretInSecureStorage(
          "username",
          widget.username!,
        );
        await E2eeSdkPackage().storeSecretInSecureStorage(
          "certificate",
          certificateSigningResponse['certificate'],
        );
      } on KKException catch (e) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorScreen(
                error: "Error: ${e.message}, error code: ${e.code}",
              ),
            ),
          );
        }
      }
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
    //////////////////////////////////////////////////////////
  }

  // Method to read pre-authentication data and process
  Future<void> _registerDevice() async {
    setState(() {
      _scannedData = widget.scannedData!;
    });

    try {
      print("E2EE session metadata: ${widget.scannedData!}");
      final parsedData = widget.scannedData!.isNotEmpty
          ? widget.scannedData!
          : null;
      if (parsedData != null) {
        // Deserialize scanned data to get pre-authentication data
        final response = jsonDecode(parsedData) as Map<String, dynamic>;

        // Authenticate user
        final bool canAuthenticateWithBiometrics =
            await _localAuthentication.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics ||
            await _localAuthentication.isDeviceSupported();

        // The following authentication prompt is only for Android sample.
        // Meanwhile, the iOS authentication prompt has been covered by the SDK itself.
        // NOTE: iOS based SDK authentication does not work in simulator.
        // You need to test iOS use case in actual device.
        if (canAuthenticate && Platform.isAndroid) {
          try {
            final bool didAuthenticate = await _localAuthentication
                .authenticate(
                  localizedReason: _authenticationMessage,
                  options: const AuthenticationOptions(stickyAuth: true),
                );
            if (didAuthenticate) {
              print("DEBUG: Device is authenticated!");
              await _processRegistration(response);
            }
          } on PlatformException catch (e) {
            getAlert('Error - ${e.message}');
          }
        } else if (Platform.isIOS) {
          try {
            await _processRegistration(response);
          } on PlatformException catch (e) {
            getAlert('Error - ${e.message}');
          }
        }
      }
    } on KKException catch (e) {
      print("Error: ${e.message}, error code: ${e.code}");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Center(
                child: Text(
                  "Are you sure to register your device?",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await _registerDevice();
                        },
                        height: 45,
                        minWidth: 140,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        },
                        height: 45,
                        minWidth: 140,
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
