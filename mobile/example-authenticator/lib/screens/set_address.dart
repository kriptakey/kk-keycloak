import 'package:e2ee_device_binding_demo_flutter/core/config.dart';
import 'package:flutter/material.dart';

import 'package:e2ee_device_binding_demo_flutter/screens/mobile_scanner_register.dart';
import 'package:e2ee_device_binding_demo_flutter/main.dart';

class SetAddressScreen extends StatefulWidget {
  const SetAddressScreen({Key? key}) : super(key: key);

  @override
  State<SetAddressScreen> createState() => _DeviceRegistrationScreenState();
}

class _DeviceRegistrationScreenState extends State<SetAddressScreen> {
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerRealmName = TextEditingController();

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
                child: Text("Set Config",
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text("Set Keycloak base URL",
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(height: 5),

              // Username
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerAddress,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Base URL",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter base URL.";
                  }
                  return null;
                },
              ),

              // Realm Name
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerRealmName,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Realm Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter realm name.";
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
                      // final config = Config();
                      Config().setAddress(_controllerAddress.text);
                      Config().setRealmName(_controllerRealmName.text);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                      );
                    },
                    child: const Text(
                      "Set",
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
