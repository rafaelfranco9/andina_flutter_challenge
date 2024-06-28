import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:api_client/src/resources/beneficiaries/beneficiaries.dart';
import 'package:app_http_client/app_http_client.dart';

class BeneficiariesResource {
  BeneficiariesResource({required AppHttpClient appHttpClient}) : _appHttpClient = appHttpClient;

  final AppHttpClient _appHttpClient;

  static const _path = 'v1/beneficiaries';

  Future<List<Beneficiary>> fetchBeneficiariesByUserId(String userId) async {
    final data = await _appHttpClient.get('$_path/$userId');

    if (data == null) {
      return [];
    } else {
      final parsedJson = jsonDecode(data) as List<dynamic>;
      return parsedJson.map((e) => Beneficiary.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  Future<void> addBeneficiary({required String userId, required Beneficiary beneficiary}) async {
    await _appHttpClient.put('$_path/${userId}', [beneficiary.toJson()]);
  }

  Future<void> deleteBeneficiary({required String userId, required String beneficiaryId}) async {
    final beneficiaries = await fetchBeneficiariesByUserId(userId);
    final updatedBeneficiaries = beneficiaries.where((b) => b.id != beneficiaryId).toList();
    await _appHttpClient.post('$_path/${userId}', updatedBeneficiaries.map((e) => e.toJson()).toList());
  }
}
