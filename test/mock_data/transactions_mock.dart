import 'package:api_client/api_client.dart';

final transactionsMock = [
  const Transaction(
    type: TransactionType.topUp,
    id: '1',
    userId: '123',
    beneficiaryId: '1',
    beneficiaryName: 'Rafael',
    amount: 100,
    cost: 1,
    currency: 'AED',
    date: '2024-07-01T10:22:39.436',
  ),
  const Transaction(
    type: TransactionType.topUp,
    id: '2',
    userId: '123',
    beneficiaryId: '2',
    beneficiaryName: 'Jessica',
    amount: 70,
    cost: 1,
    currency: 'AED',
    date: '2024-07-01T10:22:39.436',
  ),
  const Transaction(
    type: TransactionType.topUp,
    id: '3',
    userId: '123',
    beneficiaryId: '3',
    beneficiaryName: 'Maria',
    amount: 50,
    cost: 1,
    currency: 'AED',
    date: '2024-07-01T10:22:39.436',
  ),
];
