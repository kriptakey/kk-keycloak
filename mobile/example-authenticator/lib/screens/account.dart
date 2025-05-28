import 'package:flutter/material.dart';
import 'package:x509/x509.dart' as x509;

import 'package:e2ee_device_binding_demo_flutter/main.dart';
import 'package:e2ee_device_binding_demo_flutter/core/api_client.dart';
import 'package:e2ee_device_binding_demo_flutter/util/cache_parameters.dart';
import 'package:e2ee_device_binding_demo_flutter/screens/show_account.dart';
import 'package:kms_e2ee_package/api.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key, this.username}) : super(key: key);

  final String? username;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final bool isDeviceBinding = CacheParameters().getDeviceBindingFlag();
  final ApiClient apiClient = ApiClient();
  String? _countryName;
  String? _organizationUnitName;
  String? _organizationName;
  String? _stateOrProvinceName;
  String? _localityName;
  String? _commonName;
  String? _serialNumber;
  String? _issuer;
  String? _startDate;
  String? _endDate;
  String? _algorithmIdentifier;

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
              MaterialPageRoute(builder: (context) => const AccountScreen()));
        },
      ),
      backgroundColor: Colors.red[400],
    ));
  }

  @override
  Widget build(BuildContext context) {
    // UI for user account
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Center(
                child: Text("You have successfully logged in",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 10),

              // Button
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
                      // Unregister device
                      final String? deviceCertificate = await E2eeSdkPackage()
                          .getSecretFromSecureStorage("certificate");

                      // Extract subject DN
                      final x509Cert = x509.parsePem(deviceCertificate!).first
                          as x509.X509Certificate;

                      _countryName =
                          _getFieldFromSubject(x509Cert, "countryName");
                      _commonName =
                          _getFieldFromSubject(x509Cert, "commonName");
                      _localityName =
                          _getFieldFromSubject(x509Cert, "localityName");
                      _stateOrProvinceName =
                          _getFieldFromSubject(x509Cert, "stateOrProvinceName");
                      _organizationName =
                          _getFieldFromSubject(x509Cert, "organizationName");
                      _organizationUnitName = _getFieldFromSubject(
                          x509Cert, "organizationUnitName");
                      _serialNumber = x509Cert.tbsCertificate.serialNumber!
                          .toRadixString(16)
                          .toUpperCase();
                      _startDate = x509Cert.tbsCertificate.validity!.notBefore
                          .toIso8601String();
                      _endDate = x509Cert.tbsCertificate.validity!.notAfter
                          .toIso8601String();
                      _issuer = _getIssuerName(x509Cert, "commonName");
                      _algorithmIdentifier =
                          x509Cert.signatureAlgorithm.algorithm.toString();

                      // Transfer to another account
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAccountScreen(
                                  countryName: _countryName!,
                                  commonName: _commonName!,
                                  localityName: _localityName!,
                                  stateOrProvinceName: _stateOrProvinceName!,
                                  organizationName: _organizationName!,
                                  organizationUnitName: _organizationUnitName!,
                                  startDate: _startDate!,
                                  endDate: _endDate!,
                                  issuer: _issuer!,
                                  algorithmIdentifier: _algorithmIdentifier!,
                                  username: widget.username!,
                                  serialNumber: _serialNumber!)),
                        );
                      }
                    },
                    child: const Text(
                      "Show certificate Details",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sign out from account."),
                      TextButton(
                        onPressed: () async {
                          // Call api logout and switch to login screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                          );
                        },
                        child: const Text("Sign Out",
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

  String? _getFieldFromSubject(
      x509.X509Certificate x509Certificate, String oid) {
    for (final dn in x509Certificate.tbsCertificate.subject!.names) {
      for (final entry in dn.entries) {
        if (entry.key!.name == oid) {
          return entry.value;
        }
      }
    }
    return null;
  }

  String? _getIssuerName(x509.X509Certificate x509Certificate, String oid) {
    for (final issuer in x509Certificate.tbsCertificate.issuer!.names) {
      for (final entry in issuer.entries) {
        if (entry.key!.name == oid) {
          return entry.value;
        }
      }
    }
    return null;
  }
}
