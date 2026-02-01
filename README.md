# OpenRouter Flutter SDK

[![pub package](https://img.shields.io/pub/v/openrouter.svg)](https://pub.dev/packages/openrouter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful Flutter plugin for the [OpenRouter](https://openrouter.ai) API, providing unified access to hundreds of AI models including OpenAI, Anthropic, Google, Meta, and more.

## Features

- **Chat Completions** - Support for streaming and non-streaming chat completions
- **Embeddings** - Generate text embeddings for any supported model
- **Model Discovery** - Browse 400+ available models with detailed metadata
- **Provider Information** - List all available providers and their status
- **Generation Metadata** - Get detailed token usage and cost information
- **Response API (Beta)** - OpenAI-compatible stateless API with advanced features:
  - Reasoning/thinking process display
  - Web search integration
  - Function calling
  - File search
- **Comprehensive Error Handling** - Specific exception types for different error scenarios
- **Type-Safe** - Fully typed API with null safety
- **Streaming Support** - Real-time streaming responses for chat and responses API

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  openrouter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:openrouter/openrouter.dart';

void main() async {
  final client = OpenRouterClient(apiKey: 'your-api-key');

  // Simple chat completion
  final response = await client.chatCompletion(
    ChatRequest(
      model: 'openai/gpt-4o',
      messages: [Message.user('Hello, world!')],
    ),
  );

  print(response.content);
}
```

## Usage

### Chat Completions

#### Non-Streaming

```dart
final response = await client.chatCompletion(
  ChatRequest(
    model: 'openai/gpt-4o',
    messages: [
      Message.system('You are a helpful assistant.'),
      Message.user('What is the capital of France?'),
    ],
    temperature: 0.7,
    maxTokens: 500,
  ),
);

print(response.content);
print('Tokens used: ${response.usage?.totalTokens}');
```

#### Streaming

```dart
final stream = client.streamChatCompletion(
  ChatRequest(
    model: 'anthropic/claude-3.5-sonnet',
    messages: [Message.user('Tell me a story.')],
    stream: true,
  ),
);

await for (final chunk in stream) {
  print(chunk.contentChunk);
}
```

### Embeddings

```dart
final response = await client.createEmbeddings(
  EmbeddingsRequest(
    model: 'openai/text-embedding-3-small',
    input: 'The quick brown fox jumps over the lazy dog.',
  ),
);

print('Embedding dimensions: ${response.embeddings.first.embedding.length}');
```

### Model Listing

```dart
final models = await client.listModels();

for (final model in models) {
  print('${model.id}: ${model.description}');
}
```

### Responses API (Beta)

The Responses API is a stateless API compatible with OpenAI's Responses format:

```dart
// Simple text request
final response = await client.createResponse(
  ResponsesRequest.simple(
    input: 'What is the weather in Tokyo?',
    model: 'openai/gpt-4o',
  ),
);

print(response.outputText);
```

#### With Reasoning and Tools

```dart
final request = ResponsesRequest.withMessages(
  input: [
    EasyInputMessage.user('What is the latest news about AI?'),
  ],
  model: 'openai/gpt-4o',
  tools: [
    WebSearchPreviewTool(),
  ],
);

final response = await client.createResponse(request);

// Access reasoning
final reasoning = response.reasoningOutput;
if (reasoning != null) {
  for (final summary in reasoning.summary ?? []) {
    print('Thinking: ${summary.text}');
  }
}

// Access content
print(response.messageContent);
```

#### Streaming Responses

```dart
final stream = client.streamResponse(
  ResponsesRequest(
    input: [EasyInputMessage.user('Explain quantum computing.')],
    model: 'openai/gpt-4o',
    stream: true,
  ),
);

await for (final chunk in stream) {
  final text = chunk.outputText;
  if (text != null) print(text);
}
```

### Error Handling

```dart
try {
  final response = await client.chatCompletion(request);
} on OpenRouterApiException catch (e) {
  print('API Error: ${e.message} (Status: ${e.statusCode})');
} on OpenRouterRateLimitException catch (e) {
  print('Rate limited. Retry after: ${e.retryAfter}');
} on OpenRouterAuthenticationException catch (e) {
  print('Authentication failed: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Configuration

### Base URL

By default, the client uses `https://openrouter.ai/api`. You can customize this:

```dart
final client = OpenRouterClient(
  apiKey: 'your-api-key',
  baseUrl: 'https://custom-proxy.com/api',
);
```

### HTTP Headers

Additional headers can be added for features like prompt caching:

```dart
final client = OpenRouterClient(
  apiKey: 'your-api-key',
  headers: {
    'X-Prompt-Cache-Key': 'my-cache-key',
  },
);
```

## Example App

The package includes a comprehensive example app demonstrating all features:

```bash
cd example
flutter run
```

The example app includes:
- **Chat Screen** - Interactive chat interface with streaming support
- **Responses Screen** - Demo of the new Responses API with reasoning and web search
- **Models Screen** - Browse and filter all available models
- **Settings Screen** - API key management and usage statistics

## API Reference

### Client Methods

- `chatCompletion(ChatRequest)` - Single chat completion
- `streamChatCompletion(ChatRequest)` - Streaming chat completion
- `createEmbeddings(EmbeddingsRequest)` - Generate embeddings
- `listModels()` - List all available models
- `listProviders()` - List all providers
- `getGeneration(String)` - Get generation metadata by ID
- `getKeyInfo()` - Get API key usage information
- `createResponse(ResponsesRequest)` - Create a response (non-streaming)
- `streamResponse(ResponsesRequest)` - Stream responses

### Request Models

- `ChatRequest` - Chat completion request
- `EmbeddingsRequest` - Embeddings request
- `ResponsesRequest` - Response API request

### Response Models

- `ChatResponse` - Chat completion response
- `EmbeddingsResponse` - Embeddings response
- `ResponsesResponse` - Response API response
- `StreamingChunk` - Streaming chat chunk
- `ResponsesStreamingChunk` - Streaming response chunk

## Supported Models

OpenRouter provides access to 400+ models including:

- **OpenAI**: GPT-4o, GPT-4 Turbo, GPT-3.5 Turbo, DALL-E 3
- **Anthropic**: Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku
- **Google**: Gemini Pro, Gemini Flash
- **Meta**: Llama 3, Llama 3.1
- **Mistral**: Mistral Large, Mistral Medium, Mistral Small
- **And many more...**

See the [OpenRouter documentation](https://openrouter.ai/docs) for the complete list.

## Additional Information

### OpenRouter Features

- **Automatic Fallbacks** - If a model/provider is down, requests automatically fall back to alternatives
- **Prompt Caching** - Cache prompts for faster responses and lower costs
- **Request IDs** - Track requests for debugging and analytics
- **Provider Routing** - Choose specific providers for each request
- **Credits System** - Transparent pricing with detailed cost breakdowns

### Getting an API Key

1. Visit [openrouter.ai](https://openrouter.ai)
2. Sign up for an account
3. Go to the API Keys section
4. Create a new key

### Pricing

OpenRouter provides transparent pricing across all models. Visit the [pricing page](https://openrouter.ai/models) for details.

## Contributing

Contributions are welcome! Please read our [contributing guide](CONTRIBUTING.md) before submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- [OpenRouter Documentation](https://openrouter.ai/docs)
- [OpenRouter Discord](https://discord.gg/openrouter)
- [GitHub Issues](https://github.com/yourusername/openrouter/issues)

## Acknowledgments

- Thanks to OpenRouter for providing the API
- Built with Flutter and Dart

---

**Note**: This is an unofficial Flutter SDK. It is not officially maintained by OpenRouter.
