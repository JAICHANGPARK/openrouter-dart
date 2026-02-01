import 'package:json_annotation/json_annotation.dart';

part 'responses_request.g.dart';

/// Request for the OpenRouter Responses API (Beta).
///
/// This API is stateless and compatible with OpenAI's Responses API format.
/// It supports advanced features like reasoning, tool calling, and web search.
@JsonSerializable()
class ResponsesRequest {
  const ResponsesRequest({
    required this.input,
    this.instructions,
    this.metadata,
    this.tools,
    this.toolChoice,
    this.parallelToolCalls,
    this.model,
    this.models,
    this.text,
    this.reasoning,
    this.maxOutputTokens,
    this.temperature,
    this.topP,
    this.topLogprobs,
    this.maxToolCalls,
    this.presencePenalty,
    this.frequencyPenalty,
    this.topK,
    this.imageConfig,
    this.modalities,
    this.promptCacheKey,
    this.previousResponseId,
    this.prompt,
    this.include,
    this.background,
    this.safetyIdentifier,
    this.store = false,
    this.serviceTier,
    this.truncation,
    this.stream = false,
    this.provider,
    this.plugins,
    this.user,
    this.sessionId,
  });

  /// Input for the response - can be a simple string or structured items.
  final dynamic input;

  /// Instructions for the model (alternative to system message).
  final String? instructions;

  /// Metadata to attach to the request.
  final Map<String, String>? metadata;

  /// Tools available to the model.
  @JsonKey(toJson: _toolsToJson, fromJson: _toolsFromJson)
  final List<ResponsesTool>? tools;

  /// Tool choice configuration.
  @JsonKey(
    name: 'tool_choice',
    toJson: _toolChoiceToJson,
    fromJson: _toolChoiceFromJson,
  )
  final ResponsesToolChoice? toolChoice;

  /// Whether to enable parallel tool calls.
  @JsonKey(name: 'parallel_tool_calls')
  final bool? parallelToolCalls;

  /// Model to use.
  final String? model;

  /// Fallback models.
  final List<String>? models;

  /// Text configuration including format and verbosity.
  final ResponsesTextConfig? text;

  /// Reasoning configuration.
  final ResponsesReasoningConfig? reasoning;

  /// Maximum output tokens.
  @JsonKey(name: 'max_output_tokens')
  final double? maxOutputTokens;

  /// Sampling temperature (0-2).
  final double? temperature;

  /// Nucleus sampling parameter.
  @JsonKey(name: 'top_p')
  final double? topP;

  /// Number of top logprobs to return.
  @JsonKey(name: 'top_logprobs')
  final int? topLogprobs;

  /// Maximum number of tool calls.
  @JsonKey(name: 'max_tool_calls')
  final int? maxToolCalls;

  /// Presence penalty (-2 to 2).
  @JsonKey(name: 'presence_penalty')
  final double? presencePenalty;

  /// Frequency penalty (-2 to 2).
  @JsonKey(name: 'frequency_penalty')
  final double? frequencyPenalty;

  /// Top-k sampling parameter.
  @JsonKey(name: 'top_k')
  final double? topK;

  /// Image generation configuration.
  @JsonKey(name: 'image_config')
  final Map<String, dynamic>? imageConfig;

  /// Output modalities (text, image).
  final List<String>? modalities;

  /// Prompt cache key for caching.
  @JsonKey(name: 'prompt_cache_key')
  final String? promptCacheKey;

  /// Previous response ID for multi-turn (stateless).
  @JsonKey(name: 'previous_response_id')
  final String? previousResponseId;

  /// Prompt template configuration.
  final ResponsesPrompt? prompt;

  /// Fields to include in the response.
  final List<String>? include;

  /// Whether to process in background.
  final bool? background;

  /// Safety identifier.
  @JsonKey(name: 'safety_identifier')
  final String? safetyIdentifier;

  /// Whether to store the response.
  final bool store;

  /// Service tier.
  @JsonKey(name: 'service_tier')
  final String? serviceTier;

  /// Truncation strategy.
  final dynamic truncation;

  /// Whether to stream the response.
  final bool stream;

  /// Provider routing preferences.
  final dynamic provider;

  /// Plugins to enable.
  final List<ResponsesPlugin>? plugins;

  /// User identifier.
  final String? user;

  /// Session ID for observability.
  @JsonKey(name: 'session_id')
  final String? sessionId;

  factory ResponsesRequest.fromJson(Map<String, dynamic> json) =>
      _$ResponsesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesRequestToJson(this);

  /// Creates a simple text request.
  static ResponsesRequest simple({
    required String input,
    required String model,
    bool stream = false,
  }) {
    return ResponsesRequest(input: input, model: model, stream: stream);
  }

