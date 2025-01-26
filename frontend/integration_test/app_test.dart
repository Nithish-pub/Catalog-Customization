import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:store_catalog/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify store selection flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on the store selector screen
      expect(find.text('Select Store'), findsOneWidget);

      // Select the first store
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify we're on the product listing screen
      expect(find.text('Products'), findsOneWidget);

      // Test search functionality
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Test filter functionality
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      expect(find.text('Filter Products'), findsOneWidget);
    });
  });
} 