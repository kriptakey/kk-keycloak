import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mobile_client_auth/show_token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_client_auth/error.dart';

void main() async {
  setupWindow();
  runApp(const LoginScreen());
}

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('E2EE Mobile Client Authentication');
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Client Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  String? _error;
  bool _isBusy = false;
  Map<String, dynamic>? _decodedIdToken;

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final String _clientId = 'kki-rnd';
  final String _redirectUrl = 'org.openid.appauthdemo:/oauth4redirect';
  final AuthorizationServiceConfiguration
  _serviceConfiguration = const AuthorizationServiceConfiguration(
    authorizationEndpoint:
        'https://kki-auth.rafly-dev.my.id/realms/KKI-Batam/protocol/openid-connect/auth',
    tokenEndpoint:
        'https://kki-auth.rafly-dev.my.id/realms/KKI-Batam/protocol/openid-connect/token',
    endSessionEndpoint:
        'https://kki-auth.rafly-dev.my.id/realms/KKI-Batam/protocol/openid-connect/logout',
  );
  final List<String> _scopes = <String>['openid', 'profile', 'email'];
  final String _postLogoutRedirectUrl =
      'org.openid.appauthdemo:/oauth4redirect';
  final String _clientSecret = "yhxhFp8kO73mGHQ81noLLYY1xmAV43Jb";

  @override
  Widget build(BuildContext context) {
    // UI for Login/Main screen
    return MaterialApp(
      home: Scaffold(
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
                // Username or person id
                const SizedBox(height: 60),
                Center(
                  child: Image.asset('assets/images/screen_background.png'),
                ),

                const SizedBox(height: 120),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        await _signInWithAutoCodeExchange(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithAutoCodeExchange(
    BuildContext context, {
    ExternalUserAgent externalUserAgent =
        ExternalUserAgent.asWebAuthenticationSession,
  }) async {
    try {
      _setBusyState();

      /*
        This shows that we can also explicitly specify the endpoints rather than
        getting from the details from the discovery document.
      */
      final AuthorizationTokenResponse result = await _appAuth
          .authorizeAndExchangeCode(
            AuthorizationTokenRequest(
              _clientId,
              _redirectUrl,
              serviceConfiguration: _serviceConfiguration,
              scopes: _scopes,
              externalUserAgent: externalUserAgent,
              allowInsecureConnections: true,
              clientSecret: _clientSecret,
            ),
          );

      print("Access token: ${result.accessToken!}");
      print("Id token: ${result.idToken}");

      if (result.idToken != null) {
        _decodedIdToken = JwtDecoder.decode(result.idToken!);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShowTokenScreen(
                clientId: _decodedIdToken!['aud'],
                name: _decodedIdToken!['name'],
                preferredUsername: _decodedIdToken!['preferred_username'],
                givenName: _decodedIdToken!['given_name'],
                familyName: _decodedIdToken!['family_name'],
                email: _decodedIdToken!['email'],
                appAuth: _appAuth,
                idToken: result.idToken,
                postLogoutRedirectUri: _postLogoutRedirectUrl,
                serviceConfiguration: _serviceConfiguration,
              ),
            ),
          );
        }
      } else {
        // getAlert("Alert: Id token is null");
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ErrorScreen(error: "Alert: Id token is null"),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ErrorScreen(error: "Error: ${e.toString()}"),
          ),
        );
      }
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
        _error =
            'Error\n\nCode: ${e.code}\nMessage: ${e.message}\n'
            'Details: ${e.details}';
      });
    } else {
      setState(() {
        _error = 'Error: $e';
      });
    }
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  void _setBusyState() {
    setState(() {
      _error = '';
      _isBusy = true;
    });
  }

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
            SystemNavigator.pop();
          },
        ),
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
