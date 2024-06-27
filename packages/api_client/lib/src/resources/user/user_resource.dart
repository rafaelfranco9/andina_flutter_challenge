import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';

/// {@template user_resource}
/// User Resource.
/// {@endtemplate}
class UserResource {
  /// {@macro user_resource}
  UserResource({
    required AppHttpClient appHttpClient,
  }) : _appHttpClient = appHttpClient;

  final AppHttpClient _appHttpClient;

  static const _path = 'v1/user';

  /// Fetch user by id.
  Future<User> fetchUserById({required String id}) async {
    final data = await _appHttpClient.get('$_path/$id');
    if (data == null) {
      return User.empty;
    } else {
      final parsedJson = jsonDecode(data) as Map<String, dynamic>;
      return User.fromJson(parsedJson);
    }
  }
}
