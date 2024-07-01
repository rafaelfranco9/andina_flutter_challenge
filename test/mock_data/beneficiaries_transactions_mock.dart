import 'package:api_client/api_client.dart';

final beneficiariesTransactionsMock = {
  '1': [
    const Transaction(
      type: TransactionType.topUp,
      id: '1',
      userId: '123',
      beneficiaryId: '1',
      beneficiaryName: 'Rafael',
      date: '2024-07-01T10:22:39.436',
      amount: 600,
      cost: 1,
      currency: 'AED',
    ),
    const Transaction(
      type: TransactionType.topUp,
      id: '1',
      userId: '123',
      beneficiaryId: '1',
      beneficiaryName: 'Rafael',
      date: '2024-07-01T10:22:39.436',
      amount: 400,
      cost: 1,
      currency: 'AED',
    ),
  ],
  '2': [
    const Transaction(
      type: TransactionType.topUp,
      id: '1',
      userId: '123',
      beneficiaryId: '2',
      beneficiaryName: 'Jessica',
      date: '2024-07-01T10:22:39.436',
      amount: 500,
      cost: 1,
      currency: 'AED',
    ),
  ],
};

final beneficiariesTransactions3kMock = {
  '1': [
    const Transaction(
      type: TransactionType.topUp,
      id: '1',
      userId: '123',
      beneficiaryId: '1',
      beneficiaryName: 'Rafael',
      date: '2024-07-01T10:22:39.436',
      amount: 1000,
      cost: 1,
      currency: 'AED',
    ),
  ],
  '2': [
    const Transaction(
      type: TransactionType.topUp,
      id: '1',
      userId: '123',
      beneficiaryId: '2',
      beneficiaryName: 'Jessica',
      date: '2024-07-01T10:22:39.436',
      amount: 1000,
      cost: 1,
      currency: 'AED',
    ),
  ],
  '3': [
    const Transaction(
      type: TransactionType.topUp,
      id: '1',
      userId: '123',
      beneficiaryId: '3',
      beneficiaryName: 'Maria',
      date: '2024-07-01T10:22:39.436',
      amount: 1000,
      cost: 1,
      currency: 'AED',
    ),
  ],
};
