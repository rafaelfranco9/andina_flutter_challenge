import 'package:andina_flutter_challenge/app/view/app_view.dart';
import 'package:andina_flutter_challenge/main/bootstrap.dart';
import 'package:andina_flutter_challenge/main/flavors.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(() async {
    return AppView(
      flavor: Flavor.prod,
      authRepository: AuthLocalRepository(),
      beneficiariesRepository: BeneficiariesLocalRepository(),
      userRepository: UserLocalRepository(),
      transactionsRepository: TransactionsLocalRepository(),
    );
  });
}
