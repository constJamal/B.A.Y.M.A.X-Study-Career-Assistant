// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      section: json['section'] as String?,
      major: json['major'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      knowledgeGraph: json['knowledgeGraph'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'section': instance.section,
      'major': instance.major,
      'createdAt': instance.createdAt.toIso8601String(),
      'knowledgeGraph': instance.knowledgeGraph,
    };