  /// Creates a request with structured messages.
  static ResponsesRequest withMessages({
    required List<ResponsesInputItem> input,
    required String model,
    bool stream = false,
    List<ResponsesTool>? tools,
  }) {
    return ResponsesRequest(
      input: input.map((e) => e.toJson()).toList(),
      model: model,
      stream: stream,
      tools: tools,
    );
  }
}

/// Input item for structured input format.
sealed class ResponsesInputItem {
  const ResponsesInputItem();

  /// The type of input item.
  String get type;

  Map<String, dynamic> toJson();
}

/// Easy input message (simple format).
@JsonSerializable()
class EasyInputMessage extends ResponsesInputItem {
  const EasyInputMessage({required this.role, required this.content});

  @override
  @JsonKey(name: 'type')
  final String type = 'message';

  /// Role of the message.
  final EasyInputMessageRole role;

  /// Content - can be string or list of content parts.
  final dynamic content;

  factory EasyInputMessage.fromJson(Map<String, dynamic> json) =>
      _$EasyInputMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EasyInputMessageToJson(this);

  /// Creates a user message.
  static EasyInputMessage user(String content) =>
      EasyInputMessage(role: EasyInputMessageRole.user, content: content);

  /// Creates a system message.
  static EasyInputMessage system(String content) =>
      EasyInputMessage(role: EasyInputMessageRole.system, content: content);

  /// Creates an assistant message.
  static EasyInputMessage assistant(String content) =>
      EasyInputMessage(role: EasyInputMessageRole.assistant, content: content);

  /// Creates a developer message.
  static EasyInputMessage developer(String content) =>
      EasyInputMessage(role: EasyInputMessageRole.developer, content: content);
}

/// Easy input message roles.
@JsonEnum(valueField: 'value')
enum EasyInputMessageRole {
  user('user'),
  system('system'),
  assistant('assistant'),
  developer('developer');

  const EasyInputMessageRole(this.value);
  final String value;
}

/// Input message item (with ID, for conversation history).
@JsonSerializable()
class InputMessageItem extends ResponsesInputItem {
  const InputMessageItem({this.id, required this.role, required this.content});

  @override
  @JsonKey(name: 'type')
  final String type = 'message';

  /// Message ID.
  final String? id;

  /// Role of the message.
  final InputMessageItemRole role;

  /// Content parts.
  @JsonKey(toJson: _inputContentToJson, fromJson: _inputContentFromJson)
  final List<ResponseContentPart> content;

  factory InputMessageItem.fromJson(Map<String, dynamic> json) =>
      _$InputMessageItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputMessageItemToJson(this);
}

/// Input message item roles.
@JsonEnum(valueField: 'value')
enum InputMessageItemRole {
  user('user'),
  system('system'),
  developer('developer');

  const InputMessageItemRole(this.value);
  final String value;
}

/// Content part for input.
sealed class ResponseContentPart {
  const ResponseContentPart();

  String get type;
  Map<String, dynamic> toJson();
}

/// Text input content.
@JsonSerializable()
class ResponseInputText extends ResponseContentPart {
  const ResponseInputText({required this.text});

  @override
  @JsonKey(name: 'type')
  final String type = 'input_text';

  /// The text content.
  final String text;

  factory ResponseInputText.fromJson(Map<String, dynamic> json) =>
      _$ResponseInputTextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseInputTextToJson(this);
}

