import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';
import 'package:transactions_repository/src/transactions_repository.dart';

class TransactionsLocalRepository implements TransactionsRepository {
  TransactionsLocalRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(appHttpClient: HttpClientLocal());

  final ApiClient _apiClient;

  @override
  Future<void> addTransaction({required String userId, required Transaction transaction}) async {
    await _apiClient.transactionsResource.addTransaction(userId: userId, transaction: transaction);
  }

  @override
  Future<List<Transaction>> fetchUserTransactions(String userId) {
    return _apiClient.transactionsResource.fetchUserTransactions(userId);
  }

  @override
  Future<Map<String, List<Transaction>>> fetchUserMonthlyTransactionsByBeneficiary({
    required String userId,
    required int month,
    required int year,
  }) async {
    final transactions = await _apiClient.transactionsResource.fetchUserTransactions(userId);

    final monthTransactions = transactions.where((transaction) {
      final date = DateTime.parse(transaction.date);
      return date.month == month && date.year == year;
    });

    final transactionsByBeneficiary = <String, List<Transaction>>{};
    for (final transaction in monthTransactions) {
      if (transactionsByBeneficiary.containsKey(transaction.beneficiaryId)) {
        transactionsByBeneficiary[transaction.beneficiaryId]!.add(transaction);
      } else {
        transactionsByBeneficiary[transaction.beneficiaryId] = [transaction];
      }
    }

    return transactionsByBeneficiary;
  }
}
