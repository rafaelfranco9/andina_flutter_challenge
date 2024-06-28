import 'package:api_client/api_client.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);

  Future<void> signOut();
}
