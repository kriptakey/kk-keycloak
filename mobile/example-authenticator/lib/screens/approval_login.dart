import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:kms_e2ee_package/api.dart';

import 'package:e2ee_device_binding_demo_flutter/main.dart';
import 'package:e2ee_device_binding_demo_flutter/core/api_client.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/account.dart';
import 'package:e2ee_device_binding_demo_flutter/core/structure.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/error.dart';

class ApprovalLogin extends StatefulWidget {
  const ApprovalLogin({
    Key? key,
    this.clientId,
    this.sessionId,
    this.nonce,
    this.username,
    this.initialLink,
  }) : super(key: key);

  final String? clientId;
  final String? sessionId;
  final String? nonce;
  final String? username;
  final String? initialLink;

  @override
  State<ApprovalLogin> createState() => _ApprovalLoginState();
}

class _ApprovalLoginState extends State<ApprovalLogin> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final String _authenticationMessage = "Please authenticate yourself";
  final ApiClient _apiClient = ApiClient();

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
              MaterialPageRoute(builder: (context) => const ApprovalLogin()));
        },
      ),
      backgroundColor: Colors.red[400],
    ));
  }

  Future<void> _authenticateDeviceAndUserToServer(String nonceSignature) async {
    // Send nonce, signature and metadata to app server
    final RequestSignedSecretObject requestSecretObject =
        RequestSignedSecretObject(
            widget.sessionId!, widget.nonce!, nonceSignature);
    Map<String, dynamic> deviceAuthenticationData = {
      "username": widget.username!,
      "signatureMetadata": requestSecretObject
    };

    dynamic deviceActivationResponse =
        await _apiClient.processQRCodeLogin(deviceAuthenticationData);

    if (deviceActivationResponse['success'] == true &&
        widget.initialLink != null) {
      print("Inside device activation success and initiallink available");
      SystemNavigator.pop();
    } else if (deviceActivationResponse['success'] == true) {
      print("Inside device activation success and initiallink null");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AccountScreen(username: widget.username!),
          ),
        );
      }
    } else {
      print("Approval login failed");
      getAlert('Alert: ${deviceActivationResponse['message']}');
    }
  }

  Future<void> _authenticateUserAndDevice() async {
    try {
      // Authenticate user
      final bool canAuthenticateWithBiometrics =
          await _localAuthentication.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics ||
          await _localAuthentication.isDeviceSupported();

      print("Nonce: ${widget.nonce!}");

      // The following authentication prompt is only for Android sample.
      // Meanwhile, the iOS authentication prompt has been covered by the SDK itself.
      // NOTE: iOS based SDK authentication does not work in simulator.
      // You need to test iOS use case in actual device.
      if (canAuthenticate && Platform.isAndroid) {
        try {
          final bool didAuthenticate = await _localAuthentication.authenticate(
              localizedReason: _authenticationMessage,
              options: const AuthenticationOptions(stickyAuth: true));
          if (didAuthenticate) {
            Uint8List? nonceSignature;
            // We assume that oaep label can be used as nonce
            try {
              nonceSignature = await E2eeSdkPackage()
                  .signByDeviceIdKeypairInSecureStorage(
                      Uint8List.fromList(utf8.encode(widget.nonce!)));
            } on KKException catch (e) {
              // print("Error: ${e.message}, error code: ${e.code}");
              // rethrow;
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ErrorScreen(
                          error: "Error: ${e.message}, error code: ${e.code}")),
                );
              }
            }

            // Activate device to application server
            await _authenticateDeviceAndUserToServer(
                base64Encode(nonceSignature!));
          }
        } on PlatformException catch (e) {
          getAlert('Error - ${e.message}');
        }
      } else if (Platform.isIOS) {
        Uint8List? nonceSignature;
        try {
          nonceSignature = await E2eeSdkPackage()
              .signByDeviceIdKeypairInSecureStorage(
                  Uint8List.fromList(utf8.encode(widget.nonce!)));
        } on KKException catch (e) {
          print("Error: ${e.message}, error code: ${e.code}");
          rethrow;
        }

        // Activate device to application server
        await _authenticateDeviceAndUserToServer(base64Encode(nonceSignature));
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
                    "Do you give permission to ${widget.clientId!} to login with username ${widget.username!}?",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await _authenticateUserAndDevice();
                        },
                        height: 45,
                        minWidth: 140,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Yes",
                            style: TextStyle(color: Colors.white)),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                          );
                        },
                        height: 45,
                        minWidth: 140,
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("No",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                  Center(
                    child: Text("Login on-progress...",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center),
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
