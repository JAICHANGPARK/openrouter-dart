// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
  id: json['id'] as String,
  choices: (json['choices'] as List<dynamic>)
      .map((e) => ChatChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  created: (json['created'] as num).toDouble(),
  model: json['model'] as String,
  object: json['object'] as String,
  systemFingerprint: json['system_fingerprint'] as String?,
  usage: json['usage'] == null
      ? null
      : TokenUsage.fromJson(json['usage'] as Map<String, dynamic>),
  provider: json['provider'] as String?,
  debug: json['debug'] == null
      ? null
      : DebugResponse.fromJson(json['debug'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choices': instance.choices,
      'created': instance.created,
      'model': instance.model,
      'object': instance.object,
      'system_fingerprint': instance.systemFingerprint,
      'usage': instance.usage,
      'provider': instance.provider,
      'debug': instance.debug,
    };

ChatChoice _$ChatChoiceFromJson(Map<String, dynamic> json) => ChatChoice(
  finishReason: json['finish_reason'] as String?,
  index: (json['index'] as num).toDouble(),
  message: json['message'] == null
      ? null
      : Message.fromJson(json['message'] as Map<String, dynamic>),
  delta: json['delta'] == null
      ? null
      : DeltaMessage.fromJson(json['delta'] as Map<String, dynamic>),
  logprobs: json['logprobs'] == null
      ? null
      : Logprobs.fromJson(json['logprobs'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ChoiceError.fromJson(json['error'] as Map<String, dynamic>),
  nativeFinishReason: json['native_finish_reason'] as String?,
);

Map<String, dynamic> _$ChatChoiceToJson(ChatChoice instance) =>
    <String, dynamic>{
      'finish_reason': instance.finishReason,
      'index': instance.index,
      'message': instance.message,
      'delta': instance.delta,
      'logprobs': instance.logprobs,
      'error': instance.error,
      'native_finish_reason': instance.nativeFinishReason,
    };

DeltaMessage _$DeltaMessageFromJson(Map<String, dynamic> json) => DeltaMessage(
  content: json['content'] as String?,
  role: json['role'] as String?,
  toolCalls: (json['tool_calls'] as List<dynamic>?)
      ?.map((e) => ToolCall.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DeltaMessageToJson(DeltaMessage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'role': instance.role,
      'tool_calls': instance.toolCalls,
    };

TokenUsage _$TokenUsageFromJson(Map<String, dynamic> json) => TokenUsage(
  promptTokens: (json['prompt_tokens'] as num).toDouble(),
  completionTokens: (json['completion_tokens'] as num).toDouble(),
  totalTokens: (json['total_tokens'] as num).toDouble(),
  promptTokensDetails: json['prompt_tokens_details'] == null
      ? null
      : PromptTokensDetails.fromJson(
          json['prompt_tokens_details'] as Map<String, dynamic>,
        ),
  completionTokensDetails: json['completion_tokens_details'] == null
      ? null
      : CompletionTokensDetails.fromJson(
          json['completion_tokens_details'] as Map<String, dynamic>,
        ),
  cost: (json['cost'] as num?)?.toDouble(),
  isByok: json['is_byok'] as bool?,
  costDetails: json['cost_details'] == null
      ? null
      : CostDetails.fromJson(json['cost_details'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TokenUsageToJson(TokenUsage instance) =>
    <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'completion_tokens': instance.completionTokens,
      'total_tokens': instance.totalTokens,
      'prompt_tokens_details': instance.promptTokensDetails,
      'completion_tokens_details': instance.completionTokensDetails,
      'cost': instance.cost,
      'is_byok': instance.isByok,
      'cost_details': instance.costDetails,
    };

PromptTokensDetails _$PromptTokensDetailsFromJson(Map<String, dynamic> json) =>
    PromptTokensDetails(
      cachedTokens: (json['cached_tokens'] as num).toDouble(),
      cacheWriteTokens: (json['cache_write_tokens'] as num?)?.toDouble(),
      audioTokens: (json['audio_tokens'] as num?)?.toDouble(),
      videoTokens: (json['video_tokens'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PromptTokensDetailsToJson(
  PromptTokensDetails instance,
) => <String, dynamic>{
  'cached_tokens': instance.cachedTokens,
  'cache_write_tokens': instance.cacheWriteTokens,
  'audio_tokens': instance.audioTokens,
  'video_tokens': instance.videoTokens,
};

CompletionTokensDetails _$CompletionTokensDetailsFromJson(
  Map<String, dynamic> json,
) => CompletionTokensDetails(
  reasoningTokens: (json['reasoning_tokens'] as num?)?.toDouble(),
  imageTokens: (json['image_tokens'] as num?)?.toDouble(),
  acceptedPredictionTokens: (json['accepted_prediction_tokens'] as num?)
      ?.toDouble(),
  rejectedPredictionTokens: (json['rejected_prediction_tokens'] as num?)
      ?.toDouble(),
);

Map<String, dynamic> _$CompletionTokensDetailsToJson(
  CompletionTokensDetails instance,
) => <String, dynamic>{
  'reasoning_tokens': instance.reasoningTokens,
  'image_tokens': instance.imageTokens,
  'accepted_prediction_tokens': instance.acceptedPredictionTokens,
  'rejected_prediction_tokens': instance.rejectedPredictionTokens,
};

CostDetails _$CostDetailsFromJson(Map<String, dynamic> json) => CostDetails(
  upstreamInferenceCost: (json['upstream_inference_cost'] as num?)?.toDouble(),
  upstreamInferencePromptCost: (json['upstream_inference_prompt_cost'] as num)
      .toDouble(),
  upstreamInferenceCompletionsCost:
      (json['upstream_inference_completions_cost'] as num).toDouble(),
);

Map<String, dynamic> _$CostDetailsToJson(CostDetails instance) =>
    <String, dynamic>{
      'upstream_inference_cost': instance.upstreamInferenceCost,
      'upstream_inference_prompt_cost': instance.upstreamInferencePromptCost,
      'upstream_inference_completions_cost':
          instance.upstreamInferenceCompletionsCost,
    };

Logprobs _$LogprobsFromJson(Map<String, dynamic> json) => Logprobs(
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => TokenLogprob.fromJson(e as Map<String, dynamic>))
      .toList(),
  refusal: (json['refusal'] as List<dynamic>?)
      ?.map((e) => TokenLogprob.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LogprobsToJson(Logprobs instance) => <String, dynamic>{
  'content': instance.content,
  'refusal': instance.refusal,
};

TokenLogprob _$TokenLogprobFromJson(Map<String, dynamic> json) => TokenLogprob(
  token: json['token'] as String,
  logprob: (json['logprob'] as num).toDouble(),
  bytes: (json['bytes'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  topLogprobs: (json['top_logprobs'] as List<dynamic>)
      .map((e) => TopLogprob.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TokenLogprobToJson(TokenLogprob instance) =>
    <String, dynamic>{
      'token': instance.token,
      'logprob': instance.logprob,
      'bytes': instance.bytes,
      'top_logprobs': instance.topLogprobs,
    };

TopLogprob _$TopLogprobFromJson(Map<String, dynamic> json) => TopLogprob(
  token: json['token'] as String,
  logprob: (json['logprob'] as num).toDouble(),
  bytes: (json['bytes'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$TopLogprobToJson(TopLogprob instance) =>
    <String, dynamic>{
      'token': instance.token,
      'logprob': instance.logprob,
      'bytes': instance.bytes,
    };

ChoiceError _$ChoiceErrorFromJson(Map<String, dynamic> json) => ChoiceError(
  code: json['code'],
  message: json['message'] as String,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ChoiceErrorToJson(ChoiceError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'metadata': instance.metadata,
    };

DebugResponse _$DebugResponseFromJson(Map<String, dynamic> json) =>
    DebugResponse(
      echoUpstreamBody: json['echo_upstream_body'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DebugResponseToJson(DebugResponse instance) =>
    <String, dynamic>{'echo_upstream_body': instance.echoUpstreamBody};
