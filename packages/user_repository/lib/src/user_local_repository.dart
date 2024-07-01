import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';
import 'package:user_repository/user_repository.dart';

class UserLocalRepository implements UserRepository {
  UserLocalRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(appHttpClient: HttpClientLocal());

  final ApiClient _apiClient;

  @override
  Future<void> addCreditToBalance(String id, double amount) async {
    final user = await _apiClient.userResource.fetchUserById(id: id);

    if (user == null) {
      throw Exception('User not found');
    }

    await _apiClient.userResource.updateUser(user: user.copyWith(balance: user.balance + amount));
  }

  @override
  Future<void> removeCreditFromBalance(String id, double amount) async {
    final user = await _apiClient.userResource.fetchUserById(id: id);

    if (user == null) {
      throw Exception('User not found');
    }

    await _apiClient.userResource.updateUser(user: user.copyWith(balance: user.balance - amount));
  }
}
