import 'dart:convert';

import 'package:app_http_client/src/app_http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpClientLocalMock implements AppHttpClient {
  HttpClientLocalMock({
    required FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  /// Simulate a get request
  @override
  Future<String?> get(String path) async {
    return _secureStorage.read(key: path);
  }

  /// Simulate a post request
  @override
  Future<void> post(String path, Map<String, dynamic> body) async {
    await _secureStorage.write(key: path, value: jsonEncode(body));
  }

  /// Simulate a put request
  @override
  Future<void> put(String path, Map<String, dynamic> body) async {
    final keyExists = await _secureStorage.containsKey(key: path);
    if (!keyExists) {
      await _secureStorage.write(key: path, value: jsonEncode(body));
    }

    final currentValue = await _secureStorage.read(key: path);
    final currentBody = (jsonDecode(currentValue!) as Map<String, dynamic>)
      ..addAll(
        body,
      );

    await _secureStorage.write(key: path, value: jsonEncode(currentBody));
  }
}
