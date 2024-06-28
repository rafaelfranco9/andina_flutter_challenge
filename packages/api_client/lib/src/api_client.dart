import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';

class ApiClient {
  ApiClient({
    required AppHttpClient appHttpClient,
  }) : _appHttpClient = appHttpClient;

  final AppHttpClient _appHttpClient;

  UserResource get userResource {
    return UserResource(appHttpClient: _appHttpClient);
  }

  BeneficiariesResource get beneficiariesResource {
    return BeneficiariesResource(appHttpClient: _appHttpClient);
  }
}
