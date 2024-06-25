import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final Flavor flavor;

  const AppState({required this.flavor});

  @override
  List<Object?> get props => [flavor];
}
