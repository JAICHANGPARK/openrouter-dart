# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
## [1.0.1] - 2026-02-01
- update topics

## [1.0.0] - 2026-02-01

### Added

#### Response API (Beta)
- **New API Support**: Added full support for the OpenRouter Responses API (Beta)
  - `createResponse()` method for non-streaming responses
  - `streamResponse()` method for streaming responses
  - Complete type-safe request/response models
  - Support for reasoning/thinking process display
  - Web search integration with `WebSearchPreviewTool`
  - Function calling support
  - File search capabilities
  - Image generation support
  - Support for text, JSON object, and JSON schema response formats

- **New Models**:
  - `ResponsesRequest` - Request model with support for:
    - Simple text input
    - Structured message input with `EasyInputMessage` and `InputMessageItem`
    - Multi-modal content (text, images, audio, video, files)
    - Tool definitions and tool choice
    - Reasoning configuration with effort levels
    - Response format configuration
    - Plugins (web search, auto-router, file parser, etc.)
  - `ResponsesResponse` - Response model with:
    - Output items (messages, reasoning, function calls)
    - Web search call outputs
    - File search call outputs
    - Image generation call outputs
    - Usage and cost information
    - Error handling
  - `ResponsesStreamingChunk` - Streaming response chunks

#### Features
- **Reasoning Support**: Added support for displaying model reasoning/thinking processes
  - `ResponsesReasoningConfig` for configuring reasoning effort
  - `OutputReasoning` for accessing reasoning output
  - Multiple reasoning effort levels: `none`, `minimal`, `low`, `medium`, `high`, `xhigh`
  - Reasoning summary verbosity options

- **Tool Calling**: Enhanced tool calling capabilities
  - `ResponsesFunctionTool` for defining function tools
  - `WebSearchPreviewTool` for web search integration
  - `OutputFunctionCall` for accessing function call outputs
  - Tool choice options: auto, none, required, or specific function

- **Content Types**: Support for various input content types
  - `ResponseInputText` - Text input
  - `ResponseInputImage` - Image input with URL or base64
  - `ResponseInputFile` - File input with ID, data, or URL
  - `ResponseInputAudio` - Audio input
  - `ResponseInputVideo` - Video input
  - `ResponseInputImageDetail` - Image detail level control

- **Annotations**: Support for citation annotations in responses
  - `UrlCitation` - URL citation with title
  - `FileCitation` - File citation with filename
  - `FilePath` - File path annotation

- **Plugins**: Support for OpenRouter plugins
  - Web search plugin
  - Auto-router plugin for model selection
  - File parser plugin with PDF options
  - Response healing plugin
  - Moderation plugin

#### Example App
- **New Response API Demo**: Added `ResponsesScreen` to example app
  - Interactive chat interface demonstrating Response API features
  - Reasoning process display
  - Token usage and cost tracking
  - Feature badges showing supported capabilities
  - About dialog explaining Response API features

#### Documentation
- **Comprehensive README**: Completely rewritten with:
  - Feature overview
  - Quick start guide
  - Detailed usage examples for all APIs
  - Chat completions (streaming and non-streaming)
  - Embeddings
  - Model listing
  - Responses API examples
  - Error handling patterns
  - Configuration options
  - Example app instructions

### Changed

- **Model Organization**: Improved exports structure
  - Hide conflicting type names (`ReasoningEffort`, `ToolChoiceFunction`, `PdfOptions`, `TopLogprob`, `CostDetails`)
  - Better separation between Chat API and Response API types

- **Type Safety**: Enhanced type safety with sealed classes
  - `ResponsesInputItem` - Sealed class for input items
  - `ResponseContentPart` - Sealed class for content parts
  - `ResponsesTool` - Sealed class for tools
  - `ResponsesToolChoice` - Sealed class for tool choices
  - `ResponseFormatTextConfig` - Sealed class for format configs
  - `ResponsesOutputItem` - Sealed class for output items
  - `OutputContent` - Sealed class for output content
  - `Annotation` - Sealed class for annotations

### Fixed

- **JSON Serialization**: Fixed polymorphic type serialization
  - Added custom converters for `List<ResponsesTool>`
  - Added custom converters for `List<ResponsesOutputItem>`
  - Added custom converters for `List<OutputContent>`
  - Added custom converters for `List<Annotation>`
  - Added custom converters for `List<ResponseContentPart>`
  - Added custom converters for `ResponseFormatTextConfig`
  - Added custom converters for `ResponsesToolChoice`
  - Proper handling of sealed class hierarchies with type discrimination

- **Code Quality**:
  - Removed `@immutable` annotations from sealed classes (build_runner compatibility)
  - Fixed all LSP errors and warnings
  - Applied `dart fix` suggestions
  - Formatted all code with `dart format`

### Technical Details

- **Dependencies**: 
  - Uses `json_annotation` and `json_serializable` for code generation
  - Uses `http` package for HTTP requests
  - Uses `meta` package for annotations

- **Code Generation**: 
  - All models support JSON serialization via build_runner
  - Generated `.g.dart` files for all serializable models
  - Custom fromJson/toJson logic for polymorphic types

- **Compatibility**:
  - Requires Dart SDK ^3.0.0
  - Flutter 3.0+ support
  - Multi-platform support (iOS, Android, Web, Desktop)

## [0.0.1] - Initial Release

### Added
- Initial project structure
- Basic Flutter plugin setup
- Placeholder implementation

---

## Release Notes Format

Each release includes:
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Now removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements

## Migration Guide

### Migrating to 1.0.0

If you're upgrading from earlier versions:

1. **Update imports**: No breaking changes to existing Chat API imports
2. **New Response API**: Add additional imports if using Response API:
   ```dart
   import 'package:openrouter/openrouter.dart' hide ReasoningEffort;
   import 'package:openrouter/src/models/responses_request.dart' as responses;
   import 'package:openrouter/src/models/responses_response.dart' as responses;
   ```

3. **ReasoningEffort**: If using `ReasoningEffort` from chat requests, it is now shared. No action needed unless you were importing it specifically.

4. **New Features**: Response API is fully additive - existing code continues to work without changes.
