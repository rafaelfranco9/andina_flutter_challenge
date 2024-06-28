import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/main/main.dart';
import 'package:andina_flutter_challenge/top_up/view/top_up_page.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
    required this.flavor,
    required AuthRepository authRepository,
    required BeneficiariesRepository beneficiariesRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _beneficiariesRepository = beneficiariesRepository;

  final Flavor flavor;
  final AuthRepository _authRepository;
  final BeneficiariesRepository _beneficiariesRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<BeneficiariesRepository>.value(value: _beneficiariesRepository),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(
          flavor: flavor,
          authRepository: _authRepository,
        )..init(),
        child: MaterialApp(
          title: 'Edenred Challenge',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TopUpPage(),
        ),
      ),
    );
  }
}
