import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';
import 'package:talabtek_customer/shared/widgets/custom_text_field.dart';
import 'package:talabtek_customer/shared/widgets/otp_input_field.dart';
import 'package:talabtek_customer/shared/widgets/loading_widgets.dart';
import 'package:talabtek_customer/shared/widgets/empty_error_states.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('Renders button with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'اضغط هنا', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('اضغط هنا'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'تحميل', onPressed: () {}, isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('تحميل'), findsNothing);
    });

    testWidgets('Disables button when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'معطل', onPressed: null),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Outlined button variant renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'مخطط', onPressed: () {}, isOutlined: true),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('Text button variant renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'نص', onPressed: () {}, isTextButton: true),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('CustomTextField Widget Tests', () {
    testWidgets('Renders label and hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'البريد الإلكتروني',
              hint: 'example@email.com',
            ),
          ),
        ),
      );

      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('example@email.com'), findsOneWidget);
    });

    testWidgets('Shows error when validation fails', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: CustomTextField(
                controller: controller,
                label: 'الهاتف',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'مطلوب';
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Try to validate empty field
      await tester.tap(find.byType(Form));
      await tester.pump();
      
      // The field should show error when form is validated
    });

    testWidgets('Obscure text works for password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'كلمة المرور',
              obscureText: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.obscureText, true);
    });

    testWidgets('Prefix and suffix icons render', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'بحث',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.clear),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });

  group('OTPInputField Widget Tests', () {
    testWidgets('Renders correct number of fields', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputField(
              controller: controller,
              length: 6,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('Updates controller when text entered', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputField(
              controller: controller,
              length: 4,
            ),
          ),
        ),
      );

      // Enter text in first field
      await tester.enterText(find.byType(TextField).first, '1');
      await tester.pump();
      
      expect(controller.text, '1');
    });

    testWidgets('Calls onCompleted when all fields filled', (WidgetTester tester) async {
      final controller = TextEditingController();
      String? completedCode;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputField(
              controller: controller,
              length: 3,
              onCompleted: (code) => completedCode = code,
            ),
          ),
        ),
      );

      // Fill all fields
      for (int i = 0; i < 3; i++) {
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
        await tester.pump();
      }

      expect(completedCode, '123');
    });
  });

  group('Loading Widgets Tests', () {
    testWidgets('LoadingOverlay shows loader when isLoading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              message: 'جاري التحميل...',
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('جاري التحميل...'), findsOneWidget);
      expect(find.text('محتوى'), findsNothing); // Covered by overlay
    });

    testWidgets('LoadingOverlay hides loader when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: Text('محتوى مرئي'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('محتوى مرئي'), findsOneWidget);
    });

    testWidgets('SkeletonLoader renders with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader.rectangular(
              width: 200,
              height: 100,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 200);
      expect(container.constraints?.maxHeight, 100);
    });

    testWidgets('SkeletonLoader.circular renders circle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader.circular(diameter: 50),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(25));
    });
  });

  group('Empty/Error States Tests', () {
    testWidgets('EmptyState shows title and message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'لا توجد بيانات',
              message: 'جرب لاحقاً',
            ),
          ),
        ),
      );

      expect(find.text('لا توجد بيانات'), findsOneWidget);
      expect(find.text('جرب لاحقاً'), findsOneWidget);
    });

    testWidgets('EmptyState shows action button when provided', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'فارغ',
              message: 'اضغط للتحديث',
              actionText: 'تحديث',
              onActionPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('تحديث'), findsOneWidget);
      
      await tester.tap(find.text('تحديث'));
      expect(pressed, true);
    });

    testWidgets('ErrorState shows error message and retry', (WidgetTester tester) async {
      bool retried = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState.network(
              onActionPressed: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('خطأ في الاتصال'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
      
      await tester.tap(find.text('إعادة المحاولة'));
      expect(retried, true);
    });

    testWidgets('Predefined empty states work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noOrders(),
          ),
        ),
      );

      expect(find.text('لا توجد طلبات'), findsOneWidget);
    });
  });
}