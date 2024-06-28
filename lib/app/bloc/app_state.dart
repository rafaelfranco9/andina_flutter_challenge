import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final Flavor flavor;
  final User? user;
  final bool isAuthenticated;

  const AppState({required this.flavor, this.isAuthenticated = false, this.user});

  AppState copyWith({bool? isAuthenticated, User? user}) {
    return AppState(
      flavor: flavor,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [flavor, user, isAuthenticated];
}
