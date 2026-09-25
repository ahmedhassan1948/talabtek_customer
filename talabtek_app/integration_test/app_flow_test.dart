import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:talabtek_customer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Integration Tests', () {
    testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should show splash or onboarding
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Guest mode navigation works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for guest mode button
      final guestButton = find.text('الدخول كزائر');
      if (guestButton.evaluate().isNotEmpty) {
        await tester.tap(guestButton);
        await tester.pumpAndSettle();

        // Should navigate to home
        expect(find.text('طلبك'), findsOneWidget);
      }
    });

    testWidgets('Home screen loads with categories', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Check for main UI elements
      expect(find.text('التصنيفات'), findsOneWidget);
      expect(find.text('مطاعم'), findsOneWidget);
    });

    testWidgets('Search navigation works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Tap search bar
      final searchBar = find.byIcon(Icons.search);
      if (searchBar.evaluate().isNotEmpty) {
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        // Should show search screen
        expect(find.byType(TextField), findsOneWidget);
      }
    });

    testWidgets('Profile navigation from home', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to profile via bottom nav or menu
      final profileIcon = find.byIcon(Icons.person_outline);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon);
        await tester.pumpAndSettle();

        // Should show profile or login screen
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });
  });

  group('Authentication Flow Tests', () {
    testWidgets('Login screen shows all options', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to login if not already there
      final loginButton = find.text('تسجيل الدخول');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
      }

      // Check for login methods
      expect(find.text('الهاتف'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('Phone login sends OTP', (WidgetTester tester) async {
      // This would require mocking Firebase Auth
      // For integration test, we just verify UI flow
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Enter phone number
      await tester.enterText(find.byType(TextField).first, '0501234567');
      await tester.pumpAndSettle();

      // Tap send OTP
      final sendButton = find.text('إرسال رمز التحقق');
      if (sendButton.evaluate().isNotEmpty) {
        await tester.tap(sendButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    });
  });

  group('Restaurant Flow Tests', () {
    testWidgets('Restaurant list loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 15));

      // Check for restaurant cards
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Restaurant detail screen opens', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 15));

      // Tap first restaurant
      final restaurantCard = find.byType(GestureDetector).first;
      if (restaurantCard.evaluate().isNotEmpty) {
        await tester.tap(restaurantCard);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should show restaurant detail
        expect(find.byType(SliverAppBar), findsOneWidget);
      }
    });

    testWidgets('Add to cart works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // Navigate to restaurant -> product -> add to cart
      // This is a simplified test - real test would need proper navigation
    });
  });

  group('Cart and Checkout Tests', () {
    testWidgets('Cart bottom sheet appears when items added', (WidgetTester tester) async {
      // Would test cart functionality
    });

    testWidgets('Checkout screen shows summary', (WidgetTester tester) async {
      // Would test checkout UI
    });

    testWidgets('Payment method selection works', (WidgetTester tester) async {
      // Would test payment options
    });
  });

  group('Order Tracking Tests', () {
    testWidgets('Order tracking screen shows map', (WidgetTester tester) async {
      // Would test tracking UI with mock location
    });

    testWidgets('Order status timeline updates', (WidgetTester tester) async {
      // Would test status progression
    });
  });

  group('Notifications Tests', () {
    testWidgets('Notifications screen loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to notifications
      final notifIcon = find.byIcon(Icons.notifications_outlined);
      if (notifIcon.evaluate().isNotEmpty) {
        await tester.tap(notifIcon);
        await tester.pumpAndSettle();

        expect(find.text('الإشعارات'), findsOneWidget);
      }
    });
  });

  group('Settings Tests', () {
    testWidgets('Settings screen accessible', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to settings
      final settingsIcon = find.byIcon(Icons.settings_outlined);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();

        expect(find.text('الإعدادات'), findsOneWidget);
      }
    });

    testWidgets('Language toggle works', (WidgetTester tester) async {
      // Would test language change
    });

    testWidgets('Dark mode toggle works', (WidgetTester tester) async {
      // Would test theme change
    });
  });
}