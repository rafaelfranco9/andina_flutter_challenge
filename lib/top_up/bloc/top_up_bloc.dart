import 'dart:async';

import 'package:andina_flutter_challenge/top_up/bloc/top_up_event.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_state.dart';
import 'package:api_client/api_client.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:user_repository/user_repository.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  TopUpBloc({
    required User currentUser,
    required UserRepository userRepository,
    required BeneficiariesRepository beneficiariesRepository,
    required TransactionsRepository transactionsRepository,
  })  : _currentUser = currentUser,
        _userRepository = userRepository,
        _beneficiariesRepository = beneficiariesRepository,
        _transactionsRepository = transactionsRepository,
        super(const TopUpState.initial()) {
    on<LoadBeneficiaries>(_onLoadBeneficiaries);
    on<LoadTransactions>(_onLoadTransactions);
    on<AddBeneficiary>(_onAddBeneficiary);
  }

  final User _currentUser;
  final UserRepository _userRepository;
  final BeneficiariesRepository _beneficiariesRepository;
  final TransactionsRepository _transactionsRepository;

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
      emit(state.copyWith(status: TopUpStatus.transactionsLoaded, transactions: transactions));
    } catch (e) {
      emit(state.copyWith(status: TopUpStatus.failure, errorMessage: 'Error fetching user transactions'));
    }
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
}
