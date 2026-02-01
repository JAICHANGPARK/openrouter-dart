import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'chat_request.g.dart';

/// Request body for chat completion.
@JsonSerializable()
class ChatRequest {
  const ChatRequest({
    required this.messages,
    this.model,
    this.models,
    this.frequencyPenalty,
    this.logitBias,
    this.logprobs,
    this.topLogprobs,
    this.maxTokens,
    this.maxCompletionTokens,
    this.metadata,
    this.presencePenalty,
    this.reasoning,
    this.responseFormat,
    this.seed,
    this.stop,
    this.stream = false,
    this.streamOptions,
    this.temperature,
    this.toolChoice,
    this.tools,
    this.topP,
    this.topK,
    this.user,
    this.provider,
    this.plugins,
    this.route,
    this.debug,
    this.imageConfig,
    this.modalities,
    this.transforms,
    this.minP,
    this.topA,
    this.repetitionPenalty,
    this.prediction,
  });

  /// List of messages in the conversation.
  final List<Message> messages;

  /// Model to use for completion.
  final String? model;

  /// Fallback models to try if primary fails.
  final List<String>? models;

  /// Frequency penalty (-2.0 to 2.0).
  @JsonKey(name: 'frequency_penalty')
  final double? frequencyPenalty;

  /// Logit bias for token manipulation.
  @JsonKey(name: 'logit_bias')
  final Map<String, double>? logitBias;

  /// Whether to return log probabilities.
  final bool? logprobs;

  /// Number of top logprobs to return.
  @JsonKey(name: 'top_logprobs')
  final double? topLogprobs;

  /// Maximum tokens to generate.
  @JsonKey(name: 'max_tokens')
  final int? maxTokens;

  /// Maximum completion tokens (for o1 models).
  @JsonKey(name: 'max_completion_tokens')
  final int? maxCompletionTokens;

  /// Metadata to attach to the request.
  final Map<String, String>? metadata;

  /// Presence penalty (-2.0 to 2.0).
  @JsonKey(name: 'presence_penalty')
  final double? presencePenalty;

  /// Reasoning configuration.
  final ReasoningConfig? reasoning;

  /// Response format configuration.
  @JsonKey(name: 'response_format')
  final ResponseFormat? responseFormat;

  /// Seed for deterministic sampling.
  final int? seed;

  /// Stop sequences.
  final dynamic stop;

  /// Whether to stream the response.
  final bool stream;

  /// Stream options.
  @JsonKey(name: 'stream_options')
  final StreamOptions? streamOptions;

  /// Sampling temperature (0.0 to 2.0).
  final double? temperature;

  /// Tool choice configuration.
  @JsonKey(name: 'tool_choice')
  final ToolChoice? toolChoice;

  /// Available tools.
  final List<ToolDefinition>? tools;

  /// Nucleus sampling parameter (0.0 to 1.0).
  @JsonKey(name: 'top_p')
  final double? topP;

  /// Top-k sampling parameter.
  @JsonKey(name: 'top_k')
  final int? topK;

  /// User identifier.
  final String? user;

  /// Provider routing preferences.
  final ProviderPreferences? provider;

  /// Plugins to enable.
  final List<Plugin>? plugins;

  /// Routing strategy.
  final String? route;

  /// Debug options.
  final DebugOptions? debug;

  /// Image generation configuration.
  @JsonKey(name: 'image_config')
  final Map<String, dynamic>? imageConfig;

  /// Output modalities.
  final List<String>? modalities;

  /// Message transforms.
  final List<String>? transforms;

  /// Minimum probability parameter.
  @JsonKey(name: 'min_p')
  final double? minP;

  /// Top-a sampling parameter.
  @JsonKey(name: 'top_a')
  final double? topA;

  /// Repetition penalty.
  @JsonKey(name: 'repetition_penalty')
  final double? repetitionPenalty;

  /// Prediction for latency optimization.
  final Prediction? prediction;

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);
}

/// Reasoning configuration.
@JsonSerializable()
class ReasoningConfig {
  const ReasoningConfig({
    this.effort,
    this.summary,
    this.maxTokens,
    this.enabled,
  });

  /// Reasoning effort level.
  final ReasoningEffort? effort;

  /// Summary verbosity.
  final ReasoningSummary? summary;

  /// Maximum reasoning tokens.
  @JsonKey(name: 'max_tokens')
  final int? maxTokens;

  /// Whether reasoning is enabled.
  final bool? enabled;

  factory ReasoningConfig.fromJson(Map<String, dynamic> json) =>
      _$ReasoningConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ReasoningConfigToJson(this);
}

/// Reasoning effort levels.
@JsonEnum(valueField: 'value')
enum ReasoningEffort {
  minimal('minimal'),
  low('low'),
  medium('medium'),
  high('high'),
  xhigh('xhigh'),
  none('none');

