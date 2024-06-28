import 'package:andina_flutter_challenge/app/bloc/app_state.dart';
import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc({required Flavor flavor, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AppState(flavor: flavor));

  final AuthRepository _authRepository;

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final user = await _authRepository.login('', '');
      emit(state.copyWith(isAuthenticated: true, user: user, status: AppStatus.authenticated));
    } catch (e) {
      emit(state.copyWith(isAuthenticated: false, status: AppStatus.unauthenticated));
    }
  }
}