/// Image input content.
@JsonSerializable()
class ResponseInputImage extends ResponseContentPart {
  const ResponseInputImage({
    this.imageUrl,
    this.detail = ResponseInputImageDetail.auto,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'input_image';

  /// Image URL or base64 data.
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  /// Detail level.
  final ResponseInputImageDetail detail;

  factory ResponseInputImage.fromJson(Map<String, dynamic> json) =>
      _$ResponseInputImageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseInputImageToJson(this);
}

/// Image detail level.
@JsonEnum(valueField: 'value')
enum ResponseInputImageDetail {
  auto('auto'),
  high('high'),
  low('low');

  const ResponseInputImageDetail(this.value);
  final String value;
}

/// File input content.
@JsonSerializable()
class ResponseInputFile extends ResponseContentPart {
  const ResponseInputFile({
    this.fileId,
    this.fileData,
    this.filename,
    this.fileUrl,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'input_file';

  /// File ID.
  @JsonKey(name: 'file_id')
  final String? fileId;

  /// File data (base64).
  @JsonKey(name: 'file_data')
  final String? fileData;

  /// Filename.
  final String? filename;

  /// File URL.
  @JsonKey(name: 'file_url')
  final String? fileUrl;

  factory ResponseInputFile.fromJson(Map<String, dynamic> json) =>
      _$ResponseInputFileFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseInputFileToJson(this);
}

/// Audio input content.
@JsonSerializable()
class ResponseInputAudio extends ResponseContentPart {
  const ResponseInputAudio({required this.inputAudio});

  @override
  @JsonKey(name: 'type')
  final String type = 'input_audio';

  /// Audio data.
  @JsonKey(name: 'input_audio')
  final InputAudioData inputAudio;

  factory ResponseInputAudio.fromJson(Map<String, dynamic> json) =>
      _$ResponseInputAudioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseInputAudioToJson(this);
}

/// Audio data.
@JsonSerializable()
class InputAudioData {
  const InputAudioData({required this.data, required this.format});

  /// Base64 encoded audio data.
  final String data;

  /// Audio format (mp3, wav).
  final InputAudioFormat format;

  factory InputAudioData.fromJson(Map<String, dynamic> json) =>
      _$InputAudioDataFromJson(json);

  Map<String, dynamic> toJson() => _$InputAudioDataToJson(this);
}

/// Audio format.
@JsonEnum(valueField: 'value')
enum InputAudioFormat {
  mp3('mp3'),
  wav('wav');

  const InputAudioFormat(this.value);
  final String value;
}

/// Video input content.
@JsonSerializable()
class ResponseInputVideo extends ResponseContentPart {
  const ResponseInputVideo({required this.videoUrl});

  @override
  @JsonKey(name: 'type')
  final String type = 'input_video';

  /// Video URL or base64 data.
  @JsonKey(name: 'video_url')
  final String videoUrl;

  factory ResponseInputVideo.fromJson(Map<String, dynamic> json) =>
      _$ResponseInputVideoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseInputVideoToJson(this);
}

/// Tool call output (for including function results in conversation).
@JsonSerializable()
class FunctionCallOutput extends ResponsesInputItem {
  const FunctionCallOutput({
    this.id,
    required this.callId,
    required this.output,
    this.status,
  });

  @override
  @JsonKey(name: 'type')
  final String type = 'function_call_output';

  /// Output ID.
  final String? id;

  /// Call ID to match with the tool call.
  @JsonKey(name: 'call_id')
  final String callId;

  /// Output data (JSON string).
  final String output;

  /// Status.
  final ToolCallStatus? status;

  factory FunctionCallOutput.fromJson(Map<String, dynamic> json) =>
      _$FunctionCallOutputFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FunctionCallOutputToJson(this);
}

/// Tool call status.
@JsonEnum(valueField: 'value')
enum ToolCallStatus {
  inProgress('in_progress'),
  completed('completed'),
  incomplete('incomplete');

  const ToolCallStatus(this.value);
  final String value;
}

/// Text configuration.
@JsonSerializable()
class ResponsesTextConfig {
  const ResponsesTextConfig({this.format, this.verbosity});

  /// Response format.
  @JsonKey(toJson: _formatToJson, fromJson: _formatFromJson)
  final ResponseFormatTextConfig? format;

  /// Verbosity level.
  final ResponseVerbosity? verbosity;

  factory ResponsesTextConfig.fromJson(Map<String, dynamic> json) =>
      _$ResponsesTextConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesTextConfigToJson(this);
}

/// Response format configuration.
sealed class ResponseFormatTextConfig {
  const ResponseFormatTextConfig();
  Map<String, dynamic> toJson();
}

/// Text format.
@JsonSerializable()
class FormatText extends ResponseFormatTextConfig {
  const FormatText();

  final String type = 'text';

  factory FormatText.fromJson(Map<String, dynamic> json) =>
      _$FormatTextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FormatTextToJson(this);
}

/// JSON object format.
@JsonSerializable()
class FormatJsonObject extends ResponseFormatTextConfig {
  const FormatJsonObject();

  final String type = 'json_object';

  factory FormatJsonObject.fromJson(Map<String, dynamic> json) =>
      _$FormatJsonObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FormatJsonObjectToJson(this);
}

/// JSON schema format.
@JsonSerializable()
class FormatJsonSchema extends ResponseFormatTextConfig {
  const FormatJsonSchema({
    required this.name,
    required this.schema,
    this.description,
    this.strict,
  });

  final String type = 'json_schema';
  final String name;
  final String? description;
  final Map<String, dynamic> schema;
  final bool? strict;

  factory FormatJsonSchema.fromJson(Map<String, dynamic> json) =>
      _$FormatJsonSchemaFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FormatJsonSchemaToJson(this);
}

/// Response verbosity.
@JsonEnum(valueField: 'value')
enum ResponseVerbosity {
  high('high'),
  medium('medium'),
  low('low');

  const ResponseVerbosity(this.value);
  final String value;
}

/// Reasoning configuration.
@JsonSerializable()
class ResponsesReasoningConfig {
  const ResponsesReasoningConfig({
    this.effort,
    this.summary,
    this.maxTokens,
    this.enabled,
  });

  /// Reasoning effort level.
  final ReasoningEffort? effort;

  /// Summary verbosity.
  final ReasoningSummaryVerbosity? summary;

  /// Maximum reasoning tokens.
  @JsonKey(name: 'max_tokens')
  final double? maxTokens;

  /// Whether reasoning is enabled.
  final bool? enabled;

  factory ResponsesReasoningConfig.fromJson(Map<String, dynamic> json) =>
      _$ResponsesReasoningConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesReasoningConfigToJson(this);
}

/// Reasoning effort.
@JsonEnum(valueField: 'value')
enum ReasoningEffort {
  xhigh('xhigh'),
  high('high'),
  medium('medium'),
  low('low'),
  minimal('minimal'),
  none('none');

  const ReasoningEffort(this.value);
  final String value;
}

/// Reasoning summary verbosity.
@JsonEnum(valueField: 'value')
enum ReasoningSummaryVerbosity {
  auto('auto'),
  concise('concise'),
  detailed('detailed');

  const ReasoningSummaryVerbosity(this.value);
  final String value;
}

/// Tool definition.
sealed class ResponsesTool {
  const ResponsesTool();
  Map<String, dynamic> toJson();
}

/// Function tool.
@JsonSerializable()
class ResponsesFunctionTool extends ResponsesTool {
  const ResponsesFunctionTool({
    required this.name,
    this.description,
    this.parameters,
    this.strict,
  });

  final String type = 'function';
  final String name;
  final String? description;
  final Map<String, dynamic>? parameters;
  final bool? strict;

  factory ResponsesFunctionTool.fromJson(Map<String, dynamic> json) =>
      _$ResponsesFunctionToolFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponsesFunctionToolToJson(this);
}

/// Web search preview tool.
@JsonSerializable()
class WebSearchPreviewTool extends ResponsesTool {
  const WebSearchPreviewTool({this.searchContextSize, this.userLocation});

  final String type = 'web_search_preview';

  @JsonKey(name: 'search_context_size')
  final SearchContextSize? searchContextSize;

  @JsonKey(name: 'user_location')
  final UserLocation? userLocation;

  factory WebSearchPreviewTool.fromJson(Map<String, dynamic> json) =>
      _$WebSearchPreviewToolFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WebSearchPreviewToolToJson(this);
}

/// Search context size.
@JsonEnum(valueField: 'value')
enum SearchContextSize {
  low('low'),
  medium('medium'),
  high('high');

  const SearchContextSize(this.value);
  final String value;
}

/// User location for search.
@JsonSerializable()
class UserLocation {
  const UserLocation({this.city, this.country, this.region, this.timezone});

  final String type = 'approximate';
  final String? city;
  final String? country;
  final String? region;
  final String? timezone;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}

/// Tool choice.
sealed class ResponsesToolChoice {
  const ResponsesToolChoice();
  Map<String, dynamic> toJson();
}

/// Auto tool choice.
class ToolChoiceAuto extends ResponsesToolChoice {
  const ToolChoiceAuto();
  final String type = 'auto';

  @override
  Map<String, dynamic> toJson() => {'type': type};
}

/// None tool choice.
class ToolChoiceNone extends ResponsesToolChoice {
  const ToolChoiceNone();
  final String type = 'none';

  @override
  Map<String, dynamic> toJson() => {'type': type};
}

/// Required tool choice.
class ToolChoiceRequired extends ResponsesToolChoice {
  const ToolChoiceRequired();
  final String type = 'required';

  @override
  Map<String, dynamic> toJson() => {'type': type};
}

/// Named function tool choice.
@JsonSerializable()
class ToolChoiceFunction extends ResponsesToolChoice {
  const ToolChoiceFunction({required this.name});

  final String type = 'function';
  final String name;

  factory ToolChoiceFunction.fromJson(Map<String, dynamic> json) =>
      _$ToolChoiceFunctionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ToolChoiceFunctionToJson(this);
}

/// Plugin for responses.
@JsonSerializable()
class ResponsesPlugin {
  const ResponsesPlugin({
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

  /// Whether enabled.
  final bool? enabled;

  /// Max results (for web search).
  @JsonKey(name: 'max_results')
  final int? maxResults;

  /// Search prompt.
  @JsonKey(name: 'search_prompt')
  final String? searchPrompt;

  /// Search engine.
  final String? engine;

  /// PDF options.
  final PdfOptions? pdf;

  /// Allowed models (for auto-router).
  @JsonKey(name: 'allowed_models')
  final List<String>? allowedModels;

  factory ResponsesPlugin.fromJson(Map<String, dynamic> json) =>
      _$ResponsesPluginFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesPluginToJson(this);

  /// Web search plugin.
  static ResponsesPlugin web({int? maxResults, String? engine}) =>
      ResponsesPlugin(id: 'web', maxResults: maxResults, engine: engine);

  /// Auto-router plugin.
  static ResponsesPlugin autoRouter({List<String>? allowedModels}) =>
      ResponsesPlugin(id: 'auto-router', allowedModels: allowedModels);

  /// File parser plugin.
  static ResponsesPlugin fileParser({PdfOptions? pdf}) =>
      ResponsesPlugin(id: 'file-parser', pdf: pdf);

  /// Response healing plugin.
  static ResponsesPlugin responseHealing() =>
      const ResponsesPlugin(id: 'response-healing');

  /// Moderation plugin.
  static ResponsesPlugin moderation() =>
      const ResponsesPlugin(id: 'moderation');
}

/// PDF options.
@JsonSerializable()
class PdfOptions {
  const PdfOptions({this.engine});

  /// PDF parsing engine.
  final String? engine;

  factory PdfOptions.fromJson(Map<String, dynamic> json) =>
      _$PdfOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PdfOptionsToJson(this);
}

/// Prompt template.
@JsonSerializable()
class ResponsesPrompt {
  const ResponsesPrompt({required this.id, this.variables});

  /// Prompt template ID.
  final String id;

  /// Variables for the template.
  final Map<String, dynamic>? variables;

  factory ResponsesPrompt.fromJson(Map<String, dynamic> json) =>
      _$ResponsesPromptFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsesPromptToJson(this);
}

/// Helper to convert tools list to JSON.
List<Map<String, dynamic>>? _toolsToJson(List<ResponsesTool>? tools) {
  return tools?.map((t) => t.toJson()).toList();
}

/// Helper to convert JSON to tools list.
List<ResponsesTool>? _toolsFromJson(List<dynamic>? json) {
  if (json == null) return null;
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    final type = map['type'] as String;
    switch (type) {
      case 'function':
        return ResponsesFunctionTool.fromJson(map);
      case 'web_search_preview':
        return WebSearchPreviewTool.fromJson(map);
      default:
        throw FormatException('Unknown tool type: $type');
    }
  }).toList();
}

/// Helper to convert tool choice to JSON.
Map<String, dynamic>? _toolChoiceToJson(ResponsesToolChoice? choice) {
  return choice?.toJson();
}

/// Helper to convert JSON to tool choice.
ResponsesToolChoice? _toolChoiceFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  final type = json['type'] as String;
  switch (type) {
    case 'auto':
      return const ToolChoiceAuto();
    case 'none':
      return const ToolChoiceNone();
    case 'required':
      return const ToolChoiceRequired();
    case 'function':
      return ToolChoiceFunction.fromJson(json);
    default:
      throw FormatException('Unknown tool choice type: $type');
  }
}

/// Helper to convert input content parts to JSON.
List<Map<String, dynamic>> _inputContentToJson(
  List<ResponseContentPart> content,
) {
  return content.map((item) => item.toJson()).toList();
}

/// Helper to convert JSON to input content parts.
List<ResponseContentPart> _inputContentFromJson(List<dynamic> json) {
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    final type = map['type'] as String;
    switch (type) {
      case 'input_text':
        return ResponseInputText.fromJson(map);
      case 'input_image':
        return ResponseInputImage.fromJson(map);
      case 'input_file':
        return ResponseInputFile.fromJson(map);
      case 'input_audio':
        return ResponseInputAudio.fromJson(map);
      case 'input_video':
        return ResponseInputVideo.fromJson(map);
      default:
        throw FormatException('Unknown content part type: $type');
    }
  }).toList();
}

/// Helper to convert format to JSON.
Map<String, dynamic>? _formatToJson(ResponseFormatTextConfig? format) {
  return format?.toJson();
}

/// Helper to convert JSON to format.
ResponseFormatTextConfig? _formatFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  final type = json['type'] as String;
  switch (type) {
    case 'text':
      return const FormatText();
    case 'json_object':
      return const FormatJsonObject();
    case 'json_schema':
      return FormatJsonSchema.fromJson(json);
    default:
      throw FormatException('Unknown format type: $type');
  }
}
