import 'package:uuid/uuid.dart';
import 'package:uuid_service/src/uuid_service.dart';

class ConcreteUuidService implements UuidService {
  final uuid = const Uuid();

  @override
  String v4() {
    return const Uuid().v4();
  }
}
