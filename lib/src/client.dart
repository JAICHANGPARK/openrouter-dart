import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import 'exceptions.dart';
import 'models/chat_request.dart';
import 'models/chat_response.dart';
import 'models/embeddings.dart';
import 'models/model_info.dart';
import 'models/provider_info.dart';
import 'models/responses_request.dart';
import 'models/responses_response.dart';

/// Main client for the OpenRouter API.
///
/// Provides methods for:
/// - Chat completions (streaming and non-streaming)
/// - Embeddings
/// - Model listing
/// - Provider listing
/// - Generation metadata
///
/// Example usage:
/// ```dart
/// final client = OpenRouterClient(apiKey: 'your-api-key');
///
/// // Simple chat completion
/// final response = await client.chatCompletion(
///   ChatRequest(
///     model: 'openai/gpt-4o',
///     messages: [Message.user('Hello!')],
///   ),
/// );
///
/// print(response.content);
/// ```
class OpenRouterClient {
  /// Creates an [OpenRouterClient].
  ///
  /// [apiKey] is your OpenRouter API key.
  /// [baseUrl] can be overridden for testing or custom endpoints.
  /// [httpClient] can be provided for custom HTTP client configuration.
  /// [defaultHeaders] are optional headers sent with every request
  /// (e.g., 'HTTP-Referer', 'X-Title' for app attribution).
  OpenRouterClient({
    required String apiKey,
    String baseUrl = 'https://openrouter.ai/api/v1',
    http.Client? httpClient,
    Map<String, String>? defaultHeaders,
  }) : _apiKey = apiKey,
       _baseUrl = baseUrl,
       _httpClient = httpClient ?? http.Client(),
       _defaultHeaders = defaultHeaders ?? {};

  final String _apiKey;
  final String _baseUrl;
  final http.Client _httpClient;
  final Map<String, String> _defaultHeaders;

