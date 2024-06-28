import 'package:freezed_annotation/freezed_annotation.dart';

part 'beneficiary.freezed.dart';
part 'beneficiary.g.dart';

@freezed
abstract class Beneficiary with _$Beneficiary {
  const factory Beneficiary({
    required String id,
    required String nickname,
    required String phoneNumber,
  }) = _Beneficiary;

  factory Beneficiary.fromJson(Map<String, dynamic> json) => _$BeneficiaryFromJson(json);

  /// Returns an empty [Beneficiary].
  static const empty = Beneficiary(
    id: '',
    nickname: '',
    phoneNumber: '',
  );
}
