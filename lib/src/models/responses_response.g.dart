// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsesResponse _$ResponsesResponseFromJson(Map<String, dynamic> json) =>
    ResponsesResponse(
      id: json['id'] as String,
      object: json['object'] as String,
      createdAt: (json['created_at'] as num).toDouble(),
      model: json['model'] as String,
      status: $enumDecode(_$ResponseStatusEnumMap, json['status']),
      completedAt: (json['completed_at'] as num?)?.toDouble(),
      output: _outputFromJson(json['output'] as List),
      user: json['user'] as String?,
      outputText: json['output_text'] as String?,
      promptCacheKey: json['prompt_cache_key'] as String?,
      safetyIdentifier: json['safety_identifier'] as String?,
      error: json['error'] == null
          ? null
          : ResponseError.fromJson(json['error'] as Map<String, dynamic>),
      incompleteDetails: json['incomplete_details'] == null
          ? null
          : IncompleteDetails.fromJson(
              json['incomplete_details'] as Map<String, dynamic>,
            ),
      usage: json['usage'] == null
          ? null
          : ResponsesUsage.fromJson(json['usage'] as Map<String, dynamic>),
      maxToolCalls: (json['max_tool_calls'] as num?)?.toDouble(),
      topLogprobs: (json['top_logprobs'] as num?)?.toDouble(),
      maxOutputTokens: (json['max_output_tokens'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      topP: (json['top_p'] as num?)?.toDouble(),
      presencePenalty: (json['presence_penalty'] as num?)?.toDouble(),
      frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble(),
      instructions: json['instructions'],
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      tools: json['tools'] as List<dynamic>?,
      toolChoice: json['tool_choice'],
      parallelToolCalls: json['parallel_tool_calls'] as bool?,
      prompt: json['prompt'],
      background: json['background'] as bool?,
      previousResponseId: json['previous_response_id'] as String?,
      reasoning: json['reasoning'],
      serviceTier: json['service_tier'] as String?,
      store: json['store'] as bool?,
      truncation: json['truncation'],
      text: json['text'],
    );

Map<String, dynamic> _$ResponsesResponseToJson(ResponsesResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created_at': instance.createdAt,
      'model': instance.model,
      'status': _$ResponseStatusEnumMap[instance.status]!,
      'completed_at': instance.completedAt,
      'output': _outputToJson(instance.output),
      'user': instance.user,
      'output_text': instance.outputText,
      'prompt_cache_key': instance.promptCacheKey,
      'safety_identifier': instance.safetyIdentifier,
      'error': instance.error,
      'incomplete_details': instance.incompleteDetails,
      'usage': instance.usage,
      'max_tool_calls': instance.maxToolCalls,
      'top_logprobs': instance.topLogprobs,
      'max_output_tokens': instance.maxOutputTokens,
      'temperature': instance.temperature,
      'top_p': instance.topP,
      'presence_penalty': instance.presencePenalty,
      'frequency_penalty': instance.frequencyPenalty,
      'instructions': instance.instructions,
      'metadata': instance.metadata,
      'tools': instance.tools,
      'tool_choice': instance.toolChoice,
      'parallel_tool_calls': instance.parallelToolCalls,
      'prompt': instance.prompt,
      'background': instance.background,
      'previous_response_id': instance.previousResponseId,
      'reasoning': instance.reasoning,
      'service_tier': instance.serviceTier,
      'store': instance.store,
      'truncation': instance.truncation,
      'text': instance.text,
    };

const _$ResponseStatusEnumMap = {
  ResponseStatus.completed: 'completed',
  ResponseStatus.incomplete: 'incomplete',
  ResponseStatus.inProgress: 'in_progress',
  ResponseStatus.failed: 'failed',
  ResponseStatus.cancelled: 'cancelled',
  ResponseStatus.queued: 'queued',
};

OutputMessage _$OutputMessageFromJson(Map<String, dynamic> json) =>
    OutputMessage(
      id: json['id'] as String,
      role: json['role'] as String,
      content: _contentFromJson(json['content'] as List),
      status: $enumDecodeNullable(_$OutputStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$OutputMessageToJson(OutputMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': _contentToJson(instance.content),
      'status': _$OutputStatusEnumMap[instance.status],
    };

const _$OutputStatusEnumMap = {
  OutputStatus.completed: 'completed',
  OutputStatus.incomplete: 'incomplete',
  OutputStatus.inProgress: 'in_progress',
};

OutputText _$OutputTextFromJson(Map<String, dynamic> json) => OutputText(
  text: json['text'] as String,
  annotations: _annotationsFromJson(json['annotations'] as List?),
  logprobs: (json['logprobs'] as List<dynamic>?)
      ?.map((e) => LogprobItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OutputTextToJson(OutputText instance) =>
    <String, dynamic>{
      'text': instance.text,
      'annotations': _annotationsToJson(instance.annotations),
      'logprobs': instance.logprobs,
    };

OutputRefusal _$OutputRefusalFromJson(Map<String, dynamic> json) =>
    OutputRefusal(refusal: json['refusal'] as String);

Map<String, dynamic> _$OutputRefusalToJson(OutputRefusal instance) =>
    <String, dynamic>{'refusal': instance.refusal};

UrlCitation _$UrlCitationFromJson(Map<String, dynamic> json) => UrlCitation(
  url: json['url'] as String,
  title: json['title'] as String,
  startIndex: (json['start_index'] as num).toDouble(),
  endIndex: (json['end_index'] as num).toDouble(),
);

Map<String, dynamic> _$UrlCitationToJson(UrlCitation instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'start_index': instance.startIndex,
      'end_index': instance.endIndex,
    };

FileCitation _$FileCitationFromJson(Map<String, dynamic> json) => FileCitation(
  fileId: json['file_id'] as String,
  filename: json['filename'] as String,
  index: (json['index'] as num).toDouble(),
);

Map<String, dynamic> _$FileCitationToJson(FileCitation instance) =>
    <String, dynamic>{
      'file_id': instance.fileId,
      'filename': instance.filename,
      'index': instance.index,
    };

FilePath _$FilePathFromJson(Map<String, dynamic> json) => FilePath(
  fileId: json['file_id'] as String,
  index: (json['index'] as num).toDouble(),
);

Map<String, dynamic> _$FilePathToJson(FilePath instance) => <String, dynamic>{
  'file_id': instance.fileId,
  'index': instance.index,
};

LogprobItem _$LogprobItemFromJson(Map<String, dynamic> json) => LogprobItem(
  token: json['token'] as String,
  bytes: (json['bytes'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  logprob: (json['logprob'] as num).toDouble(),
  topLogprobs: (json['top_logprobs'] as List<dynamic>)
      .map((e) => TopLogprob.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LogprobItemToJson(LogprobItem instance) =>
    <String, dynamic>{
      'token': instance.token,
      'bytes': instance.bytes,
      'logprob': instance.logprob,
      'top_logprobs': instance.topLogprobs,
    };

TopLogprob _$TopLogprobFromJson(Map<String, dynamic> json) => TopLogprob(
  token: json['token'] as String,
  bytes: (json['bytes'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  logprob: (json['logprob'] as num).toDouble(),
);

Map<String, dynamic> _$TopLogprobToJson(TopLogprob instance) =>
    <String, dynamic>{
      'token': instance.token,
      'bytes': instance.bytes,
      'logprob': instance.logprob,
    };

OutputReasoning _$OutputReasoningFromJson(Map<String, dynamic> json) =>
    OutputReasoning(
      id: json['id'] as String,
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => ReasoningContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: (json['summary'] as List<dynamic>?)
          ?.map((e) => ReasoningSummaryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      encryptedContent: json['encrypted_content'] as String?,
      status: $enumDecodeNullable(_$OutputStatusEnumMap, json['status']),
      signature: json['signature'] as String?,
      format: json['format'] as String?,
    );

Map<String, dynamic> _$OutputReasoningToJson(OutputReasoning instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'summary': instance.summary,
      'encrypted_content': instance.encryptedContent,
      'status': _$OutputStatusEnumMap[instance.status],
      'signature': instance.signature,
      'format': instance.format,
    };

ReasoningContent _$ReasoningContentFromJson(Map<String, dynamic> json) =>
    ReasoningContent(text: json['text'] as String);

Map<String, dynamic> _$ReasoningContentToJson(ReasoningContent instance) =>
    <String, dynamic>{'text': instance.text};

ReasoningSummaryItem _$ReasoningSummaryItemFromJson(
  Map<String, dynamic> json,
) => ReasoningSummaryItem(text: json['text'] as String);

Map<String, dynamic> _$ReasoningSummaryItemToJson(
  ReasoningSummaryItem instance,
) => <String, dynamic>{'text': instance.text};

OutputFunctionCall _$OutputFunctionCallFromJson(Map<String, dynamic> json) =>
    OutputFunctionCall(
      id: json['id'] as String,
      name: json['name'] as String,
      arguments: json['arguments'] as String,
      callId: json['call_id'] as String,
      status: $enumDecodeNullable(_$OutputStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$OutputFunctionCallToJson(OutputFunctionCall instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'arguments': instance.arguments,
      'call_id': instance.callId,
      'status': _$OutputStatusEnumMap[instance.status],
    };

OutputWebSearchCall _$OutputWebSearchCallFromJson(Map<String, dynamic> json) =>
    OutputWebSearchCall(
      id: json['id'] as String,
      status: $enumDecode(_$WebSearchCallStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$OutputWebSearchCallToJson(
  OutputWebSearchCall instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$WebSearchCallStatusEnumMap[instance.status]!,
};

const _$WebSearchCallStatusEnumMap = {
  WebSearchCallStatus.completed: 'completed',
  WebSearchCallStatus.searching: 'searching',
  WebSearchCallStatus.inProgress: 'in_progress',
  WebSearchCallStatus.failed: 'failed',
};

OutputFileSearchCall _$OutputFileSearchCallFromJson(
  Map<String, dynamic> json,
) => OutputFileSearchCall(
  id: json['id'] as String,
  queries: (json['queries'] as List<dynamic>).map((e) => e as String).toList(),
  status: $enumDecode(_$WebSearchCallStatusEnumMap, json['status']),
);

Map<String, dynamic> _$OutputFileSearchCallToJson(
  OutputFileSearchCall instance,
) => <String, dynamic>{
  'id': instance.id,
  'queries': instance.queries,
  'status': _$WebSearchCallStatusEnumMap[instance.status]!,
};

OutputImageGenerationCall _$OutputImageGenerationCallFromJson(
  Map<String, dynamic> json,
) => OutputImageGenerationCall(
  id: json['id'] as String,
  result: json['result'] as String?,
  status: $enumDecode(_$ImageGenerationStatusEnumMap, json['status']),
);

Map<String, dynamic> _$OutputImageGenerationCallToJson(
  OutputImageGenerationCall instance,
) => <String, dynamic>{
  'id': instance.id,
  'result': instance.result,
  'status': _$ImageGenerationStatusEnumMap[instance.status]!,
};

const _$ImageGenerationStatusEnumMap = {
  ImageGenerationStatus.inProgress: 'in_progress',
  ImageGenerationStatus.completed: 'completed',
  ImageGenerationStatus.generating: 'generating',
  ImageGenerationStatus.failed: 'failed',
};

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) =>
    ResponseError(
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ResponseErrorToJson(ResponseError instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

IncompleteDetails _$IncompleteDetailsFromJson(Map<String, dynamic> json) =>
    IncompleteDetails(reason: json['reason'] as String);

Map<String, dynamic> _$IncompleteDetailsToJson(IncompleteDetails instance) =>
    <String, dynamic>{'reason': instance.reason};

ResponsesUsage _$ResponsesUsageFromJson(Map<String, dynamic> json) =>
    ResponsesUsage(
      inputTokens: (json['input_tokens'] as num).toDouble(),
      outputTokens: (json['output_tokens'] as num).toDouble(),
      totalTokens: (json['total_tokens'] as num).toDouble(),
      inputTokensDetails: json['input_tokens_details'] == null
          ? null
          : InputTokensDetails.fromJson(
              json['input_tokens_details'] as Map<String, dynamic>,
            ),
      outputTokensDetails: json['output_tokens_details'] == null
          ? null
          : OutputTokensDetails.fromJson(
              json['output_tokens_details'] as Map<String, dynamic>,
            ),
      cost: (json['cost'] as num?)?.toDouble(),
      isByok: json['is_byok'] as bool?,
      costDetails: json['cost_details'] == null
          ? null
          : CostDetails.fromJson(json['cost_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponsesUsageToJson(ResponsesUsage instance) =>
    <String, dynamic>{
      'input_tokens': instance.inputTokens,
      'output_tokens': instance.outputTokens,
      'total_tokens': instance.totalTokens,
      'input_tokens_details': instance.inputTokensDetails,
      'output_tokens_details': instance.outputTokensDetails,
      'cost': instance.cost,
      'is_byok': instance.isByok,
      'cost_details': instance.costDetails,
    };

InputTokensDetails _$InputTokensDetailsFromJson(Map<String, dynamic> json) =>
    InputTokensDetails(cachedTokens: (json['cached_tokens'] as num).toDouble());

Map<String, dynamic> _$InputTokensDetailsToJson(InputTokensDetails instance) =>
    <String, dynamic>{'cached_tokens': instance.cachedTokens};

OutputTokensDetails _$OutputTokensDetailsFromJson(Map<String, dynamic> json) =>
    OutputTokensDetails(
      reasoningTokens: (json['reasoning_tokens'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OutputTokensDetailsToJson(
  OutputTokensDetails instance,
) => <String, dynamic>{'reasoning_tokens': instance.reasoningTokens};

CostDetails _$CostDetailsFromJson(Map<String, dynamic> json) => CostDetails(
  upstreamInferenceCost: (json['upstream_inference_cost'] as num?)?.toDouble(),
  upstreamInferenceInputCost: (json['upstream_inference_input_cost'] as num)
      .toDouble(),
  upstreamInferenceOutputCost: (json['upstream_inference_output_cost'] as num)
      .toDouble(),
);

Map<String, dynamic> _$CostDetailsToJson(CostDetails instance) =>
    <String, dynamic>{
      'upstream_inference_cost': instance.upstreamInferenceCost,
      'upstream_inference_input_cost': instance.upstreamInferenceInputCost,
      'upstream_inference_output_cost': instance.upstreamInferenceOutputCost,
    };
