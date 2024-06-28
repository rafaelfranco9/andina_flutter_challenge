abstract class UserRepository {
  Future<void> addCreditToBalance(String id, int amount);

  Future<void> removeCreditFromBalance(String id, int amount);
}
