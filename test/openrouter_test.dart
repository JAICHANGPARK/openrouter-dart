import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:openrouter/openrouter.dart';

void main() {
  group('OpenRouterClient', () {
    late OpenRouterClient client;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        final path = request.url.path;

        if (path.endsWith('/chat/completions')) {
          final body = request.body;
          final isStreaming = body.contains('"stream":true');

          if (isStreaming) {
            // Return streaming response chunks
            final chunks = [
              '{"id":"stream-1","object":"chat.completion.chunk","created":1234567890,"model":"openai/gpt-4o","choices":[{"index":0,"delta":{"role":"assistant"}}]}',
              '{"id":"stream-2","object":"chat.completion.chunk","created":1234567890,"model":"openai/gpt-4o","choices":[{"index":0,"delta":{"content":"Hello"}}]}',
              '{"id":"stream-3","object":"chat.completion.chunk","created":1234567890,"model":"openai/gpt-4o","choices":[{"index":0,"delta":{"content":" World"}}]}',
              '{"id":"stream-4","object":"chat.completion.chunk","created":1234567890,"model":"openai/gpt-4o","choices":[{"index":0,"finish_reason":"stop"}],"usage":{"prompt_tokens":10,"completion_tokens":2,"total_tokens":12}}',
            ];

            final bodyData = chunks.map((c) => 'data: $c').join('\n\n');
            return http.Response(
              '$bodyData\n\ndata: [DONE]',
              200,
              headers: {'content-type': 'text/event-stream'},
            );
          }

          return http.Response(
            '''{
              "id": "chatcmpl-test-id",
              "object": "chat.completion",
              "created": 1234567890,
              "model": "openai/gpt-4o",
              "choices": [
                {
                  "index": 0,
                  "finish_reason": "stop",
                  "native_finish_reason": "stop",
                  "message": {
                    "role": "assistant",
                    "content": "Hello! How can I help you today?"
                  }
                }
              ],
              "usage": {
                "prompt_tokens": 10,
                "completion_tokens": 10,
                "total_tokens": 20,
                "prompt_tokens_details": {"cached_tokens": 0},
                "completion_tokens_details": {"reasoning_tokens": 0}
              },
              "provider": "OpenAI"
            }''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (path.endsWith('/embeddings')) {
          return http.Response(
            '''{
              "id": "emb-test-id",
              "object": "list",
              "data": [
                {
                  "object": "embedding",
                  "embedding": [0.1, 0.2, 0.3, 0.4, 0.5],
                  "index": 0
                }
              ],
              "model": "text-embedding-3-small",
              "usage": {
                "prompt_tokens": 5,
                "total_tokens": 5,
                "cost": 0.00001
              }
            }''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (path.endsWith('/models') && !path.contains('/count')) {
          return http.Response(
            '''{
              "data": [
                {
                  "id": "openai/gpt-4o",
                  "canonical_slug": "openai/gpt-4o",
                  "name": "GPT-4o",
                  "created": 1234567890,
                  "description": "GPT-4o model by OpenAI",
                  "pricing": {"prompt": "0.005", "completion": "0.015"},
                  "context_length": 128000,
                  "architecture": {
                    "tokenizer": "GPT",
                    "modality": "text+image",
                    "input_modalities": ["text", "image"],
                    "output_modalities": ["text"]
                  },
                  "top_provider": {
                    "context_length": 128000,
                    "max_completion_tokens": 4096,
                    "is_moderated": true
                  },
                  "per_request_limits": {
                    "prompt_tokens": 128000,
                    "completion_tokens": 4096
                  },
                  "supported_parameters": ["temperature", "max_tokens", "tools"],
                  "default_parameters": {"temperature": 1.0, "top_p": 1.0}
                },
                {
                  "id": "anthropic/claude-3.5-sonnet",
                  "canonical_slug": "anthropic/claude-3.5-sonnet",
                  "name": "Claude 3.5 Sonnet",
                  "created": 1234567890,
                  "description": "Claude 3.5 Sonnet by Anthropic",
                  "pricing": {"prompt": "0.003", "completion": "0.015"},
                  "context_length": 200000,
                  "architecture": {
                    "tokenizer": "Claude",
                    "modality": "text+image",
                    "input_modalities": ["text", "image"],
                    "output_modalities": ["text"]
                  },
                  "top_provider": {
                    "context_length": 200000,
                    "max_completion_tokens": 4096,
                    "is_moderated": true
                  },
                  "per_request_limits": {
                    "prompt_tokens": 200000,
                    "completion_tokens": 4096
                  },
                  "supported_parameters": ["temperature", "max_tokens", "tools", "reasoning"],
                  "default_parameters": {"temperature": 1.0}
                }
              ]
            }''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (path.endsWith('/models/count')) {
          return http.Response(
            '{"data": {"count": 250}}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (path.endsWith('/providers')) {
          return http.Response(
            '''{
              "data": [
                {
                  "name": "OpenAI",
                  "slug": "openai",
                  "privacy_policy_url": "https://openai.com/privacy",
                  "terms_of_service_url": "https://openai.com/terms",
                  "status_page_url": "https://status.openai.com"
                },
                {
                  "name": "Anthropic",
                  "slug": "anthropic",
                  "privacy_policy_url": "https://anthropic.com/privacy",
                  "terms_of_service_url": null,
                  "status_page_url": null
                }
              ]
            }''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (path.endsWith('/generation')) {
          return http.Response(
            '''{
              "data": {
                "id": "gen-test-id",
                "upstream_id": "upstream-123",
                "total_cost": 0.001,
                "cache_discount": null,
                "upstream_inference_cost": 0.0008,
                "created_at": "2024-01-01T00:00:00Z",
                "model": "openai/gpt-4o",
                "app_id": null,
                "streamed": false,
                "cancelled": false,
                "provider_name": "OpenAI",
                "latency": 500,
                "moderation_latency": null,
                "generation_time": 450,
                "finish_reason": "stop",
                "tokens_prompt": 10,
                "tokens_completion": 5,
                "native_tokens_prompt": 10,
                "native_tokens_completion": 5,
                "native_tokens_completion_images": null,
                "native_tokens_reasoning": null,
                "native_tokens_cached": null,
                "num_media_prompt": null,
                "num_input_audio_prompt": null,
                "num_media_completion": null,
                "num_search_results": null,
                "origin": "https://example.com",
                "usage": 0.001,
                "is_byok": false,
                "native_finish_reason": "stop",
                "external_user": null,
                "api_type": "completions",
                "router": null,
                "provider_responses": []
              }
            }''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (path.endsWith('/key')) {
          return http.Response(
            '''{
              "data": {
                "label": "Test Key",
                "limit": 100.0,
                "limit_reset": null,
                "limit_remaining": 95.0,
                "include_byok_in_limit": false,
                "usage": 5.0,
                "usage_daily": 1.0,
                "usage_weekly": 3.0,
                "usage_monthly": 5.0,
                "byok_usage": 0.0,
                "byok_usage_daily": 0.0,
                "byok_usage_weekly": 0.0,
                "byok_usage_monthly": 0.0,
                "is_free_tier": false
              }
            }''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response('Not found', 404);
      });

      client = OpenRouterClient(apiKey: 'test-api-key', httpClient: mockClient);
    });

    tearDown(() {
      client.close();
    });

    group('chatCompletion', () {
      test('returns ChatResponse with correct data', () async {
        final response = await client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        );

        expect(response.id, 'chatcmpl-test-id');
        expect(response.object, 'chat.completion');
        expect(response.model, 'openai/gpt-4o');
        expect(response.choices, hasLength(1));
        expect(response.choices.first.index, 0);
        expect(response.choices.first.finishReason, 'stop');
        expect(response.choices.first.message?.role, MessageRole.assistant);
        expect(
          response.choices.first.message?.content,
          'Hello! How can I help you today?',
        );
        expect(response.content, 'Hello! How can I help you today?');
        expect(response.provider, 'OpenAI');

        // Check usage
        expect(response.usage, isNotNull);
        expect(response.usage?.promptTokens, 10);
        expect(response.usage?.completionTokens, 10);
        expect(response.usage?.totalTokens, 20);
      });

      test('throws ArgumentError when stream is true', () async {
        expect(
          () => client.chatCompletion(
            const ChatRequest(
              model: 'openai/gpt-4o',
              messages: [Message(role: MessageRole.user, content: 'Hello')],
              stream: true,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('supports multi-turn conversation', () async {
        final response = await client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [
              Message(
                role: MessageRole.system,
                content: 'You are a helpful assistant',
              ),
              Message(role: MessageRole.user, content: 'Hello'),
              Message(role: MessageRole.assistant, content: 'Hi there!'),
              Message(role: MessageRole.user, content: 'How are you?'),
            ],
          ),
        );

        expect(response.choices, hasLength(1));
      });
    });

    group('streamChatCompletion', () {
      test('yields streaming chunks', () async {
        final stream = client.streamChatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
            stream: true,
          ),
        );

        final chunks = await stream.toList();

        // Note: MockClient doesn't properly stream, so we get one response
        // In real usage, this would be multiple chunks
        expect(chunks, isNotEmpty);
      });

      test('throws ArgumentError when stream is false', () async {
        expect(
          () => client.streamChatCompletion(
            const ChatRequest(
              model: 'openai/gpt-4o',
              messages: [Message(role: MessageRole.user, content: 'Hello')],
              stream: false,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('createEmbeddings', () {
      test('returns EmbeddingsResponse', () async {
        final response = await client.createEmbeddings(
          const EmbeddingsRequest(
            input: 'The quick brown fox',
            model: 'text-embedding-3-small',
          ),
        );

        expect(response.id, 'emb-test-id');
        expect(response.object, 'list');
        expect(response.model, 'text-embedding-3-small');
        expect(response.data, hasLength(1));
        expect(response.data.first.object, 'embedding');
        expect(response.data.first.embedding, isA<List>());

        // Check usage
        expect(response.usage.promptTokens, 5);
        expect(response.usage.totalTokens, 5);
        expect(response.usage.cost, 0.00001);
      });

      test('supports batch embedding', () async {
        final response = await client.createEmbeddings(
          const EmbeddingsRequest(
            input: ['Text 1', 'Text 2', 'Text 3'],
            model: 'text-embedding-3-small',
          ),
        );

        expect(response.data, hasLength(1)); // Mock returns 1
      });
    });

    group('listModels', () {
      test('returns ModelsResponse with model data', () async {
        final response = await client.listModels();

        expect(response.data, hasLength(2));

        final firstModel = response.data.first;
        expect(firstModel.id, 'openai/gpt-4o');
        expect(firstModel.name, 'GPT-4o');
        expect(firstModel.contextLength, 128000);
        expect(firstModel.architecture.inputModalities, contains('text'));
        expect(firstModel.architecture.outputModalities, contains('text'));
        expect(firstModel.topProvider.isModerated, true);
        expect(firstModel.supportedParameters, contains('temperature'));
      });

      test('supports category filter', () async {
        final response = await client.listModels(category: 'programming');

        expect(response.data, hasLength(2));
      });

      test('supports supported_parameters filter', () async {
        final response = await client.listModels(
          supportedParameters: ['tools', 'reasoning'],
        );

        expect(response.data, hasLength(2));
      });
    });

    group('getModelsCount', () {
      test('returns model count', () async {
        final response = await client.getModelsCount();

        expect(response.data.count, 250);
      });
    });

    group('listProviders', () {
      test('returns ProvidersResponse', () async {
        final response = await client.listProviders();

        expect(response.data, hasLength(2));

        final firstProvider = response.data.first;
        expect(firstProvider.name, 'OpenAI');
        expect(firstProvider.slug, 'openai');
        expect(firstProvider.privacyPolicyUrl, isNotNull);
      });
    });

    group('getGeneration', () {
      test('returns GenerationResponse', () async {
        final response = await client.getGeneration('gen-test-id');

        expect(response.data.id, 'gen-test-id');
        expect(response.data.upstreamId, 'upstream-123');
        expect(response.data.totalCost, 0.001);
        expect(response.data.model, 'openai/gpt-4o');
        expect(response.data.providerName, 'OpenAI');
        expect(response.data.tokensPrompt, 10);
        expect(response.data.tokensCompletion, 5);
        expect(response.data.isByok, false);
      });
    });

    group('getKeyInfo', () {
      test('returns KeyInfoResponse', () async {
        final response = await client.getKeyInfo();

        expect(response.data.label, 'Test Key');
        expect(response.data.limit, 100.0);
        expect(response.data.limitRemaining, 95.0);
        expect(response.data.usage, 5.0);
        expect(response.data.usageDaily, 1.0);
        expect(response.data.isFreeTier, false);
      });
    });
  });

  group('Error Handling', () {
    test('throws AuthenticationException on 401', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": {"message": "Invalid API key", "code": 401}}',
          401,
        );
      });

      final client = OpenRouterClient(
        apiKey: 'invalid-key',
        httpClient: mockClient,
      );

      expect(
        () => client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        ),
        throwsA(isA<AuthenticationException>()),
      );

      client.close();
    });

    test('throws PaymentRequiredException on 402', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": {"message": "Insufficient credits", "code": 402}}',
          402,
        );
      });

      final client = OpenRouterClient(
        apiKey: 'test-key',
        httpClient: mockClient,
      );

      expect(
        () => client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        ),
        throwsA(isA<PaymentRequiredException>()),
      );

      client.close();
    });

    test('throws RateLimitException on 429', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": {"message": "Rate limit exceeded", "code": 429}}',
          429,
        );
      });

      final client = OpenRouterClient(
        apiKey: 'test-key',
        httpClient: mockClient,
      );

      expect(
        () => client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        ),
        throwsA(isA<RateLimitException>()),
      );

      client.close();
    });

    test('throws BadRequestException on 400', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": {"message": "Invalid request", "code": 400}}',
          400,
        );
      });

      final client = OpenRouterClient(
        apiKey: 'test-key',
        httpClient: mockClient,
      );

      expect(
        () => client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        ),
        throwsA(isA<BadRequestException>()),
      );

      client.close();
    });

    test('throws NotFoundException on 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": {"message": "Model not found", "code": 404}}',
          404,
        );
      });

      final client = OpenRouterClient(
        apiKey: 'test-key',
        httpClient: mockClient,
      );

      expect(
        () => client.chatCompletion(
          const ChatRequest(
            model: 'invalid/model',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        ),
        throwsA(isA<NotFoundException>()),
      );

      client.close();
    });

    test('throws ServerException on 500', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": {"message": "Internal server error", "code": 500}}',
          500,
        );
      });

      final client = OpenRouterClient(
        apiKey: 'test-key',
        httpClient: mockClient,
      );

      expect(
        () => client.chatCompletion(
          const ChatRequest(
            model: 'openai/gpt-4o',
            messages: [Message(role: MessageRole.user, content: 'Hello')],
          ),
        ),
        throwsA(isA<ServerException>()),
      );

      client.close();
    });

    test(
      'throws ModerationException on 403 with moderation metadata',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response('''{
            "error": {
              "message": "Content flagged by moderation",
              "code": 403,
              "metadata": {
                "reasons": ["hate_speech", "harassment"],
                "flagged_input": "inappropriate content...",
                "provider_name": "OpenAI",
                "model_slug": "gpt-4o"
              }
            }
          }''', 403);
        });

        final client = OpenRouterClient(
          apiKey: 'test-key',
          httpClient: mockClient,
        );

        expect(
          () => client.chatCompletion(
            const ChatRequest(
              model: 'openai/gpt-4o',
              messages: [Message(role: MessageRole.user, content: 'Hello')],
            ),
          ),
          throwsA(
            isA<ModerationException>().having(
              (e) => e.reasons,
              'reasons',
              contains('hate_speech'),
            ),
          ),
        );

        client.close();
      },
    );
  });

  group('ChatRequest', () {
    test('creates simple request', () {
      final request = ChatRequest(
        model: 'openai/gpt-4o',
        messages: [Message.user('Hello')],
      );

      expect(request.model, 'openai/gpt-4o');
      expect(request.messages, hasLength(1));
      expect(request.stream, false);
    });

    test('supports all parameters', () {
      final request = ChatRequest(
        model: 'openai/gpt-4o',
        models: ['anthropic/claude-3.5-sonnet'],
        messages: [Message.system('You are helpful'), Message.user('Hello')],
        temperature: 0.7,
        maxTokens: 100,
        topP: 0.9,
        frequencyPenalty: 0.5,
        presencePenalty: 0.5,
        stop: ['END'],
        seed: 42,
        responseFormat: ResponseFormat.jsonObject(),
        tools: [
          ToolDefinition(
            function: FunctionDefinition(
              name: 'get_weather',
              description: 'Get weather',
              parameters: {
                'type': 'object',
                'properties': {
                  'location': {'type': 'string'},
                },
              },
            ),
          ),
        ],
        toolChoice: ToolChoice.auto(),
        user: 'user-123',
        stream: false,
      );

      expect(request.temperature, 0.7);
      expect(request.maxTokens, 100);
      expect(request.stop, 'END');
      expect(request.seed, 42);
      expect(request.responseFormat?.type, 'json_object');
      expect(request.tools, hasLength(1));
      expect(request.user, 'user-123');
    });

    test('supports provider preferences', () {
      final request = ChatRequest(
        model: 'openai/gpt-4o',
        messages: [Message.user('Hello')],
        provider: ProviderPreferences(
          order: ['openai', 'anthropic'],
          allowFallbacks: true,
          dataCollection: DataCollection.deny,
        ),
      );

      expect(request.provider?.order, ['openai', 'anthropic']);
      expect(request.provider?.allowFallbacks, true);
      expect(request.provider?.dataCollection, DataCollection.deny);
    });

    test('supports plugins', () {
      final request = ChatRequest(
        model: 'openai/gpt-4o',
        messages: [Message.user('Search for this')],
        plugins: [Plugin.web(maxResults: 5)],
      );

      expect(request.plugins, hasLength(1));
      expect(request.plugins?.first.id, 'web');
      expect(request.plugins?.first.maxResults, 5);
    });

    test('supports reasoning configuration', () {
      final request = ChatRequest(
        model: 'openai/o1-mini',
        messages: [Message.user('Solve this')],
        reasoning: ReasoningConfig(
          effort: ReasoningEffort.high,
          summary: ReasoningSummary.detailed,
        ),
      );

      expect(request.reasoning?.effort, ReasoningEffort.high);
      expect(request.reasoning?.summary, ReasoningSummary.detailed);
    });
  });

  group('Message', () {
    test('creates user message with helper', () {
      final message = Message.user('Hello');

      expect(message.role, MessageRole.user);
      expect(message.content, 'Hello');
    });

    test('creates system message with helper', () {
      final message = Message.system('Be helpful');

      expect(message.role, MessageRole.system);
      expect(message.content, 'Be helpful');
    });

    test('creates assistant message with helper', () {
      final message = Message.assistant('I can help!');

      expect(message.role, MessageRole.assistant);
      expect(message.content, 'I can help!');
    });

    test('supports content items', () {
      final message = Message(
        role: MessageRole.user,
        content: [
          TextContentItem(text: 'What is in this image?'),
          ImageContentItem(
            imageUrl: ImageUrl(url: 'https://example.com/image.png'),
          ),
        ],
      );

      expect(message.content, isA<List<ContentItem>>());
      expect((message.content as List).length, 2);
    });
  });
}
