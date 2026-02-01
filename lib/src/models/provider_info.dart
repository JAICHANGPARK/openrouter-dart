import 'package:json_annotation/json_annotation.dart';

part 'provider_info.g.dart';

/// Response from listing providers.
@JsonSerializable()
class ProvidersResponse {
  const ProvidersResponse({required this.data});

  /// List of available providers.
  final List<ProviderInfo> data;

  factory ProvidersResponse.fromJson(Map<String, dynamic> json) =>
      _$ProvidersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProvidersResponseToJson(this);
}

/// Provider information.
@JsonSerializable()
class ProviderInfo {
  const ProviderInfo({
    required this.name,
    required this.slug,
    this.privacyPolicyUrl,
    this.termsOfServiceUrl,
    this.statusPageUrl,
  });

  /// Display name of the provider.
  final String name;

  /// URL-friendly identifier.
  final String slug;

  /// Privacy policy URL.
  @JsonKey(name: 'privacy_policy_url')
  final String? privacyPolicyUrl;

  /// Terms of service URL.
  @JsonKey(name: 'terms_of_service_url')
  final String? termsOfServiceUrl;

  /// Status page URL.
  @JsonKey(name: 'status_page_url')
  final String? statusPageUrl;

  factory ProviderInfo.fromJson(Map<String, dynamic> json) =>
      _$ProviderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderInfoToJson(this);
}
