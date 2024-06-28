import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';
import 'package:auth_repository/auth_repository.dart';

class AuthLocalRepository implements AuthRepository {
  final ApiClient _apiClient;

  AuthLocalRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(appHttpClient: HttpClientLocal());

  @override
  Future<User> login(String email, String password) async {
    await _apiClient.userResource.createUser(user: mockUser);
    return _apiClient.userResource.fetchUserById(id: mockUser.id);
  }

  @override
  Future<void> signOut() {
    return Future.value();
  }
}
