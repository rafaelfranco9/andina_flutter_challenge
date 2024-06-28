import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

enum TopUpStatus {
  initial,
  loading,
  beneficiariesLoaded,
  transactionsLoaded,
  topUpSuccess,
  beneficiaryAdded,
  failure;

  bool get isInitial => this == TopUpStatus.initial;
  bool get isLoading => this == TopUpStatus.loading;
  bool get isFailure => this == TopUpStatus.failure;
  bool get isBeneficiariesLoaded => this == TopUpStatus.beneficiariesLoaded;
  bool get isTransactionsLoaded => this == TopUpStatus.transactionsLoaded;
  bool get isBeneficiaryAdded => this == TopUpStatus.beneficiaryAdded;
  bool get isTopUpSuccess => this == TopUpStatus.topUpSuccess;
}

class TopUpState extends Equatable {
  const TopUpState({
    required this.status,
    this.errorMessage = '',
    this.beneficiaries = const [],
    this.transactions = const [],
  });

  const TopUpState.initial() : this(status: TopUpStatus.initial);

  final TopUpStatus status;
  final List<Beneficiary> beneficiaries;
  final List<Transaction> transactions;
  final String errorMessage;

  TopUpState copyWith({
    TopUpStatus? status,
    String? errorMessage,
    List<Beneficiary>? beneficiaries,
    List<Transaction>? transactions,
  }) {
    return TopUpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, beneficiaries, transactions];
}
