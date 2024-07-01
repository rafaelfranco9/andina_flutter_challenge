import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_bloc.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_event.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'top_up_view.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopUpBloc(
        appBloc: context.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
        beneficiariesRepository: context.read<BeneficiariesRepository>(),
        transactionsRepository: context.read<TransactionsRepository>(),
      )
        ..add(const LoadUserBalance())
        ..add(const LoadBeneficiaries())
        ..add(const LoadTransactions()),
      child: const TopUpView(),
    );
  }
}
