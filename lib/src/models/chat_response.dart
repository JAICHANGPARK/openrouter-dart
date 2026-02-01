import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'chat_response.g.dart';

/// Chat completion response.
@JsonSerializable()
class ChatResponse {
  const ChatResponse({
    required this.id,
    required this.choices,
    required this.created,
    required this.model,
    required this.object,
    this.systemFingerprint,
    this.usage,
    this.provider,
    this.debug,
  });

  /// Unique identifier for the completion.
  final String id;

  /// List of completion choices.
  final List<ChatChoice> choices;

  /// Unix timestamp of when the completion was created.
  final double created;

  /// Model used for the completion.
  final String model;

  /// Object type (always 'chat.completion').
  final String object;

  /// System fingerprint.
  @JsonKey(name: 'system_fingerprint')
  final String? systemFingerprint;

  /// Token usage information.
  final TokenUsage? usage;

  /// Provider that served the request.
  final String? provider;

  /// Debug information.
  final DebugResponse? debug;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);

  /// Get the first choice's message content.
  String? get content => choices.isNotEmpty
      ? choices.first.message?.content ?? choices.first.delta?.content
      : null;

  /// Get the first choice's message.
  Message? get message => choices.isNotEmpty ? choices.first.message : null;
}

/// Chat completion choice.
@JsonSerializable()
class ChatChoice {
  const ChatChoice({
    required this.finishReason,
    required this.index,
    this.message,
    this.delta,
    this.logprobs,
    this.error,
    this.nativeFinishReason,
  });

  /// The reason the completion finished.
  @JsonKey(name: 'finish_reason')
  final String? finishReason;

  /// Index of the choice.
  final double index;

  /// The message content (for non-streaming).
  final Message? message;

  /// The delta content (for streaming).
  final DeltaMessage? delta;

  /// Log probabilities.
  final Logprobs? logprobs;

  /// Error information.
  final ChoiceError? error;

  /// Native finish reason from the provider.
  @JsonKey(name: 'native_finish_reason')
  final String? nativeFinishReason;

  factory ChatChoice.fromJson(Map<String, dynamic> json) =>
      _$ChatChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ChatChoiceToJson(this);
}

/// Delta message for streaming.
@JsonSerializable()
class DeltaMessage {
  const DeltaMessage({this.content, this.role, this.toolCalls});

  /// The content delta.
  final String? content;

  /// The role.
  final String? role;

  /// Tool calls.
  @JsonKey(name: 'tool_calls')
  final List<ToolCall>? toolCalls;

  factory DeltaMessage.fromJson(Map<String, dynamic> json) =>
      _$DeltaMessageFromJson(json);

  Map<String, dynamic> toJson() => _$DeltaMessageToJson(this);
}

/// Token usage information.
@JsonSerializable()
class TokenUsage {
  const TokenUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    this.promptTokensDetails,
    this.completionTokensDetails,
    this.cost,
    this.isByok,
    this.costDetails,
  });

  /// Number of tokens in the prompt.
  @JsonKey(name: 'prompt_tokens')
  final double promptTokens;

  /// Number of tokens in the completion.
  @JsonKey(name: 'completion_tokens')
  final double completionTokens;

  /// Total number of tokens.
  @JsonKey(name: 'total_tokens')
  final double totalTokens;

  /// Detailed prompt token information.
  @JsonKey(name: 'prompt_tokens_details')
  final PromptTokensDetails? promptTokensDetails;

  /// Detailed completion token information.
  @JsonKey(name: 'completion_tokens_details')
  final CompletionTokensDetails? completionTokensDetails;

  /// Cost of the request in credits.
  final double? cost;

  /// Whether BYOK was used.
  @JsonKey(name: 'is_byok')
  final bool? isByok;

  /// Detailed cost breakdown.
  @JsonKey(name: 'cost_details')
  final CostDetails? costDetails;

  factory TokenUsage.fromJson(Map<String, dynamic> json) =>
      _$TokenUsageFromJson(json);

  Map<String, dynamic> toJson() => _$TokenUsageToJson(this);
}

/// Prompt token details.
@JsonSerializable()
class PromptTokensDetails {
  const PromptTokensDetails({
    required this.cachedTokens,
    this.cacheWriteTokens,
    this.audioTokens,
    this.videoTokens,
  });

  /// Number of cached tokens.
  @JsonKey(name: 'cached_tokens')
  final double cachedTokens;

  /// Number of cache write tokens.
  @JsonKey(name: 'cache_write_tokens')
  final double? cacheWriteTokens;

  /// Number of audio tokens.
  @JsonKey(name: 'audio_tokens')
  final double? audioTokens;

  /// Number of video tokens.
  @JsonKey(name: 'video_tokens')
  final double? videoTokens;

  factory PromptTokensDetails.fromJson(Map<String, dynamic> json) =>
      _$PromptTokensDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PromptTokensDetailsToJson(this);
}

/// Completion token details.
@JsonSerializable()
class CompletionTokensDetails {
  const CompletionTokensDetails({
    this.reasoningTokens,
    this.imageTokens,
    this.acceptedPredictionTokens,
    this.rejectedPredictionTokens,
  });

