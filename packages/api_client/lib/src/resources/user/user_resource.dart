import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';

class UserResource {
  UserResource({
    required AppHttpClient appHttpClient,
  }) : _appHttpClient = appHttpClient;

  final AppHttpClient _appHttpClient;

  static const _path = 'v1/user';

  /// Fetch user by id.
  Future<User?> fetchUserById({required String id}) async {
    final data = await _appHttpClient.get('$_path/$id');

    if (data != null) {
      final parsedJson = jsonDecode(data) as Map<String, dynamic>;
      return User.fromJson(parsedJson);
    }

    return null;
  }

  /// Create user
  Future<void> createUser({required User user}) async {
    await _appHttpClient.put('$_path/${user.id}', user.toJson());
  }

  /// Update user
  Future<void> updateUser({required User user}) async {
    await _appHttpClient.put('$_path/${user.id}', user.toJson());
  }
}
