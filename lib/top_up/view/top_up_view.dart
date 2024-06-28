import 'dart:math';

import 'package:andina_flutter_challenge/app/bloc/app_bloc.dart';
import 'package:andina_flutter_challenge/top_up/widgets/beneficiary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopUpView extends StatelessWidget {
  const TopUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user != null ? 'Hello ${user.name}' : 'Hello',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: Row(
                    children: [
                      BeneficiaryCard(width: cardWidth),
                      const SizedBox(width: spacing),
                      BeneficiaryCard(width: cardWidth),
                      const SizedBox(width: spacing),
                      BeneficiaryCard(width: cardWidth),
                      const SizedBox(width: spacing),
                      BeneficiaryCard(width: cardWidth),
                    ],
                  ),
                );
              },
            )
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
}