  const ReasoningEffort(this.value);
  final String value;
}

/// Reasoning summary verbosity.
@JsonEnum(valueField: 'value')
enum ReasoningSummary {
  auto('auto'),
  concise('concise'),
  detailed('detailed');

  const ReasoningSummary(this.value);
  final String value;
}

/// Response format configuration.
@JsonSerializable()
class ResponseFormat {
  const ResponseFormat({required this.type, this.jsonSchema, this.grammar});

  /// Type of response format.
  final String type;

  /// JSON schema for structured output.
  @JsonKey(name: 'json_schema')
  final JsonSchemaConfig? jsonSchema;

  /// Grammar for constrained output.
  final String? grammar;

  factory ResponseFormat.fromJson(Map<String, dynamic> json) =>
      _$ResponseFormatFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseFormatToJson(this);

  /// Create a text response format.
  static ResponseFormat text() => const ResponseFormat(type: 'text');

  /// Create a JSON object response format.
  static ResponseFormat jsonObject() =>
      const ResponseFormat(type: 'json_object');

  /// Create a JSON schema response format.
  static ResponseFormat jsonSchemaFormat(JsonSchemaConfig schema) =>
      ResponseFormat(type: 'json_schema', jsonSchema: schema);
}

/// JSON schema configuration.
@JsonSerializable()
class JsonSchemaConfig {
  const JsonSchemaConfig({
    required this.name,
    required this.schema,
    this.description,
    this.strict,
  });

  /// Name of the schema.
  final String name;

  /// The JSON schema object.
  final Map<String, dynamic> schema;

  /// Description of the schema.
  final String? description;

  /// Whether strict validation is enabled.
  final bool? strict;

  factory JsonSchemaConfig.fromJson(Map<String, dynamic> json) =>
      _$JsonSchemaConfigFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSchemaConfigToJson(this);
}

/// Stream options.
@JsonSerializable()
class StreamOptions {
  const StreamOptions({this.includeUsage = false});

  /// Whether to include usage in the final stream chunk.
  @JsonKey(name: 'include_usage')
  final bool includeUsage;

  factory StreamOptions.fromJson(Map<String, dynamic> json) =>
      _$StreamOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$StreamOptionsToJson(this);
}

/// Tool choice configuration.
@JsonSerializable()
class ToolChoice {
  const ToolChoice({this.type, this.function});

  /// Type of tool choice.
  final String? type;

  /// Function specification for named tool choice.
  final ToolChoiceFunction? function;

  factory ToolChoice.fromJson(Map<String, dynamic> json) =>
      _$ToolChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ToolChoiceToJson(this);

  /// Auto tool choice.
  static ToolChoice auto() => const ToolChoice(type: 'auto');

  /// None tool choice.
  static ToolChoice none() => const ToolChoice(type: 'none');

  /// Required tool choice.
  static ToolChoice required() => const ToolChoice(type: 'required');

  /// Named function tool choice.
  static ToolChoice namedFunction(String name) => ToolChoice(
    type: 'function',
    function: ToolChoiceFunction(name: name),
  );
}

/// Tool choice function specification.
@JsonSerializable()
class ToolChoiceFunction {
  const ToolChoiceFunction({required this.name});

  /// Name of the function.
  final String name;

  factory ToolChoiceFunction.fromJson(Map<String, dynamic> json) =>
      _$ToolChoiceFunctionFromJson(json);

  Map<String, dynamic> toJson() => _$ToolChoiceFunctionToJson(this);
}

/// Tool definition.
@JsonSerializable()
class ToolDefinition {
  const ToolDefinition({this.type = 'function', required this.function});

  /// Type of tool (always 'function').
  final String type;

  /// Function definition.
  final FunctionDefinition function;

  factory ToolDefinition.fromJson(Map<String, dynamic> json) =>
      _$ToolDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$ToolDefinitionToJson(this);
}

/// Function definition.
@JsonSerializable()
class FunctionDefinition {
  const FunctionDefinition({
    required this.name,
    this.description,
    this.parameters,
    this.strict,
  });

  /// Name of the function.
  final String name;

  /// Description of the function.
  final String? description;

  /// Parameters schema.
  final Map<String, dynamic>? parameters;

  /// Whether strict mode is enabled.
  final bool? strict;

  factory FunctionDefinition.fromJson(Map<String, dynamic> json) =>
      _$FunctionDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$FunctionDefinitionToJson(this);
}

/// Provider routing preferences.
@JsonSerializable()
class ProviderPreferences {
  const ProviderPreferences({
    this.allowFallbacks,
    this.requireParameters,
    this.dataCollection,
    this.zdr,
    this.enforceDistillableText,
    this.order,
    this.only,
    this.ignore,
    this.quantizations,
    this.sort,
    this.maxPrice,
    this.preferredMinThroughput,
    this.preferredMaxLatency,
  });