  /// Closes the HTTP client.
  void close() {
    _httpClient.close();
  }

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
    ..._defaultHeaders,
  };

  /// Performs a non-streaming chat completion.
  ///
  /// Returns a [ChatResponse] containing the model's response.
  /// Throws [OpenRouterException] on API errors.
  Future<ChatResponse> chatCompletion(ChatRequest request) async {
    if (request.stream) {
      throw ArgumentError(
        'For streaming requests, use streamChatCompletion() instead',
      );
    }

    developer.log(
      'Sending chat completion request',
      name: 'openrouter',
      level: 800,
    );

    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    return _handleResponse<ChatResponse>(
      response,
      (json) => ChatResponse.fromJson(json),
    );
  }

  /// Performs a streaming chat completion.
  ///
  /// Returns a [Stream] of [StreamingChunk] objects.
  /// Each chunk contains a delta update to the response.
  ///
  /// Example:
  /// ```dart
  /// final stream = client.streamChatCompletion(
  ///   ChatRequest(
  ///     model: 'openai/gpt-4o',
  ///     messages: [Message.user('Hello!')],
  ///     stream: true,
  ///   ),
  /// );
  ///
  /// await for (final chunk in stream) {
  ///   final content = chunk.choices.firstOrNull?.delta?.content;
  ///   if (content != null) {
  ///     print(content);
  ///   }
  /// }
  /// ```
  Stream<StreamingChunk> streamChatCompletion(ChatRequest request) async* {
    if (!request.stream) {
      throw ArgumentError(
        'Request must have stream: true. Use chatCompletion() for non-streaming.',
      );
    }

    developer.log(
      'Starting streaming chat completion',
      name: 'openrouter',
      level: 800,
    );

    final requestBody = jsonEncode(request.toJson());
    final uri = Uri.parse('$_baseUrl/chat/completions');
    final httpRequest = http.Request('POST', uri)
      ..headers.addAll(_headers)
      ..body = requestBody;

    final response = await _httpClient.send(httpRequest);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      _handleErrorResponse(response.statusCode, body);
    }

    await for (final chunk in _parseSSEStream(response.stream)) {
      if (chunk.isEmpty) continue;

      if (chunk.startsWith(':')) {
        // SSE comment - can be used for keepalive
        developer.log('SSE comment: $chunk', name: 'openrouter');
        continue;
      }

      if (!chunk.startsWith('data: ')) continue;

      final data = chunk.substring(6);

      if (data == '[DONE]') {
        developer.log('Stream complete', name: 'openrouter');
        return;
      }

      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final streamingChunk = StreamingChunk.fromJson(json);

        // Check for errors in the chunk
        if (streamingChunk.error != null) {
          throw StreamingException(
            message: streamingChunk.error!.message,
            metadata: streamingChunk.error!.metadata,
          );
        }

        yield streamingChunk;
      } on FormatException catch (e) {
        developer.log(
          'Failed to parse chunk: $e',
          name: 'openrouter',
          level: 1000,
        );
        continue;
      }
    }
  }

  /// Generates embeddings for the given input.
  ///
  /// [request] contains the input text(s) and model configuration.
  /// Returns an [EmbeddingsResponse] with the embedding vectors.
  Future<EmbeddingsResponse> createEmbeddings(EmbeddingsRequest request) async {
    developer.log('Creating embeddings', name: 'openrouter', level: 800);

    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/embeddings'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    return _handleResponse<EmbeddingsResponse>(
      response,
      (json) => EmbeddingsResponse.fromJson(json),
    );
  }

  /// Lists all available models.
  ///
  /// Returns a [ModelsResponse] containing metadata for all models.
  Future<ModelsResponse> listModels({
    String? category,
    List<String>? supportedParameters,
  }) async {
    var uri = Uri.parse('$_baseUrl/models');

    if (category != null || supportedParameters != null) {
      final queryParams = <String, String>{};
      if (category != null) {
        queryParams['category'] = category;
      }
      if (supportedParameters != null) {
        queryParams['supported_parameters'] = supportedParameters.join(',');
      }
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await _httpClient.get(uri, headers: _headers);

    return _handleResponse<ModelsResponse>(
      response,
      (json) => ModelsResponse.fromJson(json),
    );
  }

  /// Gets the total count of available models.
  Future<ModelsCountResponse> getModelsCount() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/models/count'),
      headers: _headers,
    );

    return _handleResponse<ModelsCountResponse>(
      response,
      (json) => ModelsCountResponse.fromJson(json),
    );
  }

  /// Lists all available providers.
  Future<ProvidersResponse> listProviders() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/providers'),
      headers: _headers,
    );

    return _handleResponse<ProvidersResponse>(
      response,
      (json) => ProvidersResponse.fromJson(json),
    );
  }

  /// Gets metadata for a specific generation by ID.
  ///
  /// [generationId] is the ID returned in the response.
  Future<GenerationResponse> getGeneration(String generationId) async {
    final uri = Uri.parse(
      '$_baseUrl/generation',
    ).replace(queryParameters: {'id': generationId});

    final response = await _httpClient.get(uri, headers: _headers);

    return _handleResponse<GenerationResponse>(
      response,
      (json) => GenerationResponse.fromJson(json),
    );
  }

  /// Gets API key information including usage and limits.
  Future<KeyInfoResponse> getKeyInfo() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/key'),
      headers: _headers,
    );

    return _handleResponse<KeyInfoResponse>(
      response,
      (json) => KeyInfoResponse.fromJson(json),
    );
  }

  /// Creates a response using the OpenRouter Responses API (Beta).
  ///
  /// This API is stateless and compatible with OpenAI's Responses API format.
  /// It supports advanced features like reasoning, tool calling, and web search.
  ///
  /// Example:
  /// ```dart
  /// final response = await client.createResponse(
  ///   ResponsesRequest.simple(
  ///     input: 'What is the weather in Tokyo?',
  ///     model: 'openai/gpt-4o',
  ///   ),
  /// );
  /// print(response.outputText);
  /// ```
  Future<ResponsesResponse> createResponse(ResponsesRequest request) async {
    if (request.stream) {
      throw ArgumentError(
        'For streaming responses, use streamResponse() instead',
      );
    }

    developer.log('Creating response', name: 'openrouter', level: 800);

    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/responses'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    return _handleResponse<ResponsesResponse>(
      response,
      (json) => ResponsesResponse.fromJson(json),
    );
  }

  /// Creates a streaming response using the OpenRouter Responses API (Beta).
  ///
  /// Returns a [Stream] of [ResponsesStreamingChunk] objects.
  ///
  /// Example:
  /// ```dart
  /// final stream = client.streamResponse(
  ///   ResponsesRequest(
  ///     input: [EasyInputMessage.user('Hello!')],
  ///     model: 'openai/gpt-4o',
  ///     stream: true,
  ///   ),
  /// );
  ///
  /// await for (final chunk in stream) {
  ///   final text = chunk.output
  ///       .whereType<OutputMessage>()
  ///       .firstOrNull
  ///       ?.content
  ///       .whereType<OutputText>()
  ///       .firstOrNull
  ///       ?.text;
  ///   if (text != null) print(text);
  /// }
  /// ```
  Stream<ResponsesStreamingChunk> streamResponse(
    ResponsesRequest request,
  ) async* {
    if (!request.stream) {
      throw ArgumentError(
        'Request must have stream: true. Use createResponse() for non-streaming.',
      );
    }

    developer.log(
      'Starting streaming response',
      name: 'openrouter',
      level: 800,
    );

    final requestBody = jsonEncode(request.toJson());
    final uri = Uri.parse('$_baseUrl/responses');
    final httpRequest = http.Request('POST', uri)
      ..headers.addAll(_headers)
      ..body = requestBody;

    final response = await _httpClient.send(httpRequest);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      _handleErrorResponse(response.statusCode, body);
    }

    await for (final chunk in _parseSSEStream(response.stream)) {
      if (chunk.isEmpty) continue;

      if (chunk.startsWith(':')) {
        developer.log('SSE comment: $chunk', name: 'openrouter');
        continue;
      }

      if (!chunk.startsWith('data: ')) continue;

      final data = chunk.substring(6);

      if (data == '[DONE]') {
        developer.log('Stream complete', name: 'openrouter');
        return;
      }

      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final streamingChunk = ResponsesStreamingChunk.fromJson(json);

        if (streamingChunk.error != null) {
          throw StreamingException(
            message: streamingChunk.error!.message,
            metadata: {'code': streamingChunk.error!.code},
          );
        }

        yield streamingChunk;
      } on FormatException catch (e) {
        developer.log(
          'Failed to parse chunk: $e',
          name: 'openrouter',
          level: 1000,
        );
        continue;
      }
    }
  }

  /// Handles HTTP responses and parses JSON.
  T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) parser,
  ) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode == 200) {
      try {
        final json = jsonDecode(body) as Map<String, dynamic>;
        return parser(json);
      } on FormatException catch (e) {
        throw OpenRouterException(
          code: 0,
          message: 'Failed to parse response: $e',
          metadata: {'body': body},
        );
      }
    }

    _handleErrorResponse(statusCode, body);
  }

  /// Handles error responses by throwing appropriate exceptions.
  Never _handleErrorResponse(int statusCode, String body) {
    Map<String, dynamic>? errorJson;
    String errorMessage = 'Unknown error';

    try {
      errorJson = jsonDecode(body) as Map<String, dynamic>?;
      errorMessage =
          errorJson?['error']?['message'] ??
          errorJson?['message'] ??
          'HTTP $statusCode';
    } on FormatException {
      errorMessage = body.isNotEmpty ? body : 'HTTP $statusCode';
    }

    final metadata = errorJson?['error']?['metadata'] as Map<String, dynamic>?;

    switch (statusCode) {
      case 400:
        throw BadRequestException(message: errorMessage, metadata: metadata);
      case 401:
        throw AuthenticationException(
          message: errorMessage,
          metadata: metadata,
        );
      case 402:
        throw PaymentRequiredException(
          message: errorMessage,
          metadata: metadata,
        );
      case 403:
        if (metadata?['reasons'] != null) {
          throw ModerationException(
            message: errorMessage,
            reasons: List<String>.from(metadata!['reasons'] as List),
            flaggedInput: metadata['flagged_input'] as String? ?? '',
            metadata: metadata,
          );
        }
        throw OpenRouterException(
          code: 403,
          message: errorMessage,
          metadata: metadata,
        );
      case 404:
        throw NotFoundException(message: errorMessage, metadata: metadata);
      case 429:
        throw RateLimitException(message: errorMessage, metadata: metadata);
      case >= 500 && < 600:
        throw ServerException(
          code: statusCode,
          message: errorMessage,
          metadata: metadata,
        );
      default:
        throw OpenRouterException(
          code: statusCode,
          message: errorMessage,
          metadata: metadata,
        );
    }
  }

  /// Parses a Server-Sent Events (SSE) stream.
  Stream<String> _parseSSEStream(http.ByteStream stream) async* {
    final buffer = StringBuffer();

    await for (final bytes in stream) {
      final chunk = utf8.decode(bytes);
      buffer.write(chunk);

      // Process complete lines
      var bufferStr = buffer.toString();
      while (true) {
        final lineEnd = bufferStr.indexOf('\n');
        if (lineEnd == -1) break;

        final line = bufferStr.substring(0, lineEnd).trimRight();
        bufferStr = bufferStr.substring(lineEnd + 1);

        if (line.isNotEmpty) {
          yield line;
        }
      }

      buffer.clear();
      buffer.write(bufferStr);
    }

    // Yield any remaining data
    final remaining = buffer.toString().trim();
    if (remaining.isNotEmpty) {
      yield remaining;
    }
  }
}

