// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embeddings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmbeddingsRequest _$EmbeddingsRequestFromJson(Map<String, dynamic> json) =>
    EmbeddingsRequest(
      input: json['input'],
      model: json['model'] as String,
      encodingFormat: json['encoding_format'] as String?,
      dimensions: (json['dimensions'] as num?)?.toInt(),
      user: json['user'] as String?,
      provider: json['provider'] == null
          ? null
          : ProviderPreferences.fromJson(
              json['provider'] as Map<String, dynamic>,
            ),
      inputType: json['input_type'] as String?,
    );

Map<String, dynamic> _$EmbeddingsRequestToJson(EmbeddingsRequest instance) =>
    <String, dynamic>{
      'input': instance.input,
      'model': instance.model,
      'encoding_format': instance.encodingFormat,
      'dimensions': instance.dimensions,
      'user': instance.user,
      'provider': instance.provider,
      'input_type': instance.inputType,
    };

EmbeddingsResponse _$EmbeddingsResponseFromJson(Map<String, dynamic> json) =>
    EmbeddingsResponse(
      id: json['id'] as String?,
      object: json['object'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => EmbeddingData.fromJson(e as Map<String, dynamic>))
          .toList(),
      model: json['model'] as String,
      usage: EmbeddingsUsage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmbeddingsResponseToJson(EmbeddingsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'data': instance.data,
      'model': instance.model,
      'usage': instance.usage,
    };

EmbeddingData _$EmbeddingDataFromJson(Map<String, dynamic> json) =>
    EmbeddingData(
      object: json['object'] as String,
      embedding: json['embedding'],
      index: (json['index'] as num).toDouble(),
    );

Map<String, dynamic> _$EmbeddingDataToJson(EmbeddingData instance) =>
    <String, dynamic>{
      'object': instance.object,
      'embedding': instance.embedding,
      'index': instance.index,
    };

EmbeddingsUsage _$EmbeddingsUsageFromJson(Map<String, dynamic> json) =>
    EmbeddingsUsage(
      promptTokens: (json['prompt_tokens'] as num).toDouble(),
      totalTokens: (json['total_tokens'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$EmbeddingsUsageToJson(EmbeddingsUsage instance) =>
    <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'total_tokens': instance.totalTokens,
      'cost': instance.cost,
    };
