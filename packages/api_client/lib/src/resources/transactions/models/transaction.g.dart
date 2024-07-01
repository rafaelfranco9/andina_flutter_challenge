// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      id: json['id'] as String,
      userId: json['userId'] as String,
      beneficiaryId: json['beneficiaryId'] as String,
      beneficiaryName: json['beneficiaryName'] as String,
      amount: (json['amount'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      currency: json['currency'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'id': instance.id,
      'userId': instance.userId,
      'beneficiaryId': instance.beneficiaryId,
      'beneficiaryName': instance.beneficiaryName,
      'amount': instance.amount,
      'cost': instance.cost,
      'currency': instance.currency,
      'date': instance.date,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.topUp: 'topUp',
  TransactionType.unknown: 'unknown',
};
