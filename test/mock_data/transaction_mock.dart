import 'package:api_client/api_client.dart';

const transactionMock = Transaction(
  type: TransactionType.topUp,
  id: '1',
  userId: '123',
  beneficiaryId: '1',
  beneficiaryName: 'Rafael',
  amount: 100,
  cost: 1,
  currency: 'AED',
  date: '2024-07-01T10:22:39.436',
);
