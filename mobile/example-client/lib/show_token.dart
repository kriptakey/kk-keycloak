import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter/services.dart';

import 'package:mobile_client_auth/main.dart';

class ShowTokenScreen extends StatefulWidget {
  const ShowTokenScreen({
    Key? key,
    this.clientId,
    this.name,
    this.preferredUsername,
    this.givenName,
    this.familyName,
    this.email,
    this.appAuth,
    this.idToken,
    this.postLogoutRedirectUri,
    this.serviceConfiguration,
  }) : super(key: key);

  final String? clientId;
  final String? name;
  final String? preferredUsername;
  final String? givenName;
  final String? familyName;
  final String? email;
  final FlutterAppAuth? appAuth;
  final String? idToken;
  final String? postLogoutRedirectUri;
  final AuthorizationServiceConfiguration? serviceConfiguration;

  @override
  State<ShowTokenScreen> createState() => _ShowTokenScreenState();
}

class _ShowTokenScreenState extends State<ShowTokenScreen> {
  String? _error;
  bool _isBusy = false;

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
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
      ),
      backgroundColor: Colors.red[400],
    ));
  }

  void switchToLoginScreen(String message) {
    if (!context.mounted) return;
    // Notify user that session has been created
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Switch to insert otp screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
      ),
      backgroundColor: Colors.deepPurple,
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

                    // Display access token
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget.name ?? 'N/A',
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
                      child: const Text('ACCOUNT DETAILS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),

                    // Show name
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
                          const Text('Full Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.name ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show First Name
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
                          const Text('First Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.givenName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show Family Name
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
                          const Text('Family Name:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.familyName ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show Username
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
                          const Text('Username:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.preferredUsername ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show email
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
                          const Text('Email:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.email ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),
                    ),

                    // Show Client Id
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
                          const Text('Client Id:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 7),
                          Text(widget.clientId ?? 'N/A',
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
                          await _endSession(context);
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

  Future<void> _endSession(BuildContext context,
      {ExternalUserAgent externalUserAgent =
          ExternalUserAgent.asWebAuthenticationSession}) async {
    try {
      _setBusyState();
      await widget.appAuth!.endSession(EndSessionRequest(
          idTokenHint: widget.idToken,
          postLogoutRedirectUrl: widget.postLogoutRedirectUri,
          serviceConfiguration: widget.serviceConfiguration,
          externalUserAgent: externalUserAgent));

      // Switch to main screen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _clearBusyState();
    }
  }

  void _handleError(Object e) {
    if (e is FlutterAppAuthUserCancelledException) {
      setState(() {
        _error = 'The user cancelled the flow!';
      });
    } else if (e is FlutterAppAuthPlatformException) {
      setState(() {
        _error = e.platformErrorDetails.toString();
      });
    } else if (e is PlatformException) {
      setState(() {
        _error = 'Error\n\nCode: ${e.code}\nMessage: ${e.message}\n'
            'Details: ${e.details}';
      });
    } else {
      setState(() {
        _error = 'Error: $e';
      });
    }
  }

  void _setBusyState() {
    setState(() {
      _error = '';
      _isBusy = true;
    });
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }
}
