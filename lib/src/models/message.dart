import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'message.g.dart';

/// Role of a message in the conversation.
@JsonEnum(valueField: 'value')
enum MessageRole {
  /// System message for setting behavior.
  system('system'),

  /// User message.
  user('user'),

  /// Assistant message.
  assistant('assistant'),

  /// Tool response message.
  tool('tool'),

  /// Developer message (for o1 models).
  developer('developer');

  const MessageRole(this.value);

  /// The string value of the role.
  final String value;
}

/// Base class for message content items.
@immutable
sealed class ContentItem {
  const ContentItem();

  /// The type of content.
  String get type;
}

/// Text content item.
@JsonSerializable()
class TextContentItem extends ContentItem {
  const TextContentItem({required this.text, this.cacheControl});

  factory TextContentItem.fromJson(Map<String, dynamic> json) =>
      _$TextContentItemFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type = 'text';

  /// The text content.
  final String text;

  /// Cache control settings.
  @JsonKey(name: 'cache_control')
  final CacheControl? cacheControl;

  Map<String, dynamic> toJson() => _$TextContentItemToJson(this);
}

/// Image content item.
@JsonSerializable()
class ImageContentItem extends ContentItem {
  const ImageContentItem({
    required this.imageUrl,
    this.detail = ImageDetail.auto,
  });

  factory ImageContentItem.fromJson(Map<String, dynamic> json) =>
      _$ImageContentItemFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type = 'image_url';

  /// The image URL or base64 data.
  @JsonKey(name: 'image_url')
  final ImageUrl imageUrl;

  /// Detail level for the image.
  final ImageDetail detail;

  Map<String, dynamic> toJson() => _$ImageContentItemToJson(this);
}

/// Audio content item.
@JsonSerializable()
class AudioContentItem extends ContentItem {
  const AudioContentItem({required this.inputAudio});

  factory AudioContentItem.fromJson(Map<String, dynamic> json) =>
      _$AudioContentItemFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type = 'input_audio';

  /// The audio data.
  @JsonKey(name: 'input_audio')
  final InputAudio inputAudio;

  Map<String, dynamic> toJson() => _$AudioContentItemToJson(this);
}

/// Video content item.
@JsonSerializable()
class VideoContentItem extends ContentItem {
  const VideoContentItem({required this.videoUrl});

  factory VideoContentItem.fromJson(Map<String, dynamic> json) =>
      _$VideoContentItemFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type = 'input_video';

  /// The video URL or base64 data.
  @JsonKey(name: 'video_url')
  final VideoUrl videoUrl;

  Map<String, dynamic> toJson() => _$VideoContentItemToJson(this);
}

/// Image detail level.
@JsonEnum(valueField: 'value')
enum ImageDetail {
  /// Automatically determine detail level.
  auto('auto'),

  /// Low detail (faster, cheaper).
  low('low'),

  /// High detail (more accurate, slower).
  high('high');

  const ImageDetail(this.value);
  final String value;
}

/// Image URL configuration.
@JsonSerializable()
class ImageUrl {
  const ImageUrl({required this.url, this.detail = ImageDetail.auto});

  factory ImageUrl.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlFromJson(json);

  /// The URL or base64 encoded image data.
  final String url;

  /// The detail level.
  final ImageDetail detail;

  Map<String, dynamic> toJson() => _$ImageUrlToJson(this);
}

/// Input audio configuration.
@JsonSerializable()
class InputAudio {
  const InputAudio({required this.data, required this.format});

  factory InputAudio.fromJson(Map<String, dynamic> json) =>
      _$InputAudioFromJson(json);

  /// Base64 encoded audio data.
  final String data;

  /// Audio format (e.g., 'mp3', 'wav').
  final String format;

  Map<String, dynamic> toJson() => _$InputAudioToJson(this);
}

/// Video URL configuration.
@JsonSerializable()
class VideoUrl {
  const VideoUrl({required this.url});

  factory VideoUrl.fromJson(Map<String, dynamic> json) =>
      _$VideoUrlFromJson(json);

  /// The URL or base64 encoded video data.
  final String url;

