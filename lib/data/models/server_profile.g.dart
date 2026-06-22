// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerProfile _$ServerProfileFromJson(Map<String, dynamic> json) =>
    _ServerProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$ServerProfileToJson(_ServerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'token': instance.token,
    };
