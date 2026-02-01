/// Base exception for all OpenRouter API errors.
class OpenRouterException implements Exception {
  /// Creates an [OpenRouterException].
  const OpenRouterException({
    required this.code,
    required this.message,
    this.metadata,
  });

  /// HTTP status code or error code.
  final int code;

  /// Error message.
  final String message;

  /// Additional error metadata.
  final Map<String, dynamic>? metadata;

  @override
  String toString() => 'OpenRouterException(code: $code, message: $message)';
}

/// Exception thrown when authentication fails (401).
class AuthenticationException extends OpenRouterException {
  /// Creates an [AuthenticationException].
  const AuthenticationException({required super.message, super.metadata})
    : super(code: 401);
}

/// Exception thrown when payment is required (402).
class PaymentRequiredException extends OpenRouterException {
  /// Creates a [PaymentRequiredException].
  const PaymentRequiredException({required super.message, super.metadata})
    : super(code: 402);
}

/// Exception thrown when rate limit is exceeded (429).
class RateLimitException extends OpenRouterException {
  /// Creates a [RateLimitException].
  const RateLimitException({required super.message, super.metadata})
    : super(code: 429);
}

/// Exception thrown when the request is invalid (400).
class BadRequestException extends OpenRouterException {
  /// Creates a [BadRequestException].
  const BadRequestException({required super.message, super.metadata})
    : super(code: 400);
}

/// Exception thrown when the model or resource is not found (404).
class NotFoundException extends OpenRouterException {
  /// Creates a [NotFoundException].
  const NotFoundException({required super.message, super.metadata})
    : super(code: 404);
}

/// Exception thrown when a server error occurs (5xx).
class ServerException extends OpenRouterException {
  /// Creates a [ServerException].
  const ServerException({
    required super.code,
    required super.message,
    super.metadata,
  });
}

/// Exception thrown during streaming when an error occurs mid-stream.
class StreamingException extends OpenRouterException {
  /// Creates a [StreamingException].
  const StreamingException({
    required super.message,
    this.streamData,
    super.metadata,
  }) : super(code: 0);

  /// Any partial data received before the error.
  final String? streamData;
}

/// Exception thrown when content is flagged by moderation.
class ModerationException extends OpenRouterException {
  /// Creates a [ModerationException].
  const ModerationException({
    required super.message,
    required this.reasons,
    required this.flaggedInput,
    super.metadata,
  }) : super(code: 403);

  /// Reasons why the input was flagged.
  final List<String> reasons;

  /// The text segment that was flagged.
  final String flaggedInput;
}
