import 'package:api_client/api_client.dart';
import 'package:app_http_client/app_http_client.dart';
import 'package:beneficiaries_repository/beneficiaries_repository.dart';

class BeneficiariesLocalRepository implements BeneficiariesRepository {
  BeneficiariesLocalRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(appHttpClient: HttpClientLocal());

  final ApiClient _apiClient;

  @override
  Future<void> addBeneficiary(String userId, Beneficiary beneficiary) async {
    await _apiClient.beneficiariesResource.addBeneficiary(
      userId: userId,
      beneficiary: beneficiary,
    );
  }

  @override
  Future<List<Beneficiary>> getUserBeneficiaries(String userId) async {
    return _apiClient.beneficiariesResource.fetchBeneficiariesByUserId(userId);
  }

  @override
  Future<void> deleteBeneficiary(String userId, String beneficiaryId) {
    return _apiClient.beneficiariesResource.deleteBeneficiary(userId: userId, beneficiaryId: beneficiaryId);
  }
}
