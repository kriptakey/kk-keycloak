import 'package:flutter/material.dart';

import 'package:e2ee_device_binding_demo_flutter/screens/mobile_scanner_register.dart';
import 'package:e2ee_device_binding_demo_flutter/main.dart';

class DeviceRegistrationScreen extends StatefulWidget {
  static String id = "register_screen";
  const DeviceRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DeviceRegistrationScreen> createState() =>
      _DeviceRegistrationScreenState();
}

class _DeviceRegistrationScreenState extends State<DeviceRegistrationScreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final FocusNode _focusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    // UI for device registration with digital certificate
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Center(
                child: Text("Register",
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text("Register your device",
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(height: 5),

              // Username
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username.";
                  }
                  return null;
                },
              ),

              // Button
              const SizedBox(height: 50),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileScannerRegisterScreen(
                                username: _controllerUsername.text)),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already register the device?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                          );
                        },
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.deepPurple)),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