  /// Number of reasoning tokens.
  @JsonKey(name: 'reasoning_tokens')
  final double? reasoningTokens;

  /// Number of image tokens.
  @JsonKey(name: 'image_tokens')
  final double? imageTokens;

  /// Accepted prediction tokens.
  @JsonKey(name: 'accepted_prediction_tokens')
  final double? acceptedPredictionTokens;

  /// Rejected prediction tokens.
  @JsonKey(name: 'rejected_prediction_tokens')
  final double? rejectedPredictionTokens;

  factory CompletionTokensDetails.fromJson(Map<String, dynamic> json) =>
      _$CompletionTokensDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CompletionTokensDetailsToJson(this);
}

/// Cost details.
@JsonSerializable()
class CostDetails {
  const CostDetails({
    this.upstreamInferenceCost,
    required this.upstreamInferencePromptCost,
    required this.upstreamInferenceCompletionsCost,
  });

  /// Upstream inference cost.
  @JsonKey(name: 'upstream_inference_cost')
  final double? upstreamInferenceCost;

  /// Upstream prompt cost.
  @JsonKey(name: 'upstream_inference_prompt_cost')
  final double upstreamInferencePromptCost;

  /// Upstream completions cost.
  @JsonKey(name: 'upstream_inference_completions_cost')
  final double upstreamInferenceCompletionsCost;

  factory CostDetails.fromJson(Map<String, dynamic> json) =>
      _$CostDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CostDetailsToJson(this);
}

/// Log probabilities.
@JsonSerializable()
class Logprobs {
  const Logprobs({this.content, this.refusal});

  /// Content log probabilities.
  final List<TokenLogprob>? content;

  /// Refusal log probabilities.
  final List<TokenLogprob>? refusal;

  factory Logprobs.fromJson(Map<String, dynamic> json) =>
      _$LogprobsFromJson(json);

  Map<String, dynamic> toJson() => _$LogprobsToJson(this);
}

/// Token log probability.
@JsonSerializable()
class TokenLogprob {
  const TokenLogprob({
    required this.token,
    required this.logprob,
    this.bytes,
    required this.topLogprobs,
  });

  /// The token.
  final String token;

  /// The log probability.
  final double logprob;

  /// Byte representation.
  final List<double>? bytes;

  /// Top log probabilities.
  @JsonKey(name: 'top_logprobs')
  final List<TopLogprob> topLogprobs;

  factory TokenLogprob.fromJson(Map<String, dynamic> json) =>
      _$TokenLogprobFromJson(json);

  Map<String, dynamic> toJson() => _$TokenLogprobToJson(this);
}

/// Top log probability.
@JsonSerializable()
class TopLogprob {
  const TopLogprob({required this.token, required this.logprob, this.bytes});

  /// The token.
  final String token;

  /// The log probability.
  final double logprob;

  /// Byte representation.
  final List<double>? bytes;

  factory TopLogprob.fromJson(Map<String, dynamic> json) =>
      _$TopLogprobFromJson(json);

  Map<String, dynamic> toJson() => _$TopLogprobToJson(this);
}

/// Choice error.
@JsonSerializable()
class ChoiceError {
  const ChoiceError({required this.code, required this.message, this.metadata});

  /// Error code.
  final dynamic code;

  /// Error message.
  final String message;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

  factory ChoiceError.fromJson(Map<String, dynamic> json) =>
      _$ChoiceErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceErrorToJson(this);
}

/// Debug response information.
@JsonSerializable()
class DebugResponse {
  const DebugResponse({this.echoUpstreamBody});

  /// Echo of the upstream request body.
  @JsonKey(name: 'echo_upstream_body')
  final Map<String, dynamic>? echoUpstreamBody;

  factory DebugResponse.fromJson(Map<String, dynamic> json) =>
      _$DebugResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DebugResponseToJson(this);
}

/// Streaming chunk for SSE.
class StreamingChunk {
  const StreamingChunk({
    required this.id,
    required this.choices,
    required this.created,
    required this.model,
    required this.object,
    this.usage,
    this.error,
  });

  /// Unique identifier.
  final String id;

  /// List of choices (usually 1 in streaming).
  final List<ChatChoice> choices;

  /// Unix timestamp.
  final double created;

  /// Model used.
  final String model;

  /// Object type (always 'chat.completion.chunk').
  final String object;

  /// Usage information (only in final chunk).
  final TokenUsage? usage;

  /// Error information.
  final ChoiceError? error;

  factory StreamingChunk.fromJson(Map<String, dynamic> json) => StreamingChunk(
    id: json['id'] as String,
    choices: (json['choices'] as List<dynamic>)
        .map((e) => ChatChoice.fromJson(e as Map<String, dynamic>))
        .toList(),
    created: json['created'] as double,
    model: json['model'] as String,
    object: json['object'] as String,
    usage: json['usage'] != null
        ? TokenUsage.fromJson(json['usage'] as Map<String, dynamic>)
        : null,
    error: json['error'] != null
        ? ChoiceError.fromJson(json['error'] as Map<String, dynamic>)
        : null,
  );
}
