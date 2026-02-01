import 'package:flutter/material.dart';
import 'package:openrouter/openrouter.dart';

class ModelsScreen extends StatefulWidget {
  const ModelsScreen({super.key});

  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  OpenRouterClient? _client;
  List<ModelInfo> _models = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeClient();
    _loadModels();
  }

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  void _initializeClient() {
    const apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
    if (apiKey.isNotEmpty) {
      _client = OpenRouterClient(apiKey: apiKey);
    }
  }

  Future<void> _loadModels() async {
    if (_client == null) {
      setState(() {
        _isLoading = false;
        _error = 'API key not configured';
      });
      return;
    }

    try {
      final response = await _client!.listModels();
      setState(() {
        _models = response.data;
        _isLoading = false;
        _error = null;
      });
    } on OpenRouterException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.message;
      });
    }
  }

  List<ModelInfo> get _filteredModels {
    if (_searchQuery.isEmpty) return _models;
    return _models.where((model) {
      final query = _searchQuery.toLowerCase();
      return model.name.toLowerCase().contains(query) ||
          model.id.toLowerCase().contains(query) ||
          model.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Models'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadModels,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search models...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Stats
          if (!_isLoading && _error == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.model_training, size: 18),
                    label: Text('${_filteredModels.length} models'),
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorScheme.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadModels,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _filteredModels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No models found',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredModels.length,
                    itemBuilder: (context, index) {
                      final model = _filteredModels[index];
                      return _ModelCard(
                        model: model,
                        onTap: () => _showModelDetails(model),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showModelDetails(ModelInfo model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    model.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.id,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(model.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),

                  // Stats grid
                  _buildStatsGrid(model),
                  const SizedBox(height: 24),

                  // Capabilities
                  Text(
                    'Capabilities',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: model.architecture.inputModalities
                        .map(
                          (modality) => Chip(
                            avatar: Icon(_getModalityIcon(modality)),
                            label: Text(modality),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Supported parameters
                  Text(
                    'Supported Parameters',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: model.supportedParameters
                        .map(
                          (param) => Chip(
                            label: Text(param),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(ModelInfo model) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          icon: Icons.token,
          title: 'Context',
          value: model.contextLength != null
              ? '${(model.contextLength! / 1000).toStringAsFixed(0)}k'
              : 'Unknown',
        ),
        _StatCard(
          icon: Icons.attach_money,
          title: 'Pricing',
          value: 'Prompt: ${model.pricing.prompt}',
          subtitle: 'Completion: ${model.pricing.completion}',
        ),
        _StatCard(
          icon: model.topProvider.isModerated
              ? Icons.verified_user
              : Icons.warning,
          title: 'Moderated',
          value: model.topProvider.isModerated ? 'Yes' : 'No',
          color: model.topProvider.isModerated ? Colors.green : Colors.orange,
        ),
        _StatCard(
          icon: Icons.calendar_today,
          title: 'Added',
          value: DateTime.fromMillisecondsSinceEpoch(
            model.created.toInt() * 1000,
          ).toString().split(' ')[0],
        ),
      ],
    );
  }

  IconData _getModalityIcon(String modality) {
    switch (modality) {
      case 'text':
        return Icons.text_fields;
      case 'image':
        return Icons.image;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.help;
    }
  }
}

class _ModelCard extends StatelessWidget {
  final ModelInfo model;
  final VoidCallback onTap;

  const _ModelCard({required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      model.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (model.topProvider.isModerated)
                    Icon(
                      Icons.verified_user,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                model.id,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                model.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.token, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    model.contextLength != null
                        ? '${(model.contextLength! / 1000).toStringAsFixed(0)}k context'
                        : 'Unknown context',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '\$${model.pricing.prompt}/1M tokens',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }
}
