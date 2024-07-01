import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

abstract class TopUpEvent extends Equatable {
  const TopUpEvent();

  @override
  List<Object> get props => [];
}

class LoadUserBalance extends TopUpEvent {
  const LoadUserBalance();

  @override
  List<Object> get props => [];
}

class LoadBeneficiaries extends TopUpEvent {
  const LoadBeneficiaries();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TopUpEvent {
  const LoadTransactions();

  @override
  List<Object> get props => [];
}

class AddBeneficiary extends TopUpEvent {
  const AddBeneficiary({required this.beneficiary});

  final Beneficiary beneficiary;

  @override
  List<Object> get props => [beneficiary];
}

class TopUpBeneficiary extends TopUpEvent {
  const TopUpBeneficiary({required this.amount, required this.beneficiary});

  final Beneficiary beneficiary;
  final double amount;

  @override
  List<Object> get props => [amount, beneficiary];
}

class AddCredit extends TopUpEvent {
  const AddCredit(this.amount);

  final double amount;

  @override
  List<Object> get props => [amount];
}
