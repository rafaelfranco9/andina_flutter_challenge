import 'package:api_client/src/resources/transactions/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required TransactionType type,
    required String id,
    required String userId,
    required String beneficiaryId,
    required String beneficiaryName,
    required double amount,
    required double cost,
    required String currency,
    required String date,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  /// Returns an empty [Transaction].
  static const empty = Transaction(
    id: '',
    userId: '',
    beneficiaryId: '',
    beneficiaryName: '',
    amount: 0,
    cost: 0,
    currency: '',
    type: TransactionType.unknown,
    date: '',
  );
}
