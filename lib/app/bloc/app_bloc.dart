import 'package:andina_flutter_challenge/app/bloc/app_state.dart';
import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc({required Flavor flavor}) : super(AppState(flavor: flavor));
}