/// Generation metadata response.
class GenerationResponse {
  const GenerationResponse({required this.data});

  factory GenerationResponse.fromJson(Map<String, dynamic> json) {
    return GenerationResponse(
      data: GenerationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final GenerationData data;
}

/// Generation data.
class GenerationData {
  const GenerationData({
    required this.id,
    this.upstreamId,
    required this.totalCost,
    this.cacheDiscount,
    this.upstreamInferenceCost,
    required this.createdAt,
    required this.model,
    this.appId,
    this.streamed,
    this.cancelled,
    this.providerName,
    this.latency,
    this.moderationLatency,
    this.generationTime,
    this.finishReason,
    this.tokensPrompt,
    this.tokensCompletion,
    this.nativeTokensPrompt,
    this.nativeTokensCompletion,
    this.nativeTokensCompletionImages,
    this.nativeTokensReasoning,
    this.nativeTokensCached,
    this.numMediaPrompt,
    this.numInputAudioPrompt,
    this.numMediaCompletion,
    this.numSearchResults,
    required this.origin,
    required this.usage,
    required this.isByok,
    this.nativeFinishReason,
    this.externalUser,
    this.apiType,
    this.router,
    this.providerResponses,
  });

  factory GenerationData.fromJson(Map<String, dynamic> json) {
    return GenerationData(
      id: json['id'] as String,
      upstreamId: json['upstream_id'] as String?,
      totalCost: (json['total_cost'] as num).toDouble(),
      cacheDiscount: json['cache_discount'] as double?,
      upstreamInferenceCost: json['upstream_inference_cost'] as double?,
      createdAt: json['created_at'] as String,
      model: json['model'] as String,
      appId: json['app_id'] as double?,
      streamed: json['streamed'] as bool?,
      cancelled: json['cancelled'] as bool?,
      providerName: json['provider_name'] as String?,
      latency: json['latency'] as double?,
      moderationLatency: json['moderation_latency'] as double?,
      generationTime: json['generation_time'] as double?,
      finishReason: json['finish_reason'] as String?,
      tokensPrompt: json['tokens_prompt'] as double?,
      tokensCompletion: json['tokens_completion'] as double?,
      nativeTokensPrompt: json['native_tokens_prompt'] as double?,
      nativeTokensCompletion: json['native_tokens_completion'] as double?,
      nativeTokensCompletionImages:
          json['native_tokens_completion_images'] as double?,
      nativeTokensReasoning: json['native_tokens_reasoning'] as double?,
      nativeTokensCached: json['native_tokens_cached'] as double?,
      numMediaPrompt: json['num_media_prompt'] as double?,
      numInputAudioPrompt: json['num_input_audio_prompt'] as double?,
      numMediaCompletion: json['num_media_completion'] as double?,
      numSearchResults: json['num_search_results'] as double?,
      origin: json['origin'] as String,
      usage: (json['usage'] as num).toDouble(),
      isByok: json['is_byok'] as bool,
      nativeFinishReason: json['native_finish_reason'] as String?,
      externalUser: json['external_user'] as String?,
      apiType: json['api_type'] as String?,
      router: json['router'] as String?,
      providerResponses: (json['provider_responses'] as List<dynamic>?)
          ?.map((e) => ProviderResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String? upstreamId;
  final double totalCost;
  final double? cacheDiscount;
  final double? upstreamInferenceCost;
  final String createdAt;
  final String model;
  final double? appId;
  final bool? streamed;
  final bool? cancelled;
  final String? providerName;
  final double? latency;
  final double? moderationLatency;
  final double? generationTime;
  final String? finishReason;
  final double? tokensPrompt;
  final double? tokensCompletion;
  final double? nativeTokensPrompt;
  final double? nativeTokensCompletion;
  final double? nativeTokensCompletionImages;
  final double? nativeTokensReasoning;
  final double? nativeTokensCached;
  final double? numMediaPrompt;
  final double? numInputAudioPrompt;
  final double? numMediaCompletion;
  final double? numSearchResults;
  final String origin;
  final double usage;
  final bool isByok;
  final String? nativeFinishReason;
  final String? externalUser;
  final String? apiType;
  final String? router;
  final List<ProviderResponse>? providerResponses;
}

/// Provider response in generation metadata.
class ProviderResponse {
  const ProviderResponse({
    required this.id,
    required this.endpointId,
    required this.modelPermaslug,
    required this.providerName,
    this.status,
    required this.latency,
    required this.isByok,
  });

  factory ProviderResponse.fromJson(Map<String, dynamic> json) {
    return ProviderResponse(
      id: json['id'] as String,
      endpointId: json['endpoint_id'] as String,
      modelPermaslug: json['model_permaslug'] as String,
      providerName: json['provider_name'] as String,
      status: json['status'] as double?,
      latency: (json['latency'] as num).toDouble(),
      isByok: json['is_byok'] as bool,
    );
  }

  final String id;
  final String endpointId;
  final String modelPermaslug;
  final String providerName;
  final double? status;
  final double latency;
  final bool isByok;
}

/// API key information response.
class KeyInfoResponse {
  const KeyInfoResponse({required this.data});

  factory KeyInfoResponse.fromJson(Map<String, dynamic> json) {
    return KeyInfoResponse(
      data: KeyInfoData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final KeyInfoData data;
}

/// API key data.
class KeyInfoData {
  const KeyInfoData({
    required this.label,
    this.limit,
    this.limitReset,
    this.limitRemaining,
    required this.includeByokInLimit,
    required this.usage,
    required this.usageDaily,
    required this.usageWeekly,
    required this.usageMonthly,
    required this.byokUsage,
    required this.byokUsageDaily,
    required this.byokUsageWeekly,
    required this.byokUsageMonthly,
    required this.isFreeTier,
  });

  factory KeyInfoData.fromJson(Map<String, dynamic> json) {
    return KeyInfoData(
      label: json['label'] as String,
      limit: json['limit'] as double?,
      limitReset: json['limit_reset'] as String?,
      limitRemaining: json['limit_remaining'] as double?,
      includeByokInLimit: json['include_byok_in_limit'] as bool,
      usage: (json['usage'] as num).toDouble(),
      usageDaily: (json['usage_daily'] as num).toDouble(),
      usageWeekly: (json['usage_weekly'] as num).toDouble(),
      usageMonthly: (json['usage_monthly'] as num).toDouble(),
      byokUsage: (json['byok_usage'] as num).toDouble(),
      byokUsageDaily: (json['byok_usage_daily'] as num).toDouble(),
      byokUsageWeekly: (json['byok_usage_weekly'] as num).toDouble(),
      byokUsageMonthly: (json['byok_usage_monthly'] as num).toDouble(),
      isFreeTier: json['is_free_tier'] as bool,
    );
  }

  final String label;
  final double? limit;
  final String? limitReset;
  final double? limitRemaining;
  final bool includeByokInLimit;
  final double usage;
  final double usageDaily;
  final double usageWeekly;
  final double usageMonthly;
  final double byokUsage;
  final double byokUsageDaily;
  final double byokUsageWeekly;
  final double byokUsageMonthly;
  final bool isFreeTier;
}
