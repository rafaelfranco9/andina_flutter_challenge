import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';

class TransactionsResource {
  TransactionsResource({required AppHttpClient appHttpClient}) : _appHttpClient = appHttpClient;

  final AppHttpClient _appHttpClient;

  static const _path = 'v1/transactions';

  Future<List<Transaction>> fetchUserTransactions(String userId) async {
    final data = await _appHttpClient.get('$_path/$userId');

    if (data == null) {
      return [];
    } else {
      final parsedJson = jsonDecode(data) as List<dynamic>;
      return parsedJson.map((e) => Transaction.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  Future<void> addTransaction({required String userId, required Transaction transaction}) async {
    await _appHttpClient.put('$_path/${userId}', [transaction.toJson()]);
  }
}
