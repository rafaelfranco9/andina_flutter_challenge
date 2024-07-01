import 'dart:math';

import 'package:andina_flutter_challenge/app/bloc/app_bloc.dart';
import 'package:andina_flutter_challenge/app/bloc/listeners/app_status_listener.dart';
import 'package:andina_flutter_challenge/top_up/bloc/listeners/top_up_status_listener.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_event.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_state.dart';
import 'package:andina_flutter_challenge/top_up/widgets/add_beneficiary_action_button.dart';
import 'package:andina_flutter_challenge/top_up/widgets/add_beneficiary_bottom_sheet.dart';
import 'package:andina_flutter_challenge/top_up/widgets/beneficiary_card.dart';
import 'package:andina_flutter_challenge/top_up/widgets/top_up_options_bottom_sheet.dart';
import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../bloc/top_up_bloc.dart';
import '../widgets/add_balance_button.dart';

class TopUpView extends StatelessWidget {
  const TopUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user!);
    final bloc = context.read<TopUpBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: context.read<AppBloc>().deleteAll,
          )
        ],
      ),
      floatingActionButton: AddBeneficiaryActionButton(
        onPressed: () => _showAddBeneficiaryBottomSheet(context),
      ),
      body: MultiBlocListener(
        listeners: [
          TopUpStatusListener(),
          AppStatusListener(onRestarted: () {
            bloc.add(const LoadBeneficiaries());
            bloc.add(const LoadTransactions());
            bloc.add(const LoadUserBalance());
          }),
        ],
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hello ${user.name}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      BlocSelector<TopUpBloc, TopUpState, double>(
                          selector: (state) => state.userBalance,
                          builder: (context, balance) {
                            return Text(
                              'Totat Balance: AED ${balance.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          }),
                      const SizedBox(width: 6),
                      const AddBalanceButton()
                    ],
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 8.0;
                      final cardWidth = _calculateCardWidth(
                        maxWidth: constraints.maxWidth,
                        cardMaxWidth: 200.0,
                        spacing: spacing,
                      );

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: BlocSelector<TopUpBloc, TopUpState, List<Beneficiary>>(
                          selector: (state) => state.beneficiaries,
                          builder: (context, beneficiaries) => beneficiaries.isNotEmpty
                              ? Row(
                                  children: beneficiaries
                                      .map(
                                        (e) => Container(
                                          margin: const EdgeInsets.only(right: spacing),
                                          child: BeneficiaryCard(
                                            name: e.nickname,
                                            phone: e.phoneNumber,
                                            width: cardWidth,
                                            onPressed: () => _showTopUpOptionsBottomSheet(context, e),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : const Text('There are no beneficiaries yet. Add one to start topping up!'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  const Text('Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Expanded(
                    child: BlocSelector<TopUpBloc, TopUpState, List<Transaction>>(
                      selector: (state) => state.transactions,
                      builder: (context, transactions) => transactions.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemCount: transactions.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (_, index) {
                                final transaction = transactions[index];
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(transaction.beneficiaryName),
                                      Text(
                                        '${transaction.currency} ${transaction.amount}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text('fee ${transaction.cost} | ${transaction.date.split('T').first}'),
                                );
                              },
                            )
                          : const Text('There are no transactions yet'),
                    ),
                  ),
                ],
              ),
            ),
            BlocSelector<TopUpBloc, TopUpState, TopUpStatus>(
              selector: (state) => state.status,
              builder: (context, status) {
                return status.isLoading
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  double _calculateCardWidth({
    required double maxWidth,
    required double cardMaxWidth,
    double spacing = 8.0,
  }) {
    const cardMaxWidth = 200.0;

    // Calculate minimum required width for two full cards and 20% of the third
    final minimumNeededWidth = cardMaxWidth * 2 + cardMaxWidth * 0.2 + spacing * 2;

    // Calculate the amount to reduce card width if maxWidth is insufficient
    final cardWidthReduction = max(0.0, minimumNeededWidth - maxWidth);

    // Corrected calculation for card width, ensuring it doesn't fall below 0
    final adjustedCardWidth = max(cardMaxWidth - (cardWidthReduction / 2.2), 0.0);

    return adjustedCardWidth;
  }

  void _showAddBeneficiaryBottomSheet(BuildContext context) {
    final topUpBloc = context.read<TopUpBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddBeneficiaryBottomSheet(
        onAddBeneficiary: (name, phone) {
          topUpBloc.add(
            AddBeneficiary(
              beneficiary: Beneficiary(
                id: const Uuid().v4(),
                nickname: name,
                phoneNumber: phone,
                balance: 0.0,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTopUpOptionsBottomSheet(BuildContext context, Beneficiary beneficiary) {
    final topUpBloc = context.read<TopUpBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TopUpOptionsBottomSheet(
        onTopUpOptionSelected: (amount) {
          topUpBloc.add(
            TopUpBeneficiary(
              beneficiary: beneficiary,
              amount: amount.toDouble(),
            ),
          );
        },
      ),
    );
  }
}
