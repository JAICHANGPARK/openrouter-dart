import 'package:json_annotation/json_annotation.dart';

part 'responses_response.g.dart';

/// Response from the OpenRouter Responses API (Beta).
@JsonSerializable()
class ResponsesResponse {
  const ResponsesResponse({
    required this.id,
    required this.object,
    required this.createdAt,
    required this.model,
    required this.status,
    this.completedAt,
    required this.output,
    this.user,
    this.outputText,
    this.promptCacheKey,
    this.safetyIdentifier,
    this.error,
    this.incompleteDetails,
    this.usage,
    this.maxToolCalls,
    this.topLogprobs,
    this.maxOutputTokens,
    this.temperature,
    this.topP,
    this.presencePenalty,
    this.frequencyPenalty,
    this.instructions,
    this.metadata,
    this.tools,
    this.toolChoice,
    this.parallelToolCalls,
    this.prompt,
    this.background,
    this.previousResponseId,
    this.reasoning,
    this.serviceTier,
    this.store,
    this.truncation,
    this.text,
  });

  /// Response ID.
  final String id;

  /// Object type (always 'response').
  final String object;

  /// Unix timestamp of creation.
  @JsonKey(name: 'created_at')
  final double createdAt;

  /// Model used.
  final String model;

  /// Response status.
  final ResponseStatus status;

  /// Unix timestamp of completion.
  @JsonKey(name: 'completed_at')
  final double? completedAt;

  /// Output items.
  @JsonKey(toJson: _outputToJson, fromJson: _outputFromJson)
  final List<ResponsesOutputItem> output;

  /// User identifier.
  final String? user;

  /// Extracted text output.
  @JsonKey(name: 'output_text')
  final String? outputText;

  /// Prompt cache key.
  @JsonKey(name: 'prompt_cache_key')
  final String? promptCacheKey;

  /// Safety identifier.
  @JsonKey(name: 'safety_identifier')
  final String? safetyIdentifier;

  /// Error information if failed.
  final ResponseError? error;

  /// Details if incomplete.
  @JsonKey(name: 'incomplete_details')
  final IncompleteDetails? incompleteDetails;

  /// Token usage.
  final ResponsesUsage? usage;

  /// Maximum tool calls.
  @JsonKey(name: 'max_tool_calls')
  final double? maxToolCalls;

  /// Top logprobs.
  @JsonKey(name: 'top_logprobs')
  final double? topLogprobs;

  /// Maximum output tokens.
  @JsonKey(name: 'max_output_tokens')
  final double? maxOutputTokens;

  /// Temperature.
  final double? temperature;

  /// Top p.
  @JsonKey(name: 'top_p')
  final double? topP;

  /// Presence penalty.
  @JsonKey(name: 'presence_penalty')
  final double? presencePenalty;

  /// Frequency penalty.
  @JsonKey(name: 'frequency_penalty')
  final double? frequencyPenalty;

  /// Instructions used.
  final dynamic instructions;

  /// Metadata.
  final Map<String, String>? metadata;

  /// Tools available.
  final List<dynamic>? tools;

  /// Tool choice.
  @JsonKey(name: 'tool_choice')
  final dynamic toolChoice;

  /// Parallel tool calls setting.
  @JsonKey(name: 'parallel_tool_calls')
  final bool? parallelToolCalls;

  /// Prompt template.
  final dynamic prompt;

  /// Background processing.
  final bool? background;

  /// Previous response ID.
  @JsonKey(name: 'previous_response_id')
  final String? previousResponseId;

  /// Reasoning configuration.
  final dynamic reasoning;

  /// Service tier.
  @JsonKey(name: 'service_tier')
  final String? serviceTier;

  /// Store setting.
  final bool? store;

  /// Truncation strategy.
  final dynamic truncation;

  /// Text configuration.
  final dynamic text;

  factory ResponsesResponse.fromJson(Map<String, dynamic> json) =>
      _$ResponsesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesResponseToJson(this);

  /// Gets the assistant's message content.
  String? get messageContent {
    final message = output.whereType<OutputMessage>().firstOrNull;
    if (message == null) return null;

    final textContent = message.content.whereType<OutputText>().firstOrNull;
    return textContent?.text;
  }

