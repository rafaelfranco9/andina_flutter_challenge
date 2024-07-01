import 'dart:async';

import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_event.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_state.dart';
import 'package:andina_flutter_challenge/top_up/constants/constants.dart';
import 'package:api_client/api_client.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  TopUpBloc({
    required AppBloc appBloc,
    required UserRepository userRepository,
    required BeneficiariesRepository beneficiariesRepository,
    required TransactionsRepository transactionsRepository,
  })  : _appBloc = appBloc,
        _userRepository = userRepository,
        _beneficiariesRepository = beneficiariesRepository,
        _transactionsRepository = transactionsRepository,
        super(const TopUpState.initial()) {
    on<LoadBeneficiaries>(_onLoadBeneficiaries);
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadUserBalance>(_onLoadUserBalance);
    on<AddBeneficiary>(_onAddBeneficiary);
    on<TopUpBeneficiary>(_onTopUpBeneficiary);
    on<AddCredit>(_onAddCredit);
  }

  final AppBloc _appBloc;
  final UserRepository _userRepository;
  final BeneficiariesRepository _beneficiariesRepository;
  final TransactionsRepository _transactionsRepository;

  User get _currentUser => _appBloc.state.user!;
  bool get userIsVerified => _currentUser.isVerified;

  FutureOr<void> _onLoadBeneficiaries(LoadBeneficiaries event, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.loading));
    try {
      final beneficiaries = await _beneficiariesRepository.getUserBeneficiaries(_currentUser.id);
      emit(state.copyWith(status: TopUpStatus.beneficiariesLoaded, beneficiaries: beneficiaries));
    } catch (e) {
      emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Error fetching user beneficiaries'));
    }
  }

  FutureOr<void> _onLoadTransactions(LoadTransactions event, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.loading));
    try {
      final transactions = await _transactionsRepository.fetchUserTransactions(_currentUser.id);
      final reverseList = transactions.reversed.toList();
      emit(state.copyWith(status: TopUpStatus.transactionsLoaded, transactions: reverseList));
    } catch (e) {
      emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Error fetching user transactions'));
    }
  }

  FutureOr<void> _onLoadUserBalance(LoadUserBalance event, Emitter<TopUpState> emit) {
    emit(state.copyWith(userBalance: _currentUser.balance));
  }

  FutureOr<void> _onAddBeneficiary(AddBeneficiary event, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.loading));
    try {
      if (state.beneficiaries.length >= 5) {
        emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'You can only have 5 beneficiaries'));
        return;
      }

      await _beneficiariesRepository.addBeneficiary(_currentUser.id, event.beneficiary);
      emit(
        state.copyWith(
          status: TopUpStatus.beneficiaryAdded,
          beneficiaries: [...state.beneficiaries, event.beneficiary],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Error adding beneficiary'));
    }
  }

  FutureOr<void> _onTopUpBeneficiary(TopUpBeneficiary event, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.loading));
    try {
      const fixedFee = 1.0;
      final amountToCharge = event.amount + fixedFee;
      final userBalance = state.userBalance;
      final userIsVerified = _currentUser.isVerified;
      final userId = _currentUser.id;
      final now = DateTime.now();

      /// Check if user has enough funds
      if (amountToCharge > userBalance) {
        emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Insufficient funds'));
        return;
      }

      final monthTransactions = await _transactionsRepository.fetchUserMonthlyTransactionsByBeneficiary(
        userId: userId,
        month: now.month,
        year: now.year,
      );

      final totalMonthlyTopUps = monthTransactions.values
          .expand((element) => element)
          .where((element) => element.type == TransactionType.topUp)
          .fold<double>(0, (previousValue, transaction) => previousValue + transaction.amount);

      /// Check if user has reached the maximum top up amount for the month for all beneficiaries
      if (totalMonthlyTopUps + event.amount > kMaxTopUpMonthlyAmount) {
        emit(
          state.copyWith(
            status: TopUpStatus.failure,
            errorMessage: 'You have reached the maximum top up amount of AED $kMaxTopUpMonthlyAmount for this month',
          ),
        );
        return;
      }

      final beneficiaryTransactions = monthTransactions[event.beneficiary.id] ?? [];

      final totalBeneficiaryTopUpsAmount = beneficiaryTransactions
          .where((transaction) => transaction.type == TransactionType.topUp)
          .fold<double>(0, (previousValue, transaction) => previousValue + transaction.amount);

      /// Check if user has reached the maximum top up amount for the month for that beneficiary if user is not verified
      if (!userIsVerified && totalBeneficiaryTopUpsAmount + event.amount > kMaxUnverifiedMonthlyTopUpAmount) {
        emit(
          state.copyWith(
            status: TopUpStatus.failure,
            errorMessage:
                'You have reached the maximum top up amount of AED $kMaxUnverifiedMonthlyTopUpAmount for this month for this beneficiary',
          ),
        );
        return;
      }

      /// Check if user has reached the maximum top up amount for the month for that beneficiary if user is verified
      if (userIsVerified && totalBeneficiaryTopUpsAmount + event.amount > kMaxVerifiedMonthlyTopUpAmount) {
        emit(
          state.copyWith(
            status: TopUpStatus.failure,
            errorMessage:
                'You have reached the maximum top up amount of AED $kMaxVerifiedMonthlyTopUpAmount for this month for that beneficiary',
          ),
        );
        return;
      }

      final updatedBeneficiary = event.beneficiary.copyWith(balance: event.beneficiary.balance + event.amount);

      final transaction = Transaction(
        type: TransactionType.topUp,
        id: const Uuid().v4(),
        userId: userId,
        beneficiaryId: event.beneficiary.id,
        beneficiaryName: event.beneficiary.nickname,
        amount: event.amount,
        cost: fixedFee,
        currency: 'AED',
        date: DateTime.now().toIso8601String(),
      );

      await _userRepository.removeCreditFromBalance(userId, amountToCharge);
      await _beneficiariesRepository.updateBeneficiary(userId, updatedBeneficiary);
      await _transactionsRepository.addTransaction(userId: userId, transaction: transaction);

      final updatedBeneficiaries =
          state.beneficiaries.map((b) => b.id == updatedBeneficiary.id ? updatedBeneficiary : b).toList();
      final updatedTransactions = [transaction, ...state.transactions];

      emit(
        state.copyWith(
          userBalance: userBalance - amountToCharge,
          status: TopUpStatus.topUpSuccess,
          beneficiaries: updatedBeneficiaries,
          transactions: updatedTransactions,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Error topping up beneficiary'));
    }
  }

  FutureOr<void> _onAddCredit(AddCredit event, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.loading));
    try {
      await _userRepository.addCreditToBalance(_currentUser.id, event.amount);
      emit(
        state.copyWith(
          status: TopUpStatus.creditAdded,
          userBalance: state.userBalance + event.amount,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Error adding credit'));
    }
  }
}
