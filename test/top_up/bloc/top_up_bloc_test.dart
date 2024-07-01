import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/extensions/datetime_extension.dart';
import 'package:andina_flutter_challenge/main/main.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_bloc.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_event.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_state.dart';
import 'package:andina_flutter_challenge/top_up/constants/constants.dart';
import 'package:api_client/api_client.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid_service/uuid_service.dart';

import '../../mock_data/beneficiaries_mock.dart';
import '../../mock_data/beneficiaries_transactions_mock.dart';
import '../../mock_data/beneficiary_mock.dart';
import '../../mock_data/transaction_mock.dart';
import '../../mock_data/transactions_mock.dart';

class AppBlocMock extends Mock implements AppBloc {}

class UserRepositoryMock extends Mock implements UserRepository {}

class BeneficiariesRepositoryMock extends Mock implements BeneficiariesRepository {}

class TransactionsRepositoryMock extends Mock implements TransactionsRepository {}

class UuidServiceMock extends Mock implements UuidService {}

void main() {
  const creditToAdd = 100.0;
  final now = DateTime.now();
  ExtendedDateTime.customTime = now;

  group('TopUpBloc', () {
    late AppBlocMock appBloc;
    late UserRepositoryMock userRepository;
    late BeneficiariesRepositoryMock beneficiariesRepository;
    late TransactionsRepositoryMock transactionsRepository;
    late TopUpBloc topUpBloc;
    late UuidService uuidService;

    setUp(() {
      /// Create mock classes
      appBloc = AppBlocMock();
      userRepository = UserRepositoryMock();
      beneficiariesRepository = BeneficiariesRepositoryMock();
      transactionsRepository = TransactionsRepositoryMock();
      uuidService = UuidServiceMock();

      /// Register fallback values
      registerFallbackValue(beneficiaryMock);
      registerFallbackValue(transactionMock);

      /// Mocks answers
      when(() => appBloc.state).thenReturn(const AppState(flavor: Flavor.dev, user: mockUser));
      when(() => uuidService.v4()).thenReturn('1');
      when(() => beneficiariesRepository.getUserBeneficiaries(any())).thenAnswer((_) async => beneficiariesMock);
      when(() => userRepository.addCreditToBalance(any(), any())).thenAnswer((_) async => Future.value());
      when(() => userRepository.removeCreditFromBalance(any(), any())).thenAnswer((_) async => Future.value());
      when(() => beneficiariesRepository.addBeneficiary(any(), any())).thenAnswer((_) async => Future.value());
      when(() => beneficiariesRepository.updateBeneficiary(any(), any())).thenAnswer((_) async => Future.value());
      when(() => transactionsRepository.fetchUserTransactions(any())).thenAnswer((_) async => transactionsMock);
      when(() => transactionsRepository.addTransaction(
          userId: any(named: 'userId'), transaction: any(named: 'transaction'))).thenAnswer(
        (_) async => transactionsMock,
      );

      /// Create bloc
      topUpBloc = TopUpBloc(
        appBloc: appBloc,
        userRepository: userRepository,
        beneficiariesRepository: beneficiariesRepository,
        transactionsRepository: transactionsRepository,
        uuidService: uuidService,
      );
    });

    test('Initial State', () {
      expect(topUpBloc.state, const TopUpState.initial());
    });

    blocTest(
      'LoadBeneficiaries',
      build: () => topUpBloc,
      act: (bloc) => bloc.add(const LoadBeneficiaries()),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading),
        TopUpState(status: TopUpStatus.beneficiariesLoaded, beneficiaries: beneficiariesMock),
      ],
    );

    blocTest(
      'LoadTransactions',
      build: () => topUpBloc,
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading),
        TopUpState(status: TopUpStatus.transactionsLoaded, transactions: transactionsMock.reversed.toList()),
      ],
    );

    blocTest(
      'LoadUserBalance',
      build: () => topUpBloc,
      act: (bloc) => bloc.add(const LoadUserBalance()),
      expect: () => [
        TopUpState(userBalance: mockUser.balance, status: TopUpStatus.initial),
      ],
    );

    blocTest(
      'AddBeneficiary',
      build: () => topUpBloc,
      act: (bloc) => bloc.add(const AddBeneficiary(beneficiary: beneficiaryMock)),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading),
        const TopUpState(status: TopUpStatus.beneficiaryAdded, beneficiaries: [beneficiaryMock]),
      ],
    );

    blocTest(
      'AddBeneficiary with 5 beneficiaries Error',
      build: () => topUpBloc,
      seed: () => TopUpState(beneficiaries: beneficiariesMock, status: TopUpStatus.initial),
      act: (bloc) => bloc.add(const AddBeneficiary(beneficiary: beneficiaryMock)),
      expect: () => [
        TopUpState(status: TopUpStatus.loading, beneficiaries: beneficiariesMock),
        TopUpState(
          status: TopUpStatus.failure,
          errorMessage: kCanNotAddBeneficiaryErrorMessage,
          beneficiaries: beneficiariesMock,
        ),
      ],
    );

    blocTest(
      'AddCredit',
      build: () => topUpBloc,
      act: (bloc) => bloc.add(const AddCredit(creditToAdd)),
      seed: () => TopUpState(userBalance: mockUser.balance, status: TopUpStatus.initial),
      expect: () => [
        TopUpState(status: TopUpStatus.loading, userBalance: mockUser.balance),
        TopUpState(status: TopUpStatus.creditAdded, userBalance: mockUser.balance + creditToAdd),
      ],
    );

    blocTest(
      'TopUpBeneficiary (Not enough funds)',
      build: () => topUpBloc,
      act: (bloc) => bloc.add(const TopUpBeneficiary(amount: 50, beneficiary: beneficiaryMock)),
      seed: () => const TopUpState(userBalance: 10, status: TopUpStatus.initial),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading, userBalance: 10),
        const TopUpState(status: TopUpStatus.failure, userBalance: 10, errorMessage: kInsufficientFundsErrorMessage),
      ],
    );

    blocTest(
      'TopUpBeneficiary (Reach max monthly transactions of 3k)',
      build: () => topUpBloc,
      setUp: () {
        when(() => transactionsRepository.fetchUserMonthlyTransactionsByBeneficiary(
            userId: any(named: 'userId'),
            month: any(named: 'month'),
            year: any(named: 'year'))).thenAnswer((_) async => beneficiariesTransactions3kMock);
      },
      seed: () => const TopUpState(userBalance: 100, status: TopUpStatus.initial),
      act: (bloc) => bloc.add(const TopUpBeneficiary(amount: 50, beneficiary: beneficiaryMock)),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading, userBalance: 100),
        const TopUpState(
          status: TopUpStatus.failure,
          userBalance: 100,
          errorMessage: kMaxTopUpMonthlyAmountErrorMessage,
        ),
      ],
    );

    blocTest(
      'TopUpBeneficiary (Reach max monthly transactions for beneficiary -verified-)',
      build: () => topUpBloc,
      setUp: () {
        when(() => transactionsRepository.fetchUserMonthlyTransactionsByBeneficiary(
            userId: any(named: 'userId'),
            month: any(named: 'month'),
            year: any(named: 'year'))).thenAnswer((_) async => beneficiariesTransactionsMock);
      },
      seed: () => const TopUpState(userBalance: 100, status: TopUpStatus.initial),
      act: (bloc) => bloc.add(const TopUpBeneficiary(amount: 50, beneficiary: beneficiaryMock)),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading, userBalance: 100),
        const TopUpState(
          status: TopUpStatus.failure,
          userBalance: 100,
          errorMessage: kMaxVerifiedMonthlyTopUpAmountErrorMessage,
        ),
      ],
    );

    blocTest(
      'TopUpBeneficiary (Reach max monthly transactions for beneficiary -unverified-)',
      build: () => topUpBloc,
      setUp: () {
        when(() => appBloc.state).thenReturn(AppState(flavor: Flavor.dev, user: mockUser.copyWith(isVerified: false)));
        when(() => transactionsRepository.fetchUserMonthlyTransactionsByBeneficiary(
            userId: any(named: 'userId'),
            month: any(named: 'month'),
            year: any(named: 'year'))).thenAnswer((_) async => beneficiariesTransactionsMock);
      },
      seed: () => const TopUpState(userBalance: 100, status: TopUpStatus.initial),
      act: (bloc) => bloc.add(TopUpBeneficiary(amount: 50, beneficiary: beneficiaryMock.copyWith(id: '2'))),
      expect: () => [
        const TopUpState(status: TopUpStatus.loading, userBalance: 100),
        const TopUpState(
          status: TopUpStatus.failure,
          userBalance: 100,
          errorMessage: kMaxUnverifiedMonthlyTopUpAmountErrorMessage,
        ),
      ],
    );

    const initialUserBalance = 100.0;
    const amountToTopUp = 50.0;
    const fixedFee = 1.0;
    blocTest(
      'TopUpBeneficiary (Success)',
      build: () => topUpBloc,
      setUp: () {
        when(() => transactionsRepository.fetchUserMonthlyTransactionsByBeneficiary(
                userId: any(named: 'userId'), month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => {
                  beneficiary2Mock.id: [],
                });
      },
      seed: () => const TopUpState(
        userBalance: initialUserBalance,
        status: TopUpStatus.initial,
        beneficiaries: [beneficiary2Mock],
      ),
      act: (bloc) => bloc.add(const TopUpBeneficiary(amount: amountToTopUp, beneficiary: beneficiary2Mock)),
      expect: () => [
        const TopUpState(
            status: TopUpStatus.loading, userBalance: initialUserBalance, beneficiaries: [beneficiary2Mock]),
        TopUpState(
          status: TopUpStatus.topUpSuccess,
          userBalance: initialUserBalance - amountToTopUp - fixedFee,
          transactions: [
            Transaction(
              type: TransactionType.topUp,
              id: '1',
              userId: mockUser.id,
              beneficiaryId: beneficiary2Mock.id,
              beneficiaryName: beneficiary2Mock.nickname,
              amount: amountToTopUp,
              cost: fixedFee,
              currency: 'AED',
              date: ExtendedDateTime.current.toIso8601String(),
            )
          ],
          beneficiaries: [beneficiary2Mock.copyWith(balance: beneficiary2Mock.balance + 50)],
        ),
      ],
    );
  });
}
