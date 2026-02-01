// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
  messages: (json['messages'] as List<dynamic>)
      .map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
  model: json['model'] as String?,
  models: (json['models'] as List<dynamic>?)?.map((e) => e as String).toList(),
  frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble(),
  logitBias: (json['logit_bias'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  logprobs: json['logprobs'] as bool?,
  topLogprobs: (json['top_logprobs'] as num?)?.toDouble(),
  maxTokens: (json['max_tokens'] as num?)?.toInt(),
  maxCompletionTokens: (json['max_completion_tokens'] as num?)?.toInt(),
  metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  presencePenalty: (json['presence_penalty'] as num?)?.toDouble(),
  reasoning: json['reasoning'] == null
      ? null
      : ReasoningConfig.fromJson(json['reasoning'] as Map<String, dynamic>),
  responseFormat: json['response_format'] == null
      ? null
      : ResponseFormat.fromJson(
          json['response_format'] as Map<String, dynamic>,
        ),
  seed: (json['seed'] as num?)?.toInt(),
  stop: json['stop'],
  stream: json['stream'] as bool? ?? false,
  streamOptions: json['stream_options'] == null
      ? null
      : StreamOptions.fromJson(json['stream_options'] as Map<String, dynamic>),
  temperature: (json['temperature'] as num?)?.toDouble(),
  toolChoice: json['tool_choice'] == null
      ? null
      : ToolChoice.fromJson(json['tool_choice'] as Map<String, dynamic>),
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => ToolDefinition.fromJson(e as Map<String, dynamic>))
      .toList(),
  topP: (json['top_p'] as num?)?.toDouble(),
  topK: (json['top_k'] as num?)?.toInt(),
  user: json['user'] as String?,
  provider: json['provider'] == null
      ? null
      : ProviderPreferences.fromJson(json['provider'] as Map<String, dynamic>),
  plugins: (json['plugins'] as List<dynamic>?)
      ?.map((e) => Plugin.fromJson(e as Map<String, dynamic>))
      .toList(),
  route: json['route'] as String?,
  debug: json['debug'] == null
      ? null
      : DebugOptions.fromJson(json['debug'] as Map<String, dynamic>),
  imageConfig: json['image_config'] as Map<String, dynamic>?,
  modalities: (json['modalities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  transforms: (json['transforms'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  minP: (json['min_p'] as num?)?.toDouble(),
  topA: (json['top_a'] as num?)?.toDouble(),
  repetitionPenalty: (json['repetition_penalty'] as num?)?.toDouble(),
  prediction: json['prediction'] == null
      ? null
      : Prediction.fromJson(json['prediction'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'model': instance.model,
      'models': instance.models,
      'frequency_penalty': instance.frequencyPenalty,
      'logit_bias': instance.logitBias,
      'logprobs': instance.logprobs,
      'top_logprobs': instance.topLogprobs,
      'max_tokens': instance.maxTokens,
      'max_completion_tokens': instance.maxCompletionTokens,
      'metadata': instance.metadata,
      'presence_penalty': instance.presencePenalty,
      'reasoning': instance.reasoning,
      'response_format': instance.responseFormat,
      'seed': instance.seed,
      'stop': instance.stop,
      'stream': instance.stream,
      'stream_options': instance.streamOptions,
      'temperature': instance.temperature,
      'tool_choice': instance.toolChoice,
      'tools': instance.tools,
      'top_p': instance.topP,
      'top_k': instance.topK,
      'user': instance.user,
      'provider': instance.provider,
      'plugins': instance.plugins,
      'route': instance.route,
      'debug': instance.debug,
      'image_config': instance.imageConfig,
      'modalities': instance.modalities,
      'transforms': instance.transforms,
      'min_p': instance.minP,
      'top_a': instance.topA,
      'repetition_penalty': instance.repetitionPenalty,
      'prediction': instance.prediction,
    };

ReasoningConfig _$ReasoningConfigFromJson(Map<String, dynamic> json) =>
    ReasoningConfig(
      effort: $enumDecodeNullable(_$ReasoningEffortEnumMap, json['effort']),
      summary: $enumDecodeNullable(_$ReasoningSummaryEnumMap, json['summary']),
      maxTokens: (json['max_tokens'] as num?)?.toInt(),
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$ReasoningConfigToJson(ReasoningConfig instance) =>
    <String, dynamic>{
      'effort': _$ReasoningEffortEnumMap[instance.effort],
      'summary': _$ReasoningSummaryEnumMap[instance.summary],
      'max_tokens': instance.maxTokens,
      'enabled': instance.enabled,
    };

const _$ReasoningEffortEnumMap = {
  ReasoningEffort.minimal: 'minimal',
  ReasoningEffort.low: 'low',
  ReasoningEffort.medium: 'medium',
  ReasoningEffort.high: 'high',
  ReasoningEffort.xhigh: 'xhigh',
  ReasoningEffort.none: 'none',
};

const _$ReasoningSummaryEnumMap = {
  ReasoningSummary.auto: 'auto',
  ReasoningSummary.concise: 'concise',
  ReasoningSummary.detailed: 'detailed',
};

ResponseFormat _$ResponseFormatFromJson(Map<String, dynamic> json) =>
    ResponseFormat(
      type: json['type'] as String,
      jsonSchema: json['json_schema'] == null
          ? null
          : JsonSchemaConfig.fromJson(
              json['json_schema'] as Map<String, dynamic>,
            ),
      grammar: json['grammar'] as String?,
    );

Map<String, dynamic> _$ResponseFormatToJson(ResponseFormat instance) =>
    <String, dynamic>{
      'type': instance.type,
      'json_schema': instance.jsonSchema,
      'grammar': instance.grammar,
    };

JsonSchemaConfig _$JsonSchemaConfigFromJson(Map<String, dynamic> json) =>
    JsonSchemaConfig(
      name: json['name'] as String,
      schema: json['schema'] as Map<String, dynamic>,
      description: json['description'] as String?,
      strict: json['strict'] as bool?,
    );

Map<String, dynamic> _$JsonSchemaConfigToJson(JsonSchemaConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'schema': instance.schema,
      'description': instance.description,
      'strict': instance.strict,
    };

StreamOptions _$StreamOptionsFromJson(Map<String, dynamic> json) =>
    StreamOptions(includeUsage: json['include_usage'] as bool? ?? false);

Map<String, dynamic> _$StreamOptionsToJson(StreamOptions instance) =>
    <String, dynamic>{'include_usage': instance.includeUsage};

ToolChoice _$ToolChoiceFromJson(Map<String, dynamic> json) => ToolChoice(
  type: json['type'] as String?,
  function: json['function'] == null
      ? null
      : ToolChoiceFunction.fromJson(json['function'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ToolChoiceToJson(ToolChoice instance) =>
    <String, dynamic>{'type': instance.type, 'function': instance.function};

ToolChoiceFunction _$ToolChoiceFunctionFromJson(Map<String, dynamic> json) =>
    ToolChoiceFunction(name: json['name'] as String);

Map<String, dynamic> _$ToolChoiceFunctionToJson(ToolChoiceFunction instance) =>
    <String, dynamic>{'name': instance.name};

ToolDefinition _$ToolDefinitionFromJson(Map<String, dynamic> json) =>
    ToolDefinition(
      type: json['type'] as String? ?? 'function',
      function: FunctionDefinition.fromJson(
        json['function'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ToolDefinitionToJson(ToolDefinition instance) =>
    <String, dynamic>{'type': instance.type, 'function': instance.function};

FunctionDefinition _$FunctionDefinitionFromJson(Map<String, dynamic> json) =>
    FunctionDefinition(
      name: json['name'] as String,
      description: json['description'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
      strict: json['strict'] as bool?,
    );

Map<String, dynamic> _$FunctionDefinitionToJson(FunctionDefinition instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'parameters': instance.parameters,
      'strict': instance.strict,
    };

ProviderPreferences _$ProviderPreferencesFromJson(
  Map<String, dynamic> json,
) => ProviderPreferences(
  allowFallbacks: json['allow_fallbacks'] as bool?,
  requireParameters: json['require_parameters'] as bool?,
  dataCollection: $enumDecodeNullable(
    _$DataCollectionEnumMap,
    json['data_collection'],
  ),
  zdr: json['zdr'] as bool?,
  enforceDistillableText: json['enforce_distillable_text'] as bool?,
  order: (json['order'] as List<dynamic>?)?.map((e) => e as String).toList(),
  only: (json['only'] as List<dynamic>?)?.map((e) => e as String).toList(),
  ignore: (json['ignore'] as List<dynamic>?)?.map((e) => e as String).toList(),
  quantizations: (json['quantizations'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sort: json['sort'],
  maxPrice: json['max_price'] == null
      ? null
      : MaxPrice.fromJson(json['max_price'] as Map<String, dynamic>),
  preferredMinThroughput: json['preferred_min_throughput'],
  preferredMaxLatency: json['preferred_max_latency'],
);

Map<String, dynamic> _$ProviderPreferencesToJson(
  ProviderPreferences instance,
) => <String, dynamic>{
  'allow_fallbacks': instance.allowFallbacks,
  'require_parameters': instance.requireParameters,
  'data_collection': _$DataCollectionEnumMap[instance.dataCollection],
  'zdr': instance.zdr,
  'enforce_distillable_text': instance.enforceDistillableText,
  'order': instance.order,
  'only': instance.only,
  'ignore': instance.ignore,
  'quantizations': instance.quantizations,
  'sort': instance.sort,
  'max_price': instance.maxPrice,
  'preferred_min_throughput': instance.preferredMinThroughput,
  'preferred_max_latency': instance.preferredMaxLatency,
};

const _$DataCollectionEnumMap = {
  DataCollection.deny: 'deny',
  DataCollection.allow: 'allow',
};

MaxPrice _$MaxPriceFromJson(Map<String, dynamic> json) => MaxPrice(
  prompt: json['prompt'],
  completion: json['completion'],
  image: json['image'],
  audio: json['audio'],
  request: json['request'],
);

Map<String, dynamic> _$MaxPriceToJson(MaxPrice instance) => <String, dynamic>{
  'prompt': instance.prompt,
  'completion': instance.completion,
  'image': instance.image,
  'audio': instance.audio,
  'request': instance.request,
};

Plugin _$PluginFromJson(Map<String, dynamic> json) => Plugin(
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

Map<String, dynamic> _$PluginToJson(Plugin instance) => <String, dynamic>{
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

DebugOptions _$DebugOptionsFromJson(Map<String, dynamic> json) =>
    DebugOptions(echoUpstreamBody: json['echo_upstream_body'] as bool?);

Map<String, dynamic> _$DebugOptionsToJson(DebugOptions instance) =>
    <String, dynamic>{'echo_upstream_body': instance.echoUpstreamBody};

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
  type: json['type'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{'type': instance.type, 'content': instance.content};
