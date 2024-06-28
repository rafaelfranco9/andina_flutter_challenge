import 'package:andina_flutter_challenge/app/view/app_view.dart';
import 'package:andina_flutter_challenge/main/bootstrap.dart';
import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:auth_repository/auth_repository.dart';

void main() {
  bootstrap(() async {
    return AppView(
      flavor: Flavor.dev,
      authRepository: AuthLocalRepository(),
    );
  });
}
