import 'package:andina_flutter_challenge/top_up/bloc/top_up_bloc.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBalanceButton extends StatelessWidget {
  const AddBalanceButton({super.key, this.amount = 100});
  final double amount;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
      ),
      onPressed: () {
        context.read<TopUpBloc>().add(AddCredit(amount));
      },
      child: Row(
        children: [
          Text(amount.toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Icon(Icons.add, color: Colors.white),
        ],
      ),
    );
  }
}
