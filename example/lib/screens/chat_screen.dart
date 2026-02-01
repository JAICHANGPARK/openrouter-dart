import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openrouter/openrouter.dart';
import 'package:openrouter_example/widgets/chat_bubble.dart';
import 'package:openrouter_example/widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  OpenRouterClient? _client;
  bool _isLoading = false;
  bool _isStreaming = false;
  String _selectedModel = 'openai/gpt-3.5-turbo';
  double _temperature = 1.0;
  int _maxTokens = 1000;

  // Available models for quick selection
  final List<Map<String, String>> _quickModels = [
    {'id': 'openai/gpt-3.5-turbo', 'name': 'GPT-3.5 Turbo'},
    {'id': 'openai/gpt-4o', 'name': 'GPT-4o'},
    {'id': 'anthropic/claude-3.5-sonnet', 'name': 'Claude 3.5 Sonnet'},
    {'id': 'google/gemini-pro', 'name': 'Gemini Pro'},
    {'id': 'meta-llama/llama-3.1-70b-instruct', 'name': 'Llama 3.1 70B'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeClient();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _client?.close();
    super.dispose();
  }

  void _initializeClient() {
    // In a real app, load this from secure storage or environment
    const apiKey = String.fromEnvironment('OPENROUTER_API_KEY');

    if (apiKey.isNotEmpty) {
      _client = OpenRouterClient(
        apiKey: apiKey,
        defaultHeaders: {
          'HTTP-Referer': 'https://openrouter-demo.flutter.dev',
          'X-Title': 'OpenRouter Flutter Demo',
        },
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (_client == null) {
      _showError('Please configure your API key in Settings');
      return;
    }

    setState(() {
      _messages.add({
        'role': 'user',
        'content': message,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      final messages = _messages
          .where((m) => m['role'] != 'system')
          .map(
            (m) => Message(
              role: m['role'] == 'user'
                  ? MessageRole.user
                  : MessageRole.assistant,
              content: m['content'] as String,
            ),
          )
          .toList();

      final stream = _client!.streamChatCompletion(
        ChatRequest(
          model: _selectedModel,
          messages: messages,
          temperature: _temperature,
          maxTokens: _maxTokens,
          stream: true,
        ),
      );

      setState(() {
        _isStreaming = true;
        _messages.add({
          'role': 'assistant',
          'content': '',
          'timestamp': DateTime.now(),
          'isStreaming': true,
        });
      });

      String fullResponse = '';

      await for (final chunk in stream) {
        final content = chunk.choices.firstOrNull?.delta?.content;
        if (content != null) {
          fullResponse += content;
          setState(() {
            _messages.last['content'] = fullResponse;
          });
          _scrollToBottom();
        }
      }

      setState(() {
        _messages.last['isStreaming'] = false;
        _isStreaming = false;
        _isLoading = false;
      });
    } on OpenRouterException catch (e) {
      setState(() {
        _isLoading = false;
        _isStreaming = false;
        _messages.removeLast();
      });
      _showError('${e.runtimeType}: ${e.message}');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isStreaming = false;
        _messages.removeLast();
      });
      _showError('Unexpected error: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showModelSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Model',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _quickModels.length,
                itemBuilder: (context, index) {
                  final model = _quickModels[index];
                  final isSelected = model['id'] == _selectedModel;

                  return ListTile(
                    leading: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF6C63FF),
                          )
                        : const Icon(Icons.circle_outlined),
                    title: Text(model['name']!),
                    subtitle: Text(
                      model['id']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedModel = model['id']!;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTemperatureSlider(),
              const SizedBox(height: 16),
              _buildMaxTokensSlider(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Temperature'),
            Text(
              _temperature.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: _temperature,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          label: _temperature.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _temperature = value;
            });
          },
        ),
        Text(
          'Lower = more focused, Higher = more creative',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildMaxTokensSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Max Tokens'),
            Text(
              _maxTokens.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: _maxTokens.toDouble(),
          min: 100,
          max: 4000,
          divisions: 39,
          label: _maxTokens.toString(),
          onChanged: (value) {
            setState(() {
              _maxTokens = value.round();
            });
          },
        ),
        Text(
          'Maximum response length',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat?'),
        content: const Text(
          'This will delete all messages. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenRouter Chat'),
        actions: [
          // Model selector button
          TextButton.icon(
            onPressed: _showModelSelector,
            icon: const Icon(Icons.model_training, size: 18),
            label: Text(
              _quickModels.firstWhere(
                (m) => m['id'] == _selectedModel,
                orElse: () => {'name': 'Select Model'},
              )['name']!,
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select a model and type a message',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message['role'] == 'user';
                      final isStreaming = message['isStreaming'] ?? false;

                      return ChatBubble(
                        content: message['content'] as String,
                        isUser: isUser,
                        isStreaming: isStreaming,
                        timestamp: message['timestamp'] as DateTime,
                        onCopy: () =>
                            _copyMessage(message['content'] as String),
                      );
                    },
                  ),
          ),

          // Typing indicator
          if (_isLoading && !_isStreaming)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  TypingIndicator(color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Thinking...',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !_isLoading,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: _isLoading
                            ? 'Waiting for response...'
                            : 'Type a message...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton.small(
                    onPressed: _isLoading ? null : _sendMessage,
                    elevation: 0,
                    backgroundColor: _isLoading
                        ? Colors.grey.shade300
                        : colorScheme.primary,
                    foregroundColor: _isLoading
                        ? Colors.grey.shade600
                        : colorScheme.onPrimary,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
