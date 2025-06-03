import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:e2ee_device_binding_demo_flutter/screens/approval_login.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/device_registration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';
import 'package:kms_e2ee_package/api.dart';

import 'package:e2ee_device_binding_demo_flutter/screens/mobile_scanner_login.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/set_address.dart';

void main() async {
  setupWindow();

  WidgetsFlutterBinding.ensureInitialized();
  const platform = MethodChannel('app.linking.channel');
  String? initialLink;
  try {
    initialLink = await platform.invokeMethod<String>('getLaunchUri');
  } on KKException catch (e) {
    print("Error: ${e.message}, error code: ${e.code}");
    rethrow;
  }

  // Get username from secure storage
  try {
    _username = await E2eeSdkPackage().getSecretFromSecureStorage("username");
  } on KKException catch (e) {
    print("Error: ${e.message}, error code: ${e.code}");
    rethrow;
  }

  runApp(MainScreen(initialLink: initialLink));
}

const double windowWidth = 480;
const double windowHeight = 854;
String? _username;

void setupWindow() {
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('E2EE Device Binding Demo');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class MainScreen extends StatelessWidget {
  final String? initialLink;

  const MainScreen({super.key, this.initialLink});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Link Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(initialLink: initialLink),
    );
  }
}

class HomePage extends StatefulWidget {
  final String? initialLink;
  const HomePage({super.key, this.initialLink});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (widget.initialLink != null) {
      Future.microtask(() {
        final uri = Uri.tryParse(widget.initialLink!);
        String? extractedData;
        String? jsonData;
        Uint8List? decodedData;
        if (uri!.path == "/qrcode-mobile-login") {
          extractedData = uri?.queryParameters['data'];
          if (extractedData != null) {
            decodedData = base64Decode(extractedData);
            jsonData = String.fromCharCodes(decodedData);
          }

          if (jsonData != null && context.mounted) {
            final response = jsonDecode(jsonData) as Map<String, dynamic>;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ApprovalLogin(
                  clientId: response['clientId'],
                  sessionId: response['sessionId'],
                  nonce: response['nonce'],
                  username: _username,
                  initialLink: widget.initialLink,
                ),
              ),
            );
          }
        } else if (uri.path == "/qrcode-mobile-register-csr") {
          extractedData = uri?.queryParameters['data'];
          if (extractedData != null) {
            decodedData = base64Decode(extractedData);
            jsonData = String.fromCharCodes(decodedData);
            print("QRCode register json data: $jsonData");
          }

          if (jsonData != null && context.mounted) {
            final response = jsonDecode(jsonData) as Map<String, dynamic>;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DeviceRegistrationScreen(
                  scannedData: jsonData,
                  initialLink: widget.initialLink,
                ),
              ),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.red[400],
        ),
      );
    }

    void switchToMainScreen(String message) {
      if (!context.mounted) return;
      // Notify user that session has been created
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Switch to insert otp screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }

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
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Login to your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      if (_username != null) {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MobileScannerLoginScreen(
                                username: _username!,
                              ),
                            ),
                          );
                        }
                      } else {
                        getAlert(
                          "Alert: Username not found. Please register your device!",
                        );
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      // Unregister device
                      try {
                        await E2eeSdkPackage()
                            .unregisterDeviceFromSecureStorage();
                        switchToMainScreen(
                          "Notification: Device has been successfully unregistered!",
                        );
                      } on KKException catch (e) {
                        getAlert(e.message!);
                      }
                    },
                    child: const Text(
                      "Unregister device",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      // Set address
                      try {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SetAddressScreen(),
                          ),
                        );
                      } on KKException catch (e) {
                        getAlert(e.message!);
                      }
                    },
                    child: const Text(
                      "Set Config",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeviceRegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.deepPurple),
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
