import 'package:flutter/material.dart';
import 'package:openrouter/openrouter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _refererController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  bool _isLoading = false;
  KeyInfoData? _keyInfo;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refererController.text = 'https://openrouter-demo.flutter.dev';
    _titleController.text = 'OpenRouter Flutter Demo';
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _refererController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      _showError('Please enter an API key');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _keyInfo = null;
    });

    try {
      final client = OpenRouterClient(
        apiKey: apiKey,
        defaultHeaders: {
          'HTTP-Referer': _refererController.text,
          'X-Title': _titleController.text,
        },
      );

      final keyInfo = await client.getKeyInfo();

      setState(() {
        _keyInfo = keyInfo.data;
        _isLoading = false;
      });

      client.close();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on OpenRouterException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.message;
      });
      _showError('Connection failed: ${e.message}');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // API Key Section
          _buildSection(
            context,
            title: 'API Configuration',
            icon: Icons.key,
            children: [
              TextField(
                controller: _apiKeyController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'OpenRouter API Key',
                  hintText: 'sk-or-v1-...',
                  prefixIcon: Icon(Icons.vpn_key),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _refererController,
                decoration: const InputDecoration(
                  labelText: 'HTTP Referer',
                  hintText: 'https://yourapp.com',
                  prefixIcon: Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'App Title',
                  hintText: 'My App',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _testConnection,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: Text(_isLoading ? 'Testing...' : 'Test Connection'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Key Info Section
          if (_keyInfo != null)
            _buildSection(
              context,
              title: 'Account Information',
              icon: Icons.account_circle,
              children: [
                _buildInfoRow('Label', _keyInfo!.label),
                _buildInfoRow(
                  'Credits Limit',
                  _keyInfo!.limit != null
                      ? '\$${_keyInfo!.limit!.toStringAsFixed(2)}'
                      : 'Unlimited',
                ),
                _buildInfoRow(
                  'Credits Remaining',
                  _keyInfo!.limitRemaining != null
                      ? '\$${_keyInfo!.limitRemaining!.toStringAsFixed(2)}'
                      : 'N/A',
                ),
                const Divider(),
                _buildInfoRow(
                  'Total Usage',
                  '\$${_keyInfo!.usage.toStringAsFixed(4)}',
                ),
                _buildInfoRow(
                  'Daily Usage',
                  '\$${_keyInfo!.usageDaily.toStringAsFixed(4)}',
                ),
                _buildInfoRow(
                  'Weekly Usage',
                  '\$${_keyInfo!.usageWeekly.toStringAsFixed(4)}',
                ),
                _buildInfoRow(
                  'Monthly Usage',
                  '\$${_keyInfo!.usageMonthly.toStringAsFixed(4)}',
                ),
                const Divider(),
                _buildInfoRow(
                  'Account Type',
                  _keyInfo!.isFreeTier ? 'Free Tier' : 'Paid',
                ),
              ],
            ),

          if (_error != null)
            Card(
              color: colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_error!),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Help Section
          _buildSection(
            context,
            title: 'Getting Started',
            icon: Icons.help,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('Get API Key'),
                subtitle: const Text('OpenRouter Dashboard'),
                onTap: () {
                  // Open https://openrouter.ai/keys
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Documentation'),
                subtitle: const Text('OpenRouter Docs'),
                onTap: () {
                  // Open https://openrouter.ai/docs
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Version info
          Center(
            child: Text(
              'OpenRouter Flutter Demo v1.0.0',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
