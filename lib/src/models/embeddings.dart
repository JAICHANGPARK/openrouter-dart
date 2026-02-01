import 'package:json_annotation/json_annotation.dart';

import 'chat_request.dart';

part 'embeddings.g.dart';

/// Embedding request.
@JsonSerializable()
class EmbeddingsRequest {
  const EmbeddingsRequest({
    required this.input,
    required this.model,
    this.encodingFormat,
    this.dimensions,
    this.user,
    this.provider,
    this.inputType,
  });

  /// Input text or array of texts to embed.
  final dynamic input;

  /// Model to use for embeddings.
  final String model;

  /// Encoding format ('float' or 'base64').
  @JsonKey(name: 'encoding_format')
  final String? encodingFormat;

  /// Number of dimensions to return.
  final int? dimensions;

  /// User identifier.
  final String? user;

  /// Provider preferences.
  final ProviderPreferences? provider;

  /// Type of input.
  @JsonKey(name: 'input_type')
  final String? inputType;

  factory EmbeddingsRequest.fromJson(Map<String, dynamic> json) =>
      _$EmbeddingsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddingsRequestToJson(this);
}

/// Embedding response.
@JsonSerializable()
class EmbeddingsResponse {
  const EmbeddingsResponse({
    this.id,
    required this.object,
    required this.data,
    required this.model,
    required this.usage,
  });

  /// Unique identifier.
  final String? id;

  /// Object type (always 'list').
  final String object;

  /// List of embedding data.
  final List<EmbeddingData> data;

  /// Model used.
  final String model;

  /// Token usage.
  final EmbeddingsUsage usage;

  factory EmbeddingsResponse.fromJson(Map<String, dynamic> json) =>
      _$EmbeddingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddingsResponseToJson(this);
}

/// Single embedding data.
@JsonSerializable()
class EmbeddingData {
  const EmbeddingData({
    required this.object,
    required this.embedding,
    required this.index,
  });

  /// Object type (always 'embedding').
  final String object;

  /// The embedding vector (List<double> or base64 String).
  final dynamic embedding;

  /// Index of this embedding in the list.
  final double index;

  factory EmbeddingData.fromJson(Map<String, dynamic> json) =>
      _$EmbeddingDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddingDataToJson(this);
}

/// Embeddings usage information.
@JsonSerializable()
class EmbeddingsUsage {
  const EmbeddingsUsage({
    required this.promptTokens,
    required this.totalTokens,
    required this.cost,
  });

  /// Number of tokens in the prompt.
  @JsonKey(name: 'prompt_tokens')
  final double promptTokens;

  /// Total number of tokens.
  @JsonKey(name: 'total_tokens')
  final double totalTokens;

  /// Cost of the request.
  final double cost;

  factory EmbeddingsUsage.fromJson(Map<String, dynamic> json) =>
      _$EmbeddingsUsageFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddingsUsageToJson(this);
}
