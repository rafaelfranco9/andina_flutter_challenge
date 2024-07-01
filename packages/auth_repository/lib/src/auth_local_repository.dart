import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';
import 'package:auth_repository/auth_repository.dart';

class AuthLocalRepository implements AuthRepository {
  final ApiClient _apiClient;

  AuthLocalRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(appHttpClient: HttpClientLocal());

  @override
  Future<User> login(String email, String password) async {
    final user = await _apiClient.userResource.fetchUserById(id: mockUser.id);

    if (user == null) {
      await _apiClient.userResource.createUser(user: mockUser);
      return mockUser;
    }

    return user;
  }

  @override
  Future<void> signOut() {
    return Future.value();
  }

  @override
  Future<User?> reload(String id) {
    return _apiClient.userResource.fetchUserById(id: id);
  }
}
