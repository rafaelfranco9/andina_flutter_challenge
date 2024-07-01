import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/main/main.dart';
import 'package:andina_flutter_challenge/top_up/view/top_up_page.dart';
import 'package:andina_flutter_challenge/welcome/view/welcome_page.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid_service/uuid_service.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
    required this.flavor,
    required AuthRepository authRepository,
    required BeneficiariesRepository beneficiariesRepository,
    required UserRepository userRepository,
    required TransactionsRepository transactionsRepository,
    required UuidService uuidService,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _transactionsRepository = transactionsRepository,
        _beneficiariesRepository = beneficiariesRepository,
        _uuidService = uuidService;

  final Flavor flavor;
  final AuthRepository _authRepository;
  final BeneficiariesRepository _beneficiariesRepository;
  final UserRepository _userRepository;
  final TransactionsRepository _transactionsRepository;
  final UuidService _uuidService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<BeneficiariesRepository>.value(value: _beneficiariesRepository),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
        RepositoryProvider<TransactionsRepository>.value(value: _transactionsRepository),
        RepositoryProvider<UuidService>.value(value: _uuidService),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(
          flavor: flavor,
          authRepository: _authRepository,
          flutterSecureStorage: const FlutterSecureStorage(),
        )..init(),
        child: MaterialApp(
          title: 'Andina Challenge',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: BlocBuilder<AppBloc, AppState>(
            buildWhen: (prev, current) => prev.isAuthenticated != current.isAuthenticated,
            builder: (context, state) {
              return state.isAuthenticated ? const TopUpPage() : const WelcomePage();
            },
          ),
        ),
      ),
    );
  }
}
