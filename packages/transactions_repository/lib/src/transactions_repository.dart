import 'package:api_client/api_client.dart';

abstract class TransactionsRepository {
  Future<List<Transaction>> fetchUserTransactions(String userId);

  Future<Map<String, List<Transaction>>> fetchUserMonthlyTransactionsByBeneficiary({
    required String userId,
    required int month,
    required int year,
  });
  Future<void> addTransaction({required String userId, required Transaction transaction});
}
