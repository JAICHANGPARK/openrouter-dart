// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelsResponse _$ModelsResponseFromJson(Map<String, dynamic> json) =>
    ModelsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ModelInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelsResponseToJson(ModelsResponse instance) =>
    <String, dynamic>{'data': instance.data};

ModelInfo _$ModelInfoFromJson(Map<String, dynamic> json) => ModelInfo(
  id: json['id'] as String,
  canonicalSlug: json['canonical_slug'] as String,
  huggingFaceId: json['hugging_face_id'] as String?,
  name: json['name'] as String,
  created: (json['created'] as num).toDouble(),
  description: json['description'] as String,
  pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
  contextLength: (json['context_length'] as num?)?.toDouble(),
  architecture: Architecture.fromJson(
    json['architecture'] as Map<String, dynamic>,
  ),
  topProvider: TopProvider.fromJson(
    json['top_provider'] as Map<String, dynamic>,
  ),
  perRequestLimits: PerRequestLimits.fromJson(
    json['per_request_limits'] as Map<String, dynamic>,
  ),
  supportedParameters: (json['supported_parameters'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  defaultParameters: DefaultParameters.fromJson(
    json['default_parameters'] as Map<String, dynamic>,
  ),
  expirationDate: json['expiration_date'] as String?,
);

Map<String, dynamic> _$ModelInfoToJson(ModelInfo instance) => <String, dynamic>{
  'id': instance.id,
  'canonical_slug': instance.canonicalSlug,
  'hugging_face_id': instance.huggingFaceId,
  'name': instance.name,
  'created': instance.created,
  'description': instance.description,
  'pricing': instance.pricing,
  'context_length': instance.contextLength,
  'architecture': instance.architecture,
  'top_provider': instance.topProvider,
  'per_request_limits': instance.perRequestLimits,
  'supported_parameters': instance.supportedParameters,
  'default_parameters': instance.defaultParameters,
  'expiration_date': instance.expirationDate,
};

Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing(
  prompt: json['prompt'],
  completion: json['completion'],
  request: json['request'],
  image: json['image'],
  imageToken: json['image_token'],
  imageOutput: json['image_output'],
  audio: json['audio'],
  audioOutput: json['audio_output'],
  inputAudioCache: json['input_audio_cache'],
  webSearch: json['web_search'],
  internalReasoning: json['internal_reasoning'],
  inputCacheRead: json['input_cache_read'],
  inputCacheWrite: json['input_cache_write'],
  discount: (json['discount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
  'prompt': instance.prompt,
  'completion': instance.completion,
  'request': instance.request,
  'image': instance.image,
  'image_token': instance.imageToken,
  'image_output': instance.imageOutput,
  'audio': instance.audio,
  'audio_output': instance.audioOutput,
  'input_audio_cache': instance.inputAudioCache,
  'web_search': instance.webSearch,
  'internal_reasoning': instance.internalReasoning,
  'input_cache_read': instance.inputCacheRead,
  'input_cache_write': instance.inputCacheWrite,
  'discount': instance.discount,
};

Architecture _$ArchitectureFromJson(Map<String, dynamic> json) => Architecture(
  tokenizer: json['tokenizer'] as String,
  instructType: json['instruct_type'] as String?,
  modality: json['modality'] as String?,
  inputModalities: (json['input_modalities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  outputModalities: (json['output_modalities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ArchitectureToJson(Architecture instance) =>
    <String, dynamic>{
      'tokenizer': instance.tokenizer,
      'instruct_type': instance.instructType,
      'modality': instance.modality,
      'input_modalities': instance.inputModalities,
      'output_modalities': instance.outputModalities,
    };

TopProvider _$TopProviderFromJson(Map<String, dynamic> json) => TopProvider(
  contextLength: (json['context_length'] as num?)?.toDouble(),
  maxCompletionTokens: (json['max_completion_tokens'] as num?)?.toDouble(),
  isModerated: json['is_moderated'] as bool,
);

Map<String, dynamic> _$TopProviderToJson(TopProvider instance) =>
    <String, dynamic>{
      'context_length': instance.contextLength,
      'max_completion_tokens': instance.maxCompletionTokens,
      'is_moderated': instance.isModerated,
    };

PerRequestLimits _$PerRequestLimitsFromJson(Map<String, dynamic> json) =>
    PerRequestLimits(
      promptTokens: (json['prompt_tokens'] as num).toDouble(),
      completionTokens: (json['completion_tokens'] as num).toDouble(),
    );

Map<String, dynamic> _$PerRequestLimitsToJson(PerRequestLimits instance) =>
    <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'completion_tokens': instance.completionTokens,
    };

DefaultParameters _$DefaultParametersFromJson(Map<String, dynamic> json) =>
    DefaultParameters(
      temperature: (json['temperature'] as num?)?.toDouble(),
      topP: (json['top_p'] as num?)?.toDouble(),
      frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DefaultParametersToJson(DefaultParameters instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'top_p': instance.topP,
      'frequency_penalty': instance.frequencyPenalty,
    };

ModelsCountResponse _$ModelsCountResponseFromJson(Map<String, dynamic> json) =>
    ModelsCountResponse(
      data: ModelsCountData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModelsCountResponseToJson(
  ModelsCountResponse instance,
) => <String, dynamic>{'data': instance.data};

ModelsCountData _$ModelsCountDataFromJson(Map<String, dynamic> json) =>
    ModelsCountData(count: (json['count'] as num).toDouble());

Map<String, dynamic> _$ModelsCountDataToJson(ModelsCountData instance) =>
    <String, dynamic>{'count': instance.count};
