abstract class UserRepository {
  Future<void> addCreditToBalance(String id, double amount);

  Future<void> removeCreditFromBalance(String id, double amount);
}
