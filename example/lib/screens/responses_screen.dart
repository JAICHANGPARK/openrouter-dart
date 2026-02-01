import 'package:flutter/material.dart';
import 'package:openrouter/openrouter.dart' hide ReasoningEffort;
import 'package:openrouter/src/models/responses_request.dart' as responses;
import 'package:openrouter/src/models/responses_response.dart' as responses;

class ResponsesScreen extends StatefulWidget {
  const ResponsesScreen({super.key});

  @override
  State<ResponsesScreen> createState() => _ResponsesScreenState();
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ResponseMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ResponseMessage.user(text));
      _controller.clear();
      _isLoading = true;
    });

    try {
      // Get API key from settings (simplified for demo)
      const apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
      if (apiKey.isEmpty) {
        setState(() {
          _messages.add(
            _ResponseMessage.assistantError(
              'Please set your OpenRouter API key in Settings',
            ),
          );
          _isLoading = false;
        });
        return;
      }

      final client = OpenRouterClient(apiKey: apiKey);

      // Build conversation history for stateless API
      final input = <responses.ResponsesInputItem>[
        for (final msg in _messages)
          if (msg.isUser)
            responses.EasyInputMessage.user(msg.content)
          else if (msg.isAssistant)
            responses.EasyInputMessage.assistant(msg.content),
      ];

      // Create request with reasoning and web search enabled
      final request = responses.ResponsesRequest(
        input: input.map((e) => e.toJson()).toList(),
        model: 'openai/gpt-4o',
        tools: [const responses.WebSearchPreviewTool()],
        reasoning: responses.ResponsesReasoningConfig(
          effort: responses.ReasoningEffort.medium,
          summary: responses.ReasoningSummaryVerbosity.concise,
        ),
      );

      final response = await client.createResponse(request);

      // Extract response content and reasoning
      final assistantMessage = StringBuffer();

      // Add reasoning if present
      final reasoning = response.reasoningOutput;
      if (reasoning != null && reasoning.summary != null) {
        assistantMessage.writeln('🤔 **Thinking Process:**');
        for (final item in reasoning.summary!) {
          assistantMessage.writeln('• ${item.text}');
        }
        assistantMessage.writeln();
      }

      // Add main response
      final messageContent = response.messageContent;
      if (messageContent != null) {
        assistantMessage.writeln(messageContent);
      }

      // Add citations if present
      final functionCalls = response.functionCalls;
      if (functionCalls.isNotEmpty) {
        assistantMessage.writeln('\n📚 **Sources:**');
        for (final call in functionCalls) {
          assistantMessage.writeln('• ${call.name}');
        }
      }

      setState(() {
        _messages.add(
          _ResponseMessage.assistant(
            assistantMessage.toString(),
            usage: response.usage,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_ResponseMessage.assistantError('Error: $e'));
        _isLoading = false;
      });
    }
  }

  Future<void> _clearConversation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _messages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responses API (Beta)'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _clearConversation,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear conversation',
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Responses API'),
                  content: const Text(
                    'The Responses API is a stateless API compatible with OpenAI\'s Responses format.\n\n'
                    'Features:\n'
                    '• Reasoning/thinking process display\n'
                    '• Web search integration\n'
                    '• Function calling\n'
                    '• File search\n'
                    '• Stateless - conversation history is maintained client-side',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: Column(
        children: [
          // Feature badges
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureBadge('Reasoning', Icons.psychology),
                _buildFeatureBadge('Web Search', Icons.search),
                _buildFeatureBadge('Function Call', Icons.functions),
                _buildFeatureBadge('Stateless', Icons.cloud_off),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 64,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Responses API Demo',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try asking about current events or\ncomplex reasoning tasks',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageCard(message, theme);
                    },
                  ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thinking...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask anything...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text('Send'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(String label, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(_ResponseMessage message, ThemeData theme) {
    final isUser = message.isUser;
    final isError = message.isError;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Card(
          color: isUser
              ? theme.colorScheme.primaryContainer
              : isError
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUser
                          ? Icons.person
                          : isError
                          ? Icons.error
                          : Icons.smart_toy,
                      size: 16,
                      color: isUser
                          ? theme.colorScheme.onPrimaryContainer
                          : isError
                          ? theme.colorScheme.onErrorContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isUser
                          ? 'You'
                          : isError
                          ? 'Error'
                          : 'Assistant',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isUser
                            ? theme.colorScheme.onPrimaryContainer
                            : isError
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser
                        ? theme.colorScheme.onPrimaryContainer
                        : isError
                        ? theme.colorScheme.onErrorContainer
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (message.usage != null) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  Text(
                    'Tokens: ${message.usage!.inputTokens.toInt()} in / '
                    '${message.usage!.outputTokens.toInt()} out • '
                    'Cost: \$${message.usage!.cost?.toStringAsFixed(4) ?? '0.0000'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponseMessage {
  final String content;
  final bool isUser;
  final bool isError;
  final responses.ResponsesUsage? usage;

  _ResponseMessage.user(this.content)
    : isUser = true,
      isError = false,
      usage = null;

  _ResponseMessage.assistant(this.content, {this.usage})
    : isUser = false,
      isError = false;

  _ResponseMessage.assistantError(this.content)
    : isUser = false,
      isError = true,
      usage = null;

  bool get isAssistant => !isUser && !isError;
}
