// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsesRequest _$ResponsesRequestFromJson(
  Map<String, dynamic> json,
) => ResponsesRequest(
  input: json['input'],
  instructions: json['instructions'] as String?,
  metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  tools: _toolsFromJson(json['tools'] as List?),
  toolChoice: _toolChoiceFromJson(json['tool_choice'] as Map<String, dynamic>?),
  parallelToolCalls: json['parallel_tool_calls'] as bool?,
  model: json['model'] as String?,
  models: (json['models'] as List<dynamic>?)?.map((e) => e as String).toList(),
  text: json['text'] == null
      ? null
      : ResponsesTextConfig.fromJson(json['text'] as Map<String, dynamic>),
  reasoning: json['reasoning'] == null
      ? null
      : ResponsesReasoningConfig.fromJson(
          json['reasoning'] as Map<String, dynamic>,
        ),
  maxOutputTokens: (json['max_output_tokens'] as num?)?.toDouble(),
  temperature: (json['temperature'] as num?)?.toDouble(),
  topP: (json['top_p'] as num?)?.toDouble(),
  topLogprobs: (json['top_logprobs'] as num?)?.toInt(),
  maxToolCalls: (json['max_tool_calls'] as num?)?.toInt(),
  presencePenalty: (json['presence_penalty'] as num?)?.toDouble(),
  frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble(),
  topK: (json['top_k'] as num?)?.toDouble(),
  imageConfig: json['image_config'] as Map<String, dynamic>?,
  modalities: (json['modalities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  promptCacheKey: json['prompt_cache_key'] as String?,
  previousResponseId: json['previous_response_id'] as String?,
  prompt: json['prompt'] == null
      ? null
      : ResponsesPrompt.fromJson(json['prompt'] as Map<String, dynamic>),
  include: (json['include'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  background: json['background'] as bool?,
  safetyIdentifier: json['safety_identifier'] as String?,
  store: json['store'] as bool? ?? false,
  serviceTier: json['service_tier'] as String?,
  truncation: json['truncation'],
  stream: json['stream'] as bool? ?? false,
  provider: json['provider'],
  plugins: (json['plugins'] as List<dynamic>?)
      ?.map((e) => ResponsesPlugin.fromJson(e as Map<String, dynamic>))
      .toList(),
  user: json['user'] as String?,
  sessionId: json['session_id'] as String?,
);

Map<String, dynamic> _$ResponsesRequestToJson(ResponsesRequest instance) =>
    <String, dynamic>{
      'input': instance.input,
      'instructions': instance.instructions,
      'metadata': instance.metadata,
      'tools': _toolsToJson(instance.tools),
      'tool_choice': _toolChoiceToJson(instance.toolChoice),
      'parallel_tool_calls': instance.parallelToolCalls,
      'model': instance.model,
      'models': instance.models,
      'text': instance.text,
      'reasoning': instance.reasoning,
      'max_output_tokens': instance.maxOutputTokens,
      'temperature': instance.temperature,
      'top_p': instance.topP,
      'top_logprobs': instance.topLogprobs,
      'max_tool_calls': instance.maxToolCalls,
      'presence_penalty': instance.presencePenalty,
      'frequency_penalty': instance.frequencyPenalty,
      'top_k': instance.topK,
      'image_config': instance.imageConfig,
      'modalities': instance.modalities,
      'prompt_cache_key': instance.promptCacheKey,
      'previous_response_id': instance.previousResponseId,
      'prompt': instance.prompt,
      'include': instance.include,
      'background': instance.background,
      'safety_identifier': instance.safetyIdentifier,
      'store': instance.store,
      'service_tier': instance.serviceTier,
      'truncation': instance.truncation,
      'stream': instance.stream,
      'provider': instance.provider,
      'plugins': instance.plugins,
      'user': instance.user,
      'session_id': instance.sessionId,
    };

EasyInputMessage _$EasyInputMessageFromJson(Map<String, dynamic> json) =>
    EasyInputMessage(
      role: $enumDecode(_$EasyInputMessageRoleEnumMap, json['role']),
      content: json['content'],
    );

Map<String, dynamic> _$EasyInputMessageToJson(EasyInputMessage instance) =>
    <String, dynamic>{
      'role': _$EasyInputMessageRoleEnumMap[instance.role]!,
      'content': instance.content,
    };

const _$EasyInputMessageRoleEnumMap = {
  EasyInputMessageRole.user: 'user',
  EasyInputMessageRole.system: 'system',
  EasyInputMessageRole.assistant: 'assistant',
  EasyInputMessageRole.developer: 'developer',
};

InputMessageItem _$InputMessageItemFromJson(Map<String, dynamic> json) =>
    InputMessageItem(
      id: json['id'] as String?,
      role: $enumDecode(_$InputMessageItemRoleEnumMap, json['role']),
      content: _inputContentFromJson(json['content'] as List),
    );

Map<String, dynamic> _$InputMessageItemToJson(InputMessageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$InputMessageItemRoleEnumMap[instance.role]!,
      'content': _inputContentToJson(instance.content),
    };

const _$InputMessageItemRoleEnumMap = {
  InputMessageItemRole.user: 'user',
  InputMessageItemRole.system: 'system',
  InputMessageItemRole.developer: 'developer',
};

ResponseInputText _$ResponseInputTextFromJson(Map<String, dynamic> json) =>
    ResponseInputText(text: json['text'] as String);

Map<String, dynamic> _$ResponseInputTextToJson(ResponseInputText instance) =>
    <String, dynamic>{'text': instance.text};

ResponseInputImage _$ResponseInputImageFromJson(Map<String, dynamic> json) =>
    ResponseInputImage(
      imageUrl: json['image_url'] as String?,
      detail:
          $enumDecodeNullable(
            _$ResponseInputImageDetailEnumMap,
            json['detail'],
          ) ??
          ResponseInputImageDetail.auto,
    );

Map<String, dynamic> _$ResponseInputImageToJson(ResponseInputImage instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'detail': _$ResponseInputImageDetailEnumMap[instance.detail]!,
    };

const _$ResponseInputImageDetailEnumMap = {
  ResponseInputImageDetail.auto: 'auto',
  ResponseInputImageDetail.high: 'high',
  ResponseInputImageDetail.low: 'low',
};

ResponseInputFile _$ResponseInputFileFromJson(Map<String, dynamic> json) =>
    ResponseInputFile(
      fileId: json['file_id'] as String?,
      fileData: json['file_data'] as String?,
      filename: json['filename'] as String?,
      fileUrl: json['file_url'] as String?,
    );

Map<String, dynamic> _$ResponseInputFileToJson(ResponseInputFile instance) =>
    <String, dynamic>{
      'file_id': instance.fileId,
      'file_data': instance.fileData,
      'filename': instance.filename,
      'file_url': instance.fileUrl,
    };

ResponseInputAudio _$ResponseInputAudioFromJson(Map<String, dynamic> json) =>
    ResponseInputAudio(
      inputAudio: InputAudioData.fromJson(
        json['input_audio'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ResponseInputAudioToJson(ResponseInputAudio instance) =>
    <String, dynamic>{'input_audio': instance.inputAudio};

InputAudioData _$InputAudioDataFromJson(Map<String, dynamic> json) =>
    InputAudioData(
      data: json['data'] as String,
      format: $enumDecode(_$InputAudioFormatEnumMap, json['format']),
    );

Map<String, dynamic> _$InputAudioDataToJson(InputAudioData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'format': _$InputAudioFormatEnumMap[instance.format]!,
    };

const _$InputAudioFormatEnumMap = {
  InputAudioFormat.mp3: 'mp3',
  InputAudioFormat.wav: 'wav',
};

ResponseInputVideo _$ResponseInputVideoFromJson(Map<String, dynamic> json) =>
    ResponseInputVideo(videoUrl: json['video_url'] as String);

Map<String, dynamic> _$ResponseInputVideoToJson(ResponseInputVideo instance) =>
    <String, dynamic>{'video_url': instance.videoUrl};

FunctionCallOutput _$FunctionCallOutputFromJson(Map<String, dynamic> json) =>
    FunctionCallOutput(
      id: json['id'] as String?,
      callId: json['call_id'] as String,
      output: json['output'] as String,
      status: $enumDecodeNullable(_$ToolCallStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$FunctionCallOutputToJson(FunctionCallOutput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'call_id': instance.callId,
      'output': instance.output,
      'status': _$ToolCallStatusEnumMap[instance.status],
    };

const _$ToolCallStatusEnumMap = {
  ToolCallStatus.inProgress: 'in_progress',
  ToolCallStatus.completed: 'completed',
  ToolCallStatus.incomplete: 'incomplete',
};

ResponsesTextConfig _$ResponsesTextConfigFromJson(Map<String, dynamic> json) =>
    ResponsesTextConfig(
      format: _formatFromJson(json['format'] as Map<String, dynamic>?),
      verbosity: $enumDecodeNullable(
        _$ResponseVerbosityEnumMap,
        json['verbosity'],
      ),
    );

Map<String, dynamic> _$ResponsesTextConfigToJson(
  ResponsesTextConfig instance,
) => <String, dynamic>{
  'format': _formatToJson(instance.format),
  'verbosity': _$ResponseVerbosityEnumMap[instance.verbosity],
};

const _$ResponseVerbosityEnumMap = {
  ResponseVerbosity.high: 'high',
  ResponseVerbosity.medium: 'medium',
  ResponseVerbosity.low: 'low',
};

FormatText _$FormatTextFromJson(Map<String, dynamic> json) => FormatText();

Map<String, dynamic> _$FormatTextToJson(FormatText instance) =>
    <String, dynamic>{};

FormatJsonObject _$FormatJsonObjectFromJson(Map<String, dynamic> json) =>
    FormatJsonObject();

Map<String, dynamic> _$FormatJsonObjectToJson(FormatJsonObject instance) =>
    <String, dynamic>{};

FormatJsonSchema _$FormatJsonSchemaFromJson(Map<String, dynamic> json) =>
    FormatJsonSchema(
      name: json['name'] as String,
      schema: json['schema'] as Map<String, dynamic>,
      description: json['description'] as String?,
      strict: json['strict'] as bool?,
    );

Map<String, dynamic> _$FormatJsonSchemaToJson(FormatJsonSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'schema': instance.schema,
      'strict': instance.strict,
    };

ResponsesReasoningConfig _$ResponsesReasoningConfigFromJson(
  Map<String, dynamic> json,
) => ResponsesReasoningConfig(
  effort: $enumDecodeNullable(_$ReasoningEffortEnumMap, json['effort']),
  summary: $enumDecodeNullable(
    _$ReasoningSummaryVerbosityEnumMap,
    json['summary'],
  ),
  maxTokens: (json['max_tokens'] as num?)?.toDouble(),
  enabled: json['enabled'] as bool?,
);

Map<String, dynamic> _$ResponsesReasoningConfigToJson(
  ResponsesReasoningConfig instance,
) => <String, dynamic>{
  'effort': _$ReasoningEffortEnumMap[instance.effort],
  'summary': _$ReasoningSummaryVerbosityEnumMap[instance.summary],
  'max_tokens': instance.maxTokens,
  'enabled': instance.enabled,
};

const _$ReasoningEffortEnumMap = {
  ReasoningEffort.xhigh: 'xhigh',
  ReasoningEffort.high: 'high',
  ReasoningEffort.medium: 'medium',
  ReasoningEffort.low: 'low',
  ReasoningEffort.minimal: 'minimal',
  ReasoningEffort.none: 'none',
};

const _$ReasoningSummaryVerbosityEnumMap = {
  ReasoningSummaryVerbosity.auto: 'auto',
  ReasoningSummaryVerbosity.concise: 'concise',
  ReasoningSummaryVerbosity.detailed: 'detailed',
};

ResponsesFunctionTool _$ResponsesFunctionToolFromJson(
  Map<String, dynamic> json,
) => ResponsesFunctionTool(
  name: json['name'] as String,
  description: json['description'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>?,
  strict: json['strict'] as bool?,
);

Map<String, dynamic> _$ResponsesFunctionToolToJson(
  ResponsesFunctionTool instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'parameters': instance.parameters,
  'strict': instance.strict,
};

WebSearchPreviewTool _$WebSearchPreviewToolFromJson(
  Map<String, dynamic> json,
) => WebSearchPreviewTool(
  searchContextSize: $enumDecodeNullable(
    _$SearchContextSizeEnumMap,
    json['search_context_size'],
  ),
  userLocation: json['user_location'] == null
      ? null
      : UserLocation.fromJson(json['user_location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WebSearchPreviewToolToJson(
  WebSearchPreviewTool instance,
) => <String, dynamic>{
  'search_context_size': _$SearchContextSizeEnumMap[instance.searchContextSize],
  'user_location': instance.userLocation,
};

const _$SearchContextSizeEnumMap = {
  SearchContextSize.low: 'low',
  SearchContextSize.medium: 'medium',
  SearchContextSize.high: 'high',
};

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
  city: json['city'] as String?,
  country: json['country'] as String?,
  region: json['region'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'region': instance.region,
      'timezone': instance.timezone,
    };

ToolChoiceFunction _$ToolChoiceFunctionFromJson(Map<String, dynamic> json) =>
    ToolChoiceFunction(name: json['name'] as String);

Map<String, dynamic> _$ToolChoiceFunctionToJson(ToolChoiceFunction instance) =>
    <String, dynamic>{'name': instance.name};

ResponsesPlugin _$ResponsesPluginFromJson(Map<String, dynamic> json) =>
    ResponsesPlugin(
      id: json['id'] as String,
      enabled: json['enabled'] as bool?,
      maxResults: (json['max_results'] as num?)?.toInt(),
      searchPrompt: json['search_prompt'] as String?,
      engine: json['engine'] as String?,
      pdf: json['pdf'] == null
          ? null
          : PdfOptions.fromJson(json['pdf'] as Map<String, dynamic>),
      allowedModels: (json['allowed_models'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ResponsesPluginToJson(ResponsesPlugin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enabled': instance.enabled,
      'max_results': instance.maxResults,
      'search_prompt': instance.searchPrompt,
      'engine': instance.engine,
      'pdf': instance.pdf,
      'allowed_models': instance.allowedModels,
    };

PdfOptions _$PdfOptionsFromJson(Map<String, dynamic> json) =>
    PdfOptions(engine: json['engine'] as String?);

Map<String, dynamic> _$PdfOptionsToJson(PdfOptions instance) =>
    <String, dynamic>{'engine': instance.engine};

ResponsesPrompt _$ResponsesPromptFromJson(Map<String, dynamic> json) =>
    ResponsesPrompt(
      id: json['id'] as String,
      variables: json['variables'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ResponsesPromptToJson(ResponsesPrompt instance) =>
    <String, dynamic>{'id': instance.id, 'variables': instance.variables};
