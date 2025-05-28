import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:e2ee_device_binding_demo_flutter/core/config.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Dio> createDioWithSelfSignedCert() async {
    // Load the self-signed cert from assets
    final sslCert = await rootBundle.load('assets/keycloak-server.pem');

    // Create a custom SecurityContext
    SecurityContext context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    // Use the custom context in HttpClient
    final httpClient = HttpClient(context: context);

    // Hook HttpClient into Dio
    final adapter = DefaultHttpClientAdapter();
    adapter.onHttpClientCreate = (_) => httpClient;

    final dio = Dio();
    // dio.httpClientAdapter = adapter;

    // Custom adapter to override cert validation
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // 🔥 This skips ALL certificate validation, including IP/domain mismatch
        return true;
      };
      return client;
    };

    return dio;
  }

  Future<Map<String, dynamic>> processQRCodeRegister(
      Map<String, dynamic>? certificateRequestData) async {
    try {
      print("Inside processQR API");
      print("Certificate request data: ${jsonEncode(certificateRequestData)}");
      final dio = await createDioWithSelfSignedCert();
      Response? response;

      if (Config().getAddress() != null) {
        response = await dio.post(
            '${Config().getAddress()}/realms/${Config().getRealmName()}/kki-e2ee-qrcode-res/process/register-csr',
            data: {
              "username": certificateRequestData!['username'],
              "sessionMetadata": certificateRequestData['sessionMetadata']
            },
            options: Options(headers: {
              'content-type': 'application/json',
              'Access-Control-Allow-Origin':
                  '${Config().getAddress()}/realms/${Config().getRealmName()}/kki-e2ee-qrcode-res/process/register-csr',
            }));
      } else {
        response = await dio.post(
            'https://kki-auth.rafly-dev.my.id/realms/quickstart/kki-e2ee-qrcode-res/process/register-csr',
            data: {
              "username": certificateRequestData!['username'],
              "sessionMetadata": certificateRequestData['sessionMetadata']
            },
            options: Options(headers: {
              'content-type': 'application/json',
              'Access-Control-Allow-Origin':
                  'https://kki-auth.rafly-dev.my.id/realms/quickstart/kki-e2ee-qrcode-res/process/register-csr',
            }));
      }
      return response.data;
    } on DioException catch (e) {
      print("Error processQRCodeRegister: ${e.message}");
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          print("Connection timeout.");
          break;
        case DioExceptionType.sendTimeout:
          print("Send timeout.");
          break;
        case DioExceptionType.receiveTimeout:
          print("Receive timeout.");
          break;
        case DioExceptionType.badResponse:
          print(
              "Bad response: ${e.response?.statusCode} - ${e.response?.data}");
          break;
        case DioExceptionType.cancel:
          print("Request to server was cancelled.");
          break;
        case DioExceptionType.connectionError:
          print("Connection error: ${e.error}");
          break;
        case DioExceptionType.unknown:
          print("Unknown error: ${e.error}");
          break;
        case DioExceptionType.badCertificate:
          print("Bad certificate: ${e.error}");
          break;
      }
      // Optional: return a fallback error structure
      return {
        'success': false,
        'error': e.message,
        'details': e.response?.data ?? 'No response data',
      };
    } catch (e, stacktrace) {
      print("Unexpected error: $e");
      print("Stacktrace: $stacktrace");

      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> processQRCodeLogin(
      Map<String, dynamic>? signatureRequestData) async {
    try {
      print("Inside processQR API");
      print("Signature request data: ${jsonEncode(signatureRequestData)}");
      final dio = await createDioWithSelfSignedCert();
      Response? response;
      if (Config().getAddress() != null) {
        response = await dio.post(
            '${Config().getAddress()}/realms/${Config().getRealmName()}/kki-e2ee-qrcode-res/process/login',
            data: {
              "username": signatureRequestData!['username'],
              "signatureMetadata": signatureRequestData['signatureMetadata']
            },
            options: Options(headers: {
              'content-type': 'application/json',
              'Access-Control-Allow-Origin':
                  '${Config().getAddress()}/realms/${Config().getRealmName()}/kki-e2ee-qrcode-res/process/login',
            }));
      } else {
        response = await dio.post(
            'https://kki-auth.rafly-dev.my.id/realms/quickstart/kki-e2ee-qrcode-res/process/login',
            data: {
              "username": signatureRequestData!['username'],
              "signatureMetadata": signatureRequestData['signatureMetadata']
            },
            options: Options(headers: {
              'content-type': 'application/json',
              'Access-Control-Allow-Origin':
                  'https://kki-auth.rafly-dev.my.id/realms/quickstart/kki-e2ee-qrcode-res/process/login',
            }));
      }
      return response!.data;
    } on DioException catch (e) {
      // Return the error object if any
      print(e.stackTrace.toString());
      // return e.response!.data;
      rethrow;
    }
  }
}