  /// Gets all function calls from the output.
  List<OutputFunctionCall> get functionCalls {
    return output.whereType<OutputFunctionCall>().toList();
  }

  /// Gets reasoning if present.
  OutputReasoning? get reasoningOutput {
    return output.whereType<OutputReasoning>().firstOrNull;
  }
}

/// Response status.
@JsonEnum(valueField: 'value')
enum ResponseStatus {
  completed('completed'),
  incomplete('incomplete'),
  inProgress('in_progress'),
  failed('failed'),
  cancelled('cancelled'),
  queued('queued');

  const ResponseStatus(this.value);
  final String value;
}

/// Output item (can be message, reasoning, function call, etc.).
sealed class ResponsesOutputItem {
  const ResponsesOutputItem();
  String get type;
  Map<String, dynamic> toJson();
}

/// Output message from assistant.
@JsonSerializable()
class OutputMessage extends ResponsesOutputItem {
  const OutputMessage({
    required this.id,
    required this.role,
    required this.content,
    this.status,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'message';

  /// Message ID.
  final String id;

  /// Role (always assistant).
  final String role;

  /// Content parts.
  @JsonKey(toJson: _contentToJson, fromJson: _contentFromJson)
  final List<OutputContent> content;

  /// Status.
  final OutputStatus? status;

  factory OutputMessage.fromJson(Map<String, dynamic> json) =>
      _$OutputMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputMessageToJson(this);
}

/// Output status.
@JsonEnum(valueField: 'value')
enum OutputStatus {
  completed('completed'),
  incomplete('incomplete'),
  inProgress('in_progress');

  const OutputStatus(this.value);
  final String value;
}

/// Output content part.
sealed class OutputContent {
  const OutputContent();
  String get type;
  Map<String, dynamic> toJson();
}

/// Text output.
@JsonSerializable()
class OutputText extends OutputContent {
  const OutputText({required this.text, this.annotations, this.logprobs});

  @override
  @JsonKey(name: 'type')
  final String type = 'output_text';

  /// Text content.
  final String text;

  /// Annotations (citations, etc.).
  @JsonKey(toJson: _annotationsToJson, fromJson: _annotationsFromJson)
  final List<Annotation>? annotations;

  /// Log probabilities.
  final List<LogprobItem>? logprobs;

  factory OutputText.fromJson(Map<String, dynamic> json) =>
      _$OutputTextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputTextToJson(this);
}

/// Refusal output.
@JsonSerializable()
class OutputRefusal extends OutputContent {
  const OutputRefusal({required this.refusal});

  @override
  @JsonKey(name: 'type')
  final String type = 'refusal';

  /// Refusal reason.
  final String refusal;

  factory OutputRefusal.fromJson(Map<String, dynamic> json) =>
      _$OutputRefusalFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputRefusalToJson(this);
}

/// Annotation for citations.
sealed class Annotation {
  const Annotation();
  String get type;
  Map<String, dynamic> toJson();
}

/// URL citation annotation.
@JsonSerializable()
class UrlCitation extends Annotation {
  const UrlCitation({
    required this.url,
    required this.title,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'url_citation';

  /// URL.
  final String url;

  /// Title.
  final String title;

  /// Start index in text.
  @JsonKey(name: 'start_index')
  final double startIndex;

  /// End index in text.
  @JsonKey(name: 'end_index')
  final double endIndex;

  factory UrlCitation.fromJson(Map<String, dynamic> json) =>
      _$UrlCitationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UrlCitationToJson(this);
}

/// File citation annotation.
@JsonSerializable()
class FileCitation extends Annotation {
  const FileCitation({
    required this.fileId,
    required this.filename,
    required this.index,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'file_citation';

  /// File ID.
  @JsonKey(name: 'file_id')
  final String fileId;

  /// Filename.
  final String filename;

  /// Index.
  final double index;

  factory FileCitation.fromJson(Map<String, dynamic> json) =>
      _$FileCitationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FileCitationToJson(this);
}

/// File path annotation.
@JsonSerializable()
class FilePath extends Annotation {
  const FilePath({required this.fileId, required this.index});

  @override
  @JsonKey(name: 'type')
  final String type = 'file_path';

  /// File ID.
  @JsonKey(name: 'file_id')
  final String fileId;

  /// Index.
  final double index;

  factory FilePath.fromJson(Map<String, dynamic> json) =>
      _$FilePathFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FilePathToJson(this);
}

/// Logprob item.
@JsonSerializable()
class LogprobItem {
  const LogprobItem({
    required this.token,
    this.bytes,
    required this.logprob,
    required this.topLogprobs,
  });

  /// Token.
  final String token;

  /// Byte representation.
  final List<double>? bytes;

  /// Log probability.
  final double logprob;

  /// Top logprobs.
  @JsonKey(name: 'top_logprobs')
  final List<TopLogprob> topLogprobs;

  factory LogprobItem.fromJson(Map<String, dynamic> json) =>
      _$LogprobItemFromJson(json);

  Map<String, dynamic> toJson() => _$LogprobItemToJson(this);
}

/// Top logprob entry.
@JsonSerializable()
class TopLogprob {
  const TopLogprob({required this.token, this.bytes, required this.logprob});

  /// Token.
  final String token;

  /// Bytes.
  final List<double>? bytes;

  /// Log probability.
  final double logprob;

  factory TopLogprob.fromJson(Map<String, dynamic> json) =>
      _$TopLogprobFromJson(json);

  Map<String, dynamic> toJson() => _$TopLogprobToJson(this);
}

/// Reasoning output.
@JsonSerializable()
class OutputReasoning extends ResponsesOutputItem {
  const OutputReasoning({
    required this.id,
    this.content,
    this.summary,
    this.encryptedContent,
    this.status,
    this.signature,
    this.format,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'reasoning';

  /// Reasoning ID.
  final String id;

  /// Content items.
  final List<ReasoningContent>? content;

  /// Summary items.
  final List<ReasoningSummaryItem>? summary;

  /// Encrypted content.
  @JsonKey(name: 'encrypted_content')
  final String? encryptedContent;

  /// Status.
  final OutputStatus? status;

  /// Signature for verification.
  final String? signature;

  /// Format.
  final String? format;

  factory OutputReasoning.fromJson(Map<String, dynamic> json) =>
      _$OutputReasoningFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputReasoningToJson(this);
}

/// Reasoning content.
@JsonSerializable()
class ReasoningContent {
  const ReasoningContent({required this.text});

  final String type = 'reasoning_text';
  final String text;

  factory ReasoningContent.fromJson(Map<String, dynamic> json) =>
      _$ReasoningContentFromJson(json);

  Map<String, dynamic> toJson() => _$ReasoningContentToJson(this);
}

/// Reasoning summary item.
@JsonSerializable()
class ReasoningSummaryItem {
  const ReasoningSummaryItem({required this.text});

  final String type = 'summary_text';
  final String text;

  factory ReasoningSummaryItem.fromJson(Map<String, dynamic> json) =>
      _$ReasoningSummaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReasoningSummaryItemToJson(this);
}

/// Function call output.
@JsonSerializable()
class OutputFunctionCall extends ResponsesOutputItem {
  const OutputFunctionCall({
    required this.id,
    required this.name,
    required this.arguments,
    required this.callId,
    this.status,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'function_call';

  /// Call ID.
  final String id;

  /// Function name.
  final String name;

  /// Arguments (JSON string).
  final String arguments;

  /// Call ID for matching.
  @JsonKey(name: 'call_id')
  final String callId;

  /// Status.
  final OutputStatus? status;

  factory OutputFunctionCall.fromJson(Map<String, dynamic> json) =>
      _$OutputFunctionCallFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputFunctionCallToJson(this);
}

/// Web search call output.
@JsonSerializable()
class OutputWebSearchCall extends ResponsesOutputItem {
  const OutputWebSearchCall({required this.id, required this.status});

  @override
  @JsonKey(name: 'type')
  final String type = 'web_search_call';

  /// Call ID.
  final String id;

  /// Status.
  final WebSearchCallStatus status;

  factory OutputWebSearchCall.fromJson(Map<String, dynamic> json) =>
      _$OutputWebSearchCallFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputWebSearchCallToJson(this);
}

/// Web search call status.
@JsonEnum(valueField: 'value')
enum WebSearchCallStatus {
  completed('completed'),
  searching('searching'),
  inProgress('in_progress'),
  failed('failed');

  const WebSearchCallStatus(this.value);
  final String value;
}

/// File search call output.
@JsonSerializable()
class OutputFileSearchCall extends ResponsesOutputItem {
  const OutputFileSearchCall({
    required this.id,
    required this.queries,
    required this.status,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'file_search_call';

  /// Call ID.
  final String id;

  /// Search queries.
  final List<String> queries;

  /// Status.
  final WebSearchCallStatus status;

  factory OutputFileSearchCall.fromJson(Map<String, dynamic> json) =>
      _$OutputFileSearchCallFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputFileSearchCallToJson(this);
}

/// Image generation call output.
@JsonSerializable()
class OutputImageGenerationCall extends ResponsesOutputItem {
  const OutputImageGenerationCall({
    required this.id,
    this.result,
    required this.status,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'image_generation_call';

  /// Call ID.
  final String id;

  /// Result (image URL or data).
  final String? result;

  /// Status.
  final ImageGenerationStatus status;

  factory OutputImageGenerationCall.fromJson(Map<String, dynamic> json) =>
      _$OutputImageGenerationCallFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutputImageGenerationCallToJson(this);
}

/// Image generation status.
@JsonEnum(valueField: 'value')
enum ImageGenerationStatus {
  inProgress('in_progress'),
  completed('completed'),
  generating('generating'),
  failed('failed');

  const ImageGenerationStatus(this.value);
  final String value;
}

/// Response error.
@JsonSerializable()
class ResponseError {
  const ResponseError({required this.code, required this.message});

  /// Error code.
  final String code;

  /// Error message.
  final String message;

  factory ResponseError.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseErrorToJson(this);
}

/// Incomplete details.
@JsonSerializable()
class IncompleteDetails {
  const IncompleteDetails({required this.reason});

  /// Reason for incompleteness.
  final String reason;

  factory IncompleteDetails.fromJson(Map<String, dynamic> json) =>
      _$IncompleteDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$IncompleteDetailsToJson(this);
}

/// Token usage.
@JsonSerializable()
class ResponsesUsage {
  const ResponsesUsage({
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
    this.inputTokensDetails,
    this.outputTokensDetails,
    this.cost,
    this.isByok,
    this.costDetails,
  });

  /// Input tokens.
  @JsonKey(name: 'input_tokens')
  final double inputTokens;

  /// Output tokens.
  @JsonKey(name: 'output_tokens')
  final double outputTokens;

  /// Total tokens.
  @JsonKey(name: 'total_tokens')
  final double totalTokens;

  /// Input token details.
  @JsonKey(name: 'input_tokens_details')
  final InputTokensDetails? inputTokensDetails;

  /// Output token details.
  @JsonKey(name: 'output_tokens_details')
  final OutputTokensDetails? outputTokensDetails;

  /// Cost in credits.
  final double? cost;

  /// Whether BYOK was used.
  @JsonKey(name: 'is_byok')
  final bool? isByok;

  /// Detailed cost breakdown.
  @JsonKey(name: 'cost_details')
  final CostDetails? costDetails;

  factory ResponsesUsage.fromJson(Map<String, dynamic> json) =>
      _$ResponsesUsageFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesUsageToJson(this);
}

/// Input tokens details.
@JsonSerializable()
class InputTokensDetails {
  const InputTokensDetails({required this.cachedTokens});

  /// Cached tokens.
  @JsonKey(name: 'cached_tokens')
  final double cachedTokens;

  factory InputTokensDetails.fromJson(Map<String, dynamic> json) =>
      _$InputTokensDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$InputTokensDetailsToJson(this);
}

/// Output tokens details.
@JsonSerializable()
class OutputTokensDetails {
  const OutputTokensDetails({this.reasoningTokens});

  /// Reasoning tokens.
  @JsonKey(name: 'reasoning_tokens')
  final double? reasoningTokens;

  factory OutputTokensDetails.fromJson(Map<String, dynamic> json) =>
      _$OutputTokensDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OutputTokensDetailsToJson(this);
}

/// Cost details.
@JsonSerializable()
class CostDetails {
  const CostDetails({
    this.upstreamInferenceCost,
    required this.upstreamInferenceInputCost,
    required this.upstreamInferenceOutputCost,
  });

  /// Upstream inference cost.
  @JsonKey(name: 'upstream_inference_cost')
  final double? upstreamInferenceCost;

  /// Input cost.
  @JsonKey(name: 'upstream_inference_input_cost')
  final double upstreamInferenceInputCost;

  /// Output cost.
  @JsonKey(name: 'upstream_inference_output_cost')
  final double upstreamInferenceOutputCost;

  factory CostDetails.fromJson(Map<String, dynamic> json) =>
      _$CostDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CostDetailsToJson(this);
}

/// Streaming chunk for Responses API.
class ResponsesStreamingChunk {
  const ResponsesStreamingChunk({
    required this.id,
    required this.object,
    required this.createdAt,
    required this.model,
    required this.output,
    this.usage,
    this.error,
  });

  final String id;
  final String object;
  final double createdAt;
  final String model;
  final List<ResponsesOutputItem> output;
  final ResponsesUsage? usage;
  final ResponseError? error;

  factory ResponsesStreamingChunk.fromJson(Map<String, dynamic> json) {
    return ResponsesStreamingChunk(
      id: json['id'] as String,
      object: json['object'] as String,
      createdAt: json['created_at'] as double,
      model: json['model'] as String,
      output: (json['output'] as List<dynamic>)
          .map((e) => _parseOutputItem(e as Map<String, dynamic>))
          .toList(),
      usage: json['usage'] != null
          ? ResponsesUsage.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
      error: json['error'] != null
          ? ResponseError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }

  static ResponsesOutputItem _parseOutputItem(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'message':
        return OutputMessage.fromJson(json);
      case 'reasoning':
        return OutputReasoning.fromJson(json);
      case 'function_call':
        return OutputFunctionCall.fromJson(json);
      case 'web_search_call':
        return OutputWebSearchCall.fromJson(json);
      case 'file_search_call':
        return OutputFileSearchCall.fromJson(json);
      case 'image_generation_call':
        return OutputImageGenerationCall.fromJson(json);
      default:
        throw FormatException('Unknown output type: $type');
    }
  }
}

/// Helper to convert output items to JSON.
List<Map<String, dynamic>> _outputToJson(List<ResponsesOutputItem> output) {
  return output.map((item) => item.toJson()).toList();
}

/// Helper to convert JSON to output items.
List<ResponsesOutputItem> _outputFromJson(List<dynamic> json) {
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    final type = map['type'] as String;
    switch (type) {
      case 'message':
        return OutputMessage.fromJson(map);
      case 'reasoning':
        return OutputReasoning.fromJson(map);
      case 'function_call':
        return OutputFunctionCall.fromJson(map);
      case 'web_search_call':
        return OutputWebSearchCall.fromJson(map);
      case 'file_search_call':
        return OutputFileSearchCall.fromJson(map);
      case 'image_generation_call':
        return OutputImageGenerationCall.fromJson(map);
      default:
        throw FormatException('Unknown output type: $type');
    }
  }).toList();
}

/// Helper to convert content items to JSON.
List<Map<String, dynamic>> _contentToJson(List<OutputContent> content) {
  return content.map((item) => item.toJson()).toList();
}

/// Helper to convert JSON to content items.
List<OutputContent> _contentFromJson(List<dynamic> json) {
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    final type = map['type'] as String;
    switch (type) {
      case 'output_text':
        return OutputText.fromJson(map);
      case 'refusal':
        return OutputRefusal.fromJson(map);
      default:
        throw FormatException('Unknown content type: $type');
    }
  }).toList();
}

/// Helper to convert annotations to JSON.
List<Map<String, dynamic>>? _annotationsToJson(List<Annotation>? annotations) {
  return annotations?.map((item) => item.toJson()).toList();
}

/// Helper to convert JSON to annotations.
List<Annotation>? _annotationsFromJson(List<dynamic>? json) {
  if (json == null) return null;
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    final type = map['type'] as String;
    switch (type) {
      case 'url_citation':
        return UrlCitation.fromJson(map);
      case 'file_citation':
        return FileCitation.fromJson(map);
      case 'file_path':
        return FilePath.fromJson(map);
      default:
        throw FormatException('Unknown annotation type: $type');
    }
  }).toList();
}
