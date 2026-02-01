// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openrouter/openrouter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('OpenRouter client initialization test', (
    WidgetTester tester,
  ) async {
    // Create a client (without a real API key, just testing initialization)
    final client = OpenRouterClient(apiKey: 'test-api-key');

    // Verify client was created successfully
    expect(client, isNotNull);

    // Clean up
    client.close();
  });
}
