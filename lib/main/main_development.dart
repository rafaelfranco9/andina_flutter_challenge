import 'package:andina_flutter_challenge/app/view/app_view.dart';
import 'package:andina_flutter_challenge/main/bootstrap.dart';
import 'package:andina_flutter_challenge/main/flavors.dart';

void main() {
  bootstrap(() async {
    return const AppView(flavor: Flavor.dev);
  });
}
