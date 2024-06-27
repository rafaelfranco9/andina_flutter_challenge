import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';

/// {@template api_client}
/// Api Client
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required AppHttpClient appHttpClient,
  }) : _appHttpClient = appHttpClient;

  final AppHttpClient _appHttpClient;

  /// {@macro user_resource}
  UserResource get userResource {
    return UserResource(appHttpClient: _appHttpClient);
  }
}
