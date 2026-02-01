/// OpenRouter Flutter SDK
///
/// A Flutter plugin for the OpenRouter API providing unified access to
/// hundreds of AI models including OpenAI, Anthropic, Google, and more.
///
/// ## Usage
///
/// ```dart
/// import 'package:openrouter/openrouter.dart';
///
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
///
/// ## Features
///
/// - Chat completions (streaming and non-streaming)
/// - Embeddings
/// - Model listing
/// - Provider listing
/// - Generation metadata
/// - Error handling with specific exception types
///
/// For more information, see the [OpenRouter documentation](https://openrouter.ai/docs).
library;

// Client
export 'src/client.dart';

// Exceptions
export 'src/exceptions.dart';

// Models
export 'src/models/chat_request.dart' hide ToolChoiceFunction, PdfOptions;
export 'src/models/chat_response.dart' hide TopLogprob, CostDetails;
export 'src/models/embeddings.dart';
export 'src/models/message.dart';
export 'src/models/model_info.dart';
export 'src/models/provider_info.dart';
export 'src/models/responses_request.dart' hide ReasoningEffort;
export 'src/models/responses_response.dart';

// Version
const String packageVersion = '1.0.0';
