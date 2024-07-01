import 'package:andina_flutter_challenge/app/bloc/app_state.dart';
import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc({
    required Flavor flavor,
    required AuthRepository authRepository,
    required FlutterSecureStorage flutterSecureStorage,
  })  : _authRepository = authRepository,
        _storage = flutterSecureStorage,
        super(AppState(flavor: flavor));

  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final user = await _authRepository.login('', '');
      emit(state.copyWith(isAuthenticated: true, user: user, status: AppStatus.authenticated));
    } catch (e) {
      emit(state.copyWith(isAuthenticated: false, status: AppStatus.unauthenticated));
    }
  }

  Future<void> reloadUser() async {
    try {
      final user = await _authRepository.reload(state.user!.id);
      emit(state.copyWith(user: user));
    } catch (e) {
      emit(state.copyWith(isAuthenticated: false));
    }
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    await init();
    emit(state.copyWith(status: AppStatus.restarted));
  }
}
