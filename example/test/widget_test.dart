import 'package:flutter_test/flutter_test.dart';
import 'package:openrouter_example/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OpenRouterDemoApp());

    // Verify that the app builds without errors
    expect(find.byType(OpenRouterDemoApp), findsOneWidget);
  });
}
