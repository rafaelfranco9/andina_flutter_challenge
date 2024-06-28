import 'package:api_client/api_client.dart';

abstract class TransactionsRepository {
  Future<List<Transaction>> fetchUserTransactions(String userId);

  Future<void> addTransaction({required String userId, required Transaction transaction});
}