  /// Whether to allow fallback providers.
  @JsonKey(name: 'allow_fallbacks')
  final bool? allowFallbacks;

  /// Whether to require all parameters.
  @JsonKey(name: 'require_parameters')
  final bool? requireParameters;

  /// Data collection preference.
  @JsonKey(name: 'data_collection')
  final DataCollection? dataCollection;

  /// Zero data retention preference.
  final bool? zdr;

  /// Whether to enforce distillable text.
  @JsonKey(name: 'enforce_distillable_text')
  final bool? enforceDistillableText;

  /// Provider order preference.
  final List<String>? order;

  /// Only use these providers.
  final List<String>? only;

  /// Ignore these providers.
  final List<String>? ignore;

  /// Quantization levels.
  final List<String>? quantizations;

  /// Sort strategy.
  final dynamic sort;

  /// Maximum price.
  @JsonKey(name: 'max_price')
  final MaxPrice? maxPrice;

  /// Preferred minimum throughput.
  @JsonKey(name: 'preferred_min_throughput')
  final dynamic preferredMinThroughput;

  /// Preferred maximum latency.
  @JsonKey(name: 'preferred_max_latency')
  final dynamic preferredMaxLatency;

  factory ProviderPreferences.fromJson(Map<String, dynamic> json) =>
      _$ProviderPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderPreferencesToJson(this);
}

/// Data collection preference.
@JsonEnum(valueField: 'value')
enum DataCollection {
  deny('deny'),
  allow('allow');

  const DataCollection(this.value);
  final String value;
}

/// Maximum price configuration.
@JsonSerializable()
class MaxPrice {
  const MaxPrice({
    this.prompt,
    this.completion,
    this.image,
    this.audio,
    this.request,
  });

  /// Price per prompt token.
  final dynamic prompt;

  /// Price per completion token.
  final dynamic completion;

  /// Price per image.
  final dynamic image;

  /// Price per audio token.
  final dynamic audio;

  /// Price per request.
  final dynamic request;

  factory MaxPrice.fromJson(Map<String, dynamic> json) =>
      _$MaxPriceFromJson(json);

  Map<String, dynamic> toJson() => _$MaxPriceToJson(this);
}

/// Plugin configuration.
@JsonSerializable()
class Plugin {
  const Plugin({
    required this.id,
    this.enabled,
    this.maxResults,
    this.searchPrompt,
    this.engine,
    this.pdf,
    this.allowedModels,
  });

  /// Plugin ID.
  final String id;

  /// Whether the plugin is enabled.
  final bool? enabled;

  /// Maximum search results (for web plugin).
  @JsonKey(name: 'max_results')
  final int? maxResults;

  /// Search prompt (for web plugin).
  @JsonKey(name: 'search_prompt')
  final String? searchPrompt;

  /// Search engine (for web plugin).
  final String? engine;

  /// PDF options (for file-parser plugin).
  final PdfOptions? pdf;

  /// Allowed models (for auto-router plugin).
  @JsonKey(name: 'allowed_models')
  final List<String>? allowedModels;

  factory Plugin.fromJson(Map<String, dynamic> json) => _$PluginFromJson(json);

  Map<String, dynamic> toJson() => _$PluginToJson(this);

  /// Web search plugin.
  static Plugin web({int? maxResults, String? engine}) =>
      Plugin(id: 'web', maxResults: maxResults, engine: engine);

  /// Auto-router plugin.
  static Plugin autoRouter({List<String>? allowedModels}) =>
      Plugin(id: 'auto-router', allowedModels: allowedModels);

  /// File parser plugin.
  static Plugin fileParser({PdfOptions? pdf}) =>
      Plugin(id: 'file-parser', pdf: pdf);

  /// Response healing plugin.
  static Plugin responseHealing() => const Plugin(id: 'response-healing');

  /// Moderation plugin.
  static Plugin moderation() => const Plugin(id: 'moderation');
}

/// PDF parsing options.
@JsonSerializable()
class PdfOptions {
  const PdfOptions({this.engine});

  /// PDF parsing engine.
  final String? engine;

  factory PdfOptions.fromJson(Map<String, dynamic> json) =>
      _$PdfOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PdfOptionsToJson(this);
}

/// Debug options.
@JsonSerializable()
class DebugOptions {
  const DebugOptions({this.echoUpstreamBody});

  /// Whether to echo the upstream request body.
  @JsonKey(name: 'echo_upstream_body')
  final bool? echoUpstreamBody;

  factory DebugOptions.fromJson(Map<String, dynamic> json) =>
      _$DebugOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$DebugOptionsToJson(this);
}

/// Prediction for latency optimization.
@JsonSerializable()
class Prediction {
  const Prediction({required this.type, required this.content});

  /// Type of prediction (always 'content').
  final String type;

  /// Predicted content.
  final String content;

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionToJson(this);
}
