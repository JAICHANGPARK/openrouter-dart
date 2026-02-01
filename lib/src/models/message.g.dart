// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextContentItem _$TextContentItemFromJson(Map<String, dynamic> json) =>
    TextContentItem(
      text: json['text'] as String,
      cacheControl: json['cache_control'] == null
          ? null
          : CacheControl.fromJson(
              json['cache_control'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TextContentItemToJson(TextContentItem instance) =>
    <String, dynamic>{
      'text': instance.text,
      'cache_control': instance.cacheControl,
    };

ImageContentItem _$ImageContentItemFromJson(Map<String, dynamic> json) =>
    ImageContentItem(
      imageUrl: ImageUrl.fromJson(json['image_url'] as Map<String, dynamic>),
      detail:
          $enumDecodeNullable(_$ImageDetailEnumMap, json['detail']) ??
          ImageDetail.auto,
    );

Map<String, dynamic> _$ImageContentItemToJson(ImageContentItem instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'detail': _$ImageDetailEnumMap[instance.detail]!,
    };

const _$ImageDetailEnumMap = {
  ImageDetail.auto: 'auto',
  ImageDetail.low: 'low',
  ImageDetail.high: 'high',
};

AudioContentItem _$AudioContentItemFromJson(Map<String, dynamic> json) =>
    AudioContentItem(
      inputAudio: InputAudio.fromJson(
        json['input_audio'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AudioContentItemToJson(AudioContentItem instance) =>
    <String, dynamic>{'input_audio': instance.inputAudio};

VideoContentItem _$VideoContentItemFromJson(Map<String, dynamic> json) =>
    VideoContentItem(
      videoUrl: VideoUrl.fromJson(json['video_url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoContentItemToJson(VideoContentItem instance) =>
    <String, dynamic>{'video_url': instance.videoUrl};

ImageUrl _$ImageUrlFromJson(Map<String, dynamic> json) => ImageUrl(
  url: json['url'] as String,
  detail:
      $enumDecodeNullable(_$ImageDetailEnumMap, json['detail']) ??
      ImageDetail.auto,
);

Map<String, dynamic> _$ImageUrlToJson(ImageUrl instance) => <String, dynamic>{
  'url': instance.url,
  'detail': _$ImageDetailEnumMap[instance.detail]!,
};

InputAudio _$InputAudioFromJson(Map<String, dynamic> json) =>
    InputAudio(data: json['data'] as String, format: json['format'] as String);

Map<String, dynamic> _$InputAudioToJson(InputAudio instance) =>
    <String, dynamic>{'data': instance.data, 'format': instance.format};

VideoUrl _$VideoUrlFromJson(Map<String, dynamic> json) =>
    VideoUrl(url: json['url'] as String);

Map<String, dynamic> _$VideoUrlToJson(VideoUrl instance) => <String, dynamic>{
  'url': instance.url,
};

CacheControl _$CacheControlFromJson(Map<String, dynamic> json) => CacheControl(
  type: json['type'] as String? ?? 'ephemeral',
  ttl: json['ttl'] as String?,
);

Map<String, dynamic> _$CacheControlToJson(CacheControl instance) =>
    <String, dynamic>{'type': instance.type, 'ttl': instance.ttl};

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  role: $enumDecode(_$MessageRoleEnumMap, json['role']),
  content: json['content'],
  name: json['name'] as String?,
  toolCallId: json['tool_call_id'] as String?,
  toolCalls: (json['tool_calls'] as List<dynamic>?)
      ?.map((e) => ToolCall.fromJson(e as Map<String, dynamic>))
      .toList(),
  refusal: json['refusal'] as String?,
  reasoning: json['reasoning'] as String?,
  reasoningDetails: (json['reasoning_details'] as List<dynamic>?)
      ?.map((e) => ReasoningDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => ImageGeneration.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'role': _$MessageRoleEnumMap[instance.role]!,
  'content': instance.content,
  'name': instance.name,
  'tool_call_id': instance.toolCallId,
  'tool_calls': instance.toolCalls,
  'refusal': instance.refusal,
  'reasoning': instance.reasoning,
  'reasoning_details': instance.reasoningDetails,
  'images': instance.images,
};

const _$MessageRoleEnumMap = {
  MessageRole.system: 'system',
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.tool: 'tool',
  MessageRole.developer: 'developer',
};

ToolCall _$ToolCallFromJson(Map<String, dynamic> json) => ToolCall(
  id: json['id'] as String,
  type: json['type'] as String,
  function: FunctionCall.fromJson(json['function'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ToolCallToJson(ToolCall instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'function': instance.function,
};

FunctionCall _$FunctionCallFromJson(Map<String, dynamic> json) => FunctionCall(
  name: json['name'] as String,
  arguments: json['arguments'] as String,
);

Map<String, dynamic> _$FunctionCallToJson(FunctionCall instance) =>
    <String, dynamic>{'name': instance.name, 'arguments': instance.arguments};

ReasoningDetail _$ReasoningDetailFromJson(Map<String, dynamic> json) =>
    ReasoningDetail(
      type: json['type'] as String,
      summary: json['summary'] as String?,
      data: json['data'] as String?,
      text: json['text'] as String?,
      signature: json['signature'] as String?,
      id: json['id'] as String?,
      format: json['format'] as String?,
      index: (json['index'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReasoningDetailToJson(ReasoningDetail instance) =>
    <String, dynamic>{
      'type': instance.type,
      'summary': instance.summary,
      'data': instance.data,
      'text': instance.text,
      'signature': instance.signature,
      'id': instance.id,
      'format': instance.format,
      'index': instance.index,
    };

ImageGeneration _$ImageGenerationFromJson(Map<String, dynamic> json) =>
    ImageGeneration(
      imageUrl: ImageUrl.fromJson(json['image_url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImageGenerationToJson(ImageGeneration instance) =>
    <String, dynamic>{'image_url': instance.imageUrl};
