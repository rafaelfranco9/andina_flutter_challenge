import 'package:api_client/api_client.dart';

abstract class BeneficiariesRepository {
  Future<List<Beneficiary>> getUserBeneficiaries(String userId);

  Future<void> addBeneficiary(String userId, Beneficiary beneficiary);

  Future<void> updateBeneficiary(String userId, Beneficiary beneficiary);
  Future<void> deleteBeneficiary(String userId, String beneficiaryId);
}