  Map<String, dynamic> toJson() => _$VideoUrlToJson(this);
}

/// Cache control settings.
@JsonSerializable()
class CacheControl {
  const CacheControl({this.type = 'ephemeral', this.ttl});

  factory CacheControl.fromJson(Map<String, dynamic> json) =>
      _$CacheControlFromJson(json);

  /// Type of cache control.
  final String type;

  /// Time-to-live for cached content.
  final String? ttl;

  Map<String, dynamic> toJson() => _$CacheControlToJson(this);
}

/// Chat message.
@JsonSerializable()
class Message {
  const Message({
    required this.role,
    required this.content,
    this.name,
    this.toolCallId,
    this.toolCalls,
    this.refusal,
    this.reasoning,
    this.reasoningDetails,
    this.images,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// The role of the message author.
  final MessageRole role;

  /// The content of the message (can be String or List<ContentItem>).
  final dynamic content;

  /// Optional name for the message author.
  final String? name;

  /// Tool call ID for tool response messages.
  @JsonKey(name: 'tool_call_id')
  final String? toolCallId;

  /// Tool calls made by the assistant.
  @JsonKey(name: 'tool_calls')
  final List<ToolCall>? toolCalls;

  /// Refusal message from the model.
  final String? refusal;

  /// Reasoning content from the model.
  final String? reasoning;

  /// Detailed reasoning information.
  @JsonKey(name: 'reasoning_details')
  final List<ReasoningDetail>? reasoningDetails;

  /// Images generated by the model.
  final List<ImageGeneration>? images;

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// Helper to create a user text message.
  static Message user(String content) =>
      Message(role: MessageRole.user, content: content);

  /// Helper to create a system message.
  static Message system(String content) =>
      Message(role: MessageRole.system, content: content);

  /// Helper to create an assistant message.
  static Message assistant(String content) =>
      Message(role: MessageRole.assistant, content: content);
}

/// Tool call made by the assistant.
@JsonSerializable()
class ToolCall {
  const ToolCall({
    required this.id,
    required this.type,
    required this.function,
  });

  factory ToolCall.fromJson(Map<String, dynamic> json) =>
      _$ToolCallFromJson(json);

  /// The ID of the tool call.
  final String id;

  /// The type of tool call (always 'function').
  final String type;

  /// The function call details.
  final FunctionCall function;

  Map<String, dynamic> toJson() => _$ToolCallToJson(this);
}

/// Function call details.
@JsonSerializable()
class FunctionCall {
  const FunctionCall({required this.name, required this.arguments});

  factory FunctionCall.fromJson(Map<String, dynamic> json) =>
      _$FunctionCallFromJson(json);

  /// The name of the function.
  final String name;

  /// The arguments to pass to the function (JSON string).
  final String arguments;

  Map<String, dynamic> toJson() => _$FunctionCallToJson(this);
}

/// Reasoning detail from the model.
@JsonSerializable()
class ReasoningDetail {
  const ReasoningDetail({
    required this.type,
    this.summary,
    this.data,
    this.text,
    this.signature,
    this.id,
    this.format,
    this.index,
  });

  factory ReasoningDetail.fromJson(Map<String, dynamic> json) =>
      _$ReasoningDetailFromJson(json);

  /// The type of reasoning detail.
  final String type;

  /// Summary text.
  final String? summary;

  /// Encrypted data.
  final String? data;

  /// Plain text reasoning.
  final String? text;

  /// Signature for verification.
  final String? signature;

  /// ID of the reasoning block.
  final String? id;

  /// Format of the reasoning.
  final String? format;

  /// Index position.
  final double? index;

  Map<String, dynamic> toJson() => _$ReasoningDetailToJson(this);
}

/// Generated image from the model.
@JsonSerializable()
class ImageGeneration {
  const ImageGeneration({required this.imageUrl});

  factory ImageGeneration.fromJson(Map<String, dynamic> json) =>
      _$ImageGenerationFromJson(json);

  /// URL of the generated image.
  @JsonKey(name: 'image_url')
  final ImageUrl imageUrl;

  Map<String, dynamic> toJson() => _$ImageGenerationToJson(this);
}
