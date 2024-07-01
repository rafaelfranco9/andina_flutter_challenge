import 'dart:convert';

import 'package:app_http_client/src/app_http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpClientLocal implements AppHttpClient {
  HttpClientLocal({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  bool _supportedBodyType(dynamic body) {
    return body is Map || body is List;
  }

  /// Simulate a get request
  @override
  Future<String?> get(String path) async {
    return _secureStorage.read(key: path);
  }

  /// Simulate a post request
  @override
  Future<void> post(String path, dynamic body) async {
    if (_supportedBodyType(body) == false) {
      throw Exception('Unsupported body type');
    }

    final value = body is String ? body : jsonEncode(body);
    await _secureStorage.write(key: path, value: value);
  }

  /// Simulate a put request
  @override
  Future<void> put(String path, dynamic body) async {
    final keyExists = await _secureStorage.containsKey(key: path);
    if (!keyExists) {
      await _secureStorage.write(key: path, value: jsonEncode(body));
      return;
    }

    final currentValue = await _secureStorage.read(key: path);
    final currentBody = jsonDecode(currentValue!);

    if (currentBody is List) {
      await _secureStorage.write(key: path, value: jsonEncode([...currentBody, ...body]));
      return;
    }

    if (currentBody is Map) {
      await _secureStorage.write(key: path, value: jsonEncode({...currentBody, ...body}));
      return;
    }

    throw Exception('Unsupported body type');
  }
}
