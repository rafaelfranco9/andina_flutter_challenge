// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BeneficiaryImpl _$$BeneficiaryImplFromJson(Map<String, dynamic> json) =>
    _$BeneficiaryImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$BeneficiaryImplToJson(_$BeneficiaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'phoneNumber': instance.phoneNumber,
      'balance': instance.balance,
    };
