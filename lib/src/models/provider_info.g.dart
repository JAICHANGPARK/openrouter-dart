// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvidersResponse _$ProvidersResponseFromJson(Map<String, dynamic> json) =>
    ProvidersResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProviderInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProvidersResponseToJson(ProvidersResponse instance) =>
    <String, dynamic>{'data': instance.data};

ProviderInfo _$ProviderInfoFromJson(Map<String, dynamic> json) => ProviderInfo(
  name: json['name'] as String,
  slug: json['slug'] as String,
  privacyPolicyUrl: json['privacy_policy_url'] as String?,
  termsOfServiceUrl: json['terms_of_service_url'] as String?,
  statusPageUrl: json['status_page_url'] as String?,
);

Map<String, dynamic> _$ProviderInfoToJson(ProviderInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'privacy_policy_url': instance.privacyPolicyUrl,
      'terms_of_service_url': instance.termsOfServiceUrl,
      'status_page_url': instance.statusPageUrl,
    };
