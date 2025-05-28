import 'package:e2ee_device_binding_demo_flutter/main.dart';
import 'package:flutter/material.dart';

class ShowAccountScreen extends StatefulWidget {
  const ShowAccountScreen({
    Key? key,
    this.countryName,
    this.commonName,
    this.localityName,
    this.stateOrProvinceName,
    this.organizationName,
    this.organizationUnitName,
    this.startDate,
    this.endDate,
    this.issuer,
    this.algorithmIdentifier,
    this.username,
    this.serialNumber,
  }) : super(key: key);

  final String? countryName;
  final String? commonName;
  final String? localityName;
  final String? stateOrProvinceName;
  final String? organizationName;
  final String? organizationUnitName;
  final String? startDate;
  final String? endDate;
  final String? issuer;
  final String? algorithmIdentifier;
  final String? username;
  final String? serialNumber;

  @override
  State<ShowAccountScreen> createState() => _ShowAccountScreenState();
}

class _ShowAccountScreenState extends State<ShowAccountScreen> {
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
      backgroundColor: Colors.red[400],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.deepPurple[100],
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border:
                              Border.all(width: 1, color: Colors.blue.shade100),
                        ),
                        child: Container(
                          height: 70,
                          width: 70,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.memory(
                          //   widget.imageBytes!,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ),

                    // Display username
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget.username ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Account details
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('CERTIFICATE DETAILS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),

                    // Show country name
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Country Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.countryName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show common name
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Common Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.commonName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show locality name
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Locality Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.localityName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show state or province name
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('State or Province Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.stateOrProvinceName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show organization name
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Organization Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.organizationName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show organization unit name
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Organization Unit Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.organizationUnitName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show not before
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Not Before:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.startDate ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show not after
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Not After:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.endDate ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show issuer
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Issuer:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.issuer ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show signature algorithm
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Signature Algorithm:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(
                              _getSignatureAlgorithmMap(
                                  widget.algorithmIdentifier!),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show serial number
                    const SizedBox(height: 18),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Serial Number:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.serialNumber ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Logout button
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            minimumSize: const Size.fromHeight(45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25)),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              // fontSize: 20,
                              // fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getSignatureAlgorithmMap(String oid) {
    if (oid == "1.2.840.113549.1.1.5") {
      return "SHA-1 with RSA";
    } else if (oid == "1.2.840.113549.1.1.11") {
      return "SHA-256 with RSA";
    } else if (oid == "1.2.840.113549.1.1.12") {
      return "SHA-384 with RSA";
    } else if (oid == "1.2.840.113549.1.1.13") {
      return "SHA-512 with RSA";
    } else if (oid == "1.2.840.113549.1.1.10") {
      return "RSASSA-PSS";
    } else if (oid == "1.2.840.10045.4.1") {
      return "SHA-1 with ECDSA";
    } else if (oid == "1.2.840.10045.4.3.2") {
      return "SHA-256 with ECDSA";
    } else if (oid == "1.2.840.10045.4.3.3") {
      return "SHA-384 with ECDSA";
    } else if (oid == "1.2.840.10045.4.3.4") {
      return "SHA-512 with ECDSA";
    } else if (oid == "1.3.101.112") {
      return "Ed25519";
    } else if (oid == "1.3.101.113") {
      return "Ed448";
    } else {
      return "Not Specified";
    }
  }
}
