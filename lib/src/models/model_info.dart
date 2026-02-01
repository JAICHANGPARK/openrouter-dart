import 'package:json_annotation/json_annotation.dart';

part 'model_info.g.dart';

/// Response from listing models.
@JsonSerializable()
class ModelsResponse {
  const ModelsResponse({required this.data});

  /// List of available models.
  final List<ModelInfo> data;

  factory ModelsResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModelsResponseToJson(this);
}

/// Model information.
@JsonSerializable()
class ModelInfo {
  const ModelInfo({
    required this.id,
    required this.canonicalSlug,
    this.huggingFaceId,
    required this.name,
    required this.created,
    required this.description,
    required this.pricing,
    this.contextLength,
    required this.architecture,
    required this.topProvider,
    required this.perRequestLimits,
    required this.supportedParameters,
    required this.defaultParameters,
    this.expirationDate,
  });

  /// Unique model identifier.
  final String id;

  /// Permanent slug that never changes.
  @JsonKey(name: 'canonical_slug')
  final String canonicalSlug;

  /// Hugging Face model ID if applicable.
  @JsonKey(name: 'hugging_face_id')
  final String? huggingFaceId;

  /// Human-readable display name.
  final String name;

  /// Unix timestamp when model was added.
  final double created;

  /// Model description.
  final String description;

  /// Pricing information.
  final Pricing pricing;

  /// Maximum context length in tokens.
  @JsonKey(name: 'context_length')
  final double? contextLength;

  /// Architecture details.
  final Architecture architecture;

  /// Top provider information.
  @JsonKey(name: 'top_provider')
  final TopProvider topProvider;

  /// Per-request limits.
  @JsonKey(name: 'per_request_limits')
  final PerRequestLimits perRequestLimits;

  /// List of supported parameters.
  @JsonKey(name: 'supported_parameters')
  final List<String> supportedParameters;

  /// Default parameter values.
  @JsonKey(name: 'default_parameters')
  final DefaultParameters defaultParameters;

  /// Expiration date (ISO 8601 format).
  @JsonKey(name: 'expiration_date')
  final String? expirationDate;

  factory ModelInfo.fromJson(Map<String, dynamic> json) =>
      _$ModelInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ModelInfoToJson(this);
}

/// Pricing information.
@JsonSerializable()
class Pricing {
  const Pricing({
    required this.prompt,
    required this.completion,
    this.request,
    this.image,
    this.imageToken,
    this.imageOutput,
    this.audio,
    this.audioOutput,
    this.inputAudioCache,
    this.webSearch,
    this.internalReasoning,
    this.inputCacheRead,
    this.inputCacheWrite,
    this.discount,
  });

  /// Cost per prompt token.
  final dynamic prompt;

  /// Cost per completion token.
  final dynamic completion;

  /// Cost per request.
  final dynamic request;

  /// Cost per image.
  final dynamic image;

  /// Cost per image token.
  @JsonKey(name: 'image_token')
  final dynamic imageToken;

  /// Cost per image output.
  @JsonKey(name: 'image_output')
  final dynamic imageOutput;

  /// Cost per audio token.
  final dynamic audio;

  /// Cost per audio output.
  @JsonKey(name: 'audio_output')
  final dynamic audioOutput;

  /// Cost for input audio cache.
  @JsonKey(name: 'input_audio_cache')
  final dynamic inputAudioCache;

  /// Cost per web search.
  @JsonKey(name: 'web_search')
  final dynamic webSearch;

  /// Cost for internal reasoning.
  @JsonKey(name: 'internal_reasoning')
  final dynamic internalReasoning;

  /// Cost for cache read.
  @JsonKey(name: 'input_cache_read')
  final dynamic inputCacheRead;

  /// Cost for cache write.
  @JsonKey(name: 'input_cache_write')
  final dynamic inputCacheWrite;

  /// Discount percentage.
  final double? discount;

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);

  Map<String, dynamic> toJson() => _$PricingToJson(this);
}

/// Architecture details.
@JsonSerializable()
class Architecture {
  const Architecture({
    required this.tokenizer,
    this.instructType,
    this.modality,
    required this.inputModalities,
    required this.outputModalities,
  });

  /// Tokenizer type.
  final String tokenizer;

  /// Instruction format type.
  @JsonKey(name: 'instruct_type')
  final String? instructType;

  /// Primary modality.
  final String? modality;

  /// Supported input modalities.
  @JsonKey(name: 'input_modalities')
  final List<String> inputModalities;

  /// Supported output modalities.
  @JsonKey(name: 'output_modalities')
  final List<String> outputModalities;

  factory Architecture.fromJson(Map<String, dynamic> json) =>
      _$ArchitectureFromJson(json);

  Map<String, dynamic> toJson() => _$ArchitectureToJson(this);
}

/// Top provider information.
@JsonSerializable()
class TopProvider {
  const TopProvider({
    this.contextLength,
    this.maxCompletionTokens,
    required this.isModerated,
  });

  /// Provider-specific context limit.
  @JsonKey(name: 'context_length')
  final double? contextLength;

  /// Maximum completion tokens.
  @JsonKey(name: 'max_completion_tokens')
  final double? maxCompletionTokens;

  /// Whether content is moderated.
  @JsonKey(name: 'is_moderated')
  final bool isModerated;

  factory TopProvider.fromJson(Map<String, dynamic> json) =>
      _$TopProviderFromJson(json);

  Map<String, dynamic> toJson() => _$TopProviderToJson(this);
}

/// Per-request limits.
@JsonSerializable()
class PerRequestLimits {
  const PerRequestLimits({
    required this.promptTokens,
    required this.completionTokens,
  });

  /// Maximum prompt tokens.
  @JsonKey(name: 'prompt_tokens')
  final double promptTokens;

  /// Maximum completion tokens.
  @JsonKey(name: 'completion_tokens')
  final double completionTokens;

  factory PerRequestLimits.fromJson(Map<String, dynamic> json) =>
      _$PerRequestLimitsFromJson(json);

  Map<String, dynamic> toJson() => _$PerRequestLimitsToJson(this);
}

/// Default parameters.
@JsonSerializable()
class DefaultParameters {
  const DefaultParameters({this.temperature, this.topP, this.frequencyPenalty});

  /// Default temperature.
  final double? temperature;

  /// Default top_p.
  @JsonKey(name: 'top_p')
  final double? topP;

  /// Default frequency penalty.
  @JsonKey(name: 'frequency_penalty')
  final double? frequencyPenalty;

  factory DefaultParameters.fromJson(Map<String, dynamic> json) =>
      _$DefaultParametersFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultParametersToJson(this);
}

/// Model count response.
@JsonSerializable()
class ModelsCountResponse {
  const ModelsCountResponse({required this.data});

  /// Count data.
  final ModelsCountData data;

  factory ModelsCountResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelsCountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModelsCountResponseToJson(this);
}

/// Models count data.
@JsonSerializable()
class ModelsCountData {
  const ModelsCountData({required this.count});

  /// Total number of models.
  final double count;

  factory ModelsCountData.fromJson(Map<String, dynamic> json) =>
      _$ModelsCountDataFromJson(json);

  Map<String, dynamic> toJson() => _$ModelsCountDataToJson(this);
}
