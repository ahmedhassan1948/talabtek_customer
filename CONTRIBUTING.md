# دليل المساهمة في طلبك
# Contributing to Talabtek

شكراً لاهتمامك بالمساهمة في طلبك! نرحب بجميع المساهمات سواء كانت إصلاح أخطاء، ميزات جديدة، تحسينات في الأداء، أو توثيق.

## 🚀 بداية سريعة

### المتطلبات
- Flutter SDK 3.19+
- Dart 3.3+
- Android Studio / VS Code
- Git
- Firebase CLI (للتطوير مع Firebase)

### إعداد بيئة التطوير

```bash
# 1. استنساخ المستودع
git clone https://github.com/your-org/talabtek_customer.git
cd talabtek_customer

# 2. تثبيت التبعيات
flutter pub get

# 3. تثبيت Pods (لـ iOS)
cd ios && pod install --repo-update && cd ..

# 4. تشغيل مولدات الكود
dart run build_runner build --delete-conflicting-outputs

# 5. تشغيل التطبيق
flutter run
```

## 📋 معايير الكود

### تنسيق الكود
نستخدم `dart format` للتنسيق التلقائي:
```bash
# تنسيق جميع الملفات
dart format .

# التحقق من التنسيق فقط
dart format --output=none --set-exit-if-changed .
```

### تحليل الكود
```bash
flutter analyze
```

يجب أن يمر الكود بالتحليل بدون أخطاء (`error`). التحذيرات (`warning`) مقبولة لكن يفضل إصلاحها.

### قواعد التسمية
- **ملفات**: `snake_case.dart` (مثال: `custom_button.dart`)
- **فئات**: `PascalCase` (مثال: `CustomButton`)
- **دوال/متغيرات**: `camelCase` (مثال: `onButtonPressed`)
- **ثوابت**: `SCREAMING_SNAKE_CASE` (مثال: `MAX_RETRY_COUNT`)
- **خاصية خاصة**: تبدأ بـ `_` (مثال: `_internalState`)

### التعليقات
```dart
/// ملخص قصير للدالة/الفئة
/// 
/// شرح مفصل إذا لزم الأمر
/// 
/// مثال:
/// ```dart
/// final result = calculateTotal(items);
/// ```
/// 
/// See also:
///  * [relatedFunction] للدوال ذات الصلة
///  * [DocumentationLink](https://example.com) للتوثيق الخارجي
int calculateTotal(List<Item> items) { ... }
```

## 🔄 سير عمل المساهمة

### 1. إنشاء فرع
```bash
# تحديث main
git checkout main
git pull origin main

# إنشاء فرع جديد
git checkout -b feature/amazing-feature
# أو للإصلاح
git checkout -b fix/bug-description
# أو للتحسين
git checkout -b improve/performance-optimization
```

### 2. إجراء التغييرات
- اكتب كود نظيف وقابل للقراءة
- أضف اختبارات للميزات الجديدة
- حدث التوثيق إذا لزم الأمر
- تأكد من نجاح جميع الاختبارات

### 3. الالتزام (Commits)
استخدم رسائل واضحة ومعيارية:
```bash
# تنسيق: <النوع>(<النطاق>): <الوصف>

# أمثلة:
git commit -m "feat(auth): add Google Sign-In support"
git commit -m "fix(cart): resolve duplicate item issue"
git commit -m "improve(performance): optimize image loading"
git commit -m "docs(readme): update setup instructions"
git commit -m "refactor(cart): simplify state management"
git commit -m "test(cart): add unit tests for CartModel"
git commit -m "chore(deps): upgrade flutter to 3.19"
```

### أنواع الالتزام:
| النوع | الوصف |
|--------|---------|
| `feat` | ميزة جديدة |
| `fix` | إصلاح خطأ |
| `improve` | تحسين أداء/كود موجود |
| `docs` | تحديث التوثيق |
| `refactor` | إعادة هيكلة الكود دون تغيير الوظيفة |
| `test` | إضافة/تعديل اختبارات |
| `chore` | مهام صيانة (تبعيات، إعدادات) |
| `style` | تنسيق فقط (مسافات، فواصل) |
| `perf` | تحسين أداء محدد |

### 4. دفع التغييرات
```bash
git push origin feature/amazing-feature
```

### 5. إنشاء Pull Request
- انتقل إلى GitHub وأنشئ PR
- املأ قالب PR
- اربط Issues ذات الصلة: `Closes #123`
- اطلب مراجعة من الفريق

## 🧪 الاختبارات

### تشغيل الاختبارات
```bash
# جميع الاختبارات
flutter test

# اختبارات محددة
flutter test test/models_test.dart
flutter test test/widgets_test.dart

# مع التغطية
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### كتابة اختبارات جديدة
```dart
// test/features/cart_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:talabtek_customer/features/cart/cart_provider.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider provider;

    setUp(() {
      provider = CartProvider();
    });

    test('should add item to cart', () {
      // Arrange
      final item = CartItemModel(...);
      
      // Act
      provider.addItem(item);
      
      // Assert
      expect(provider.itemCount, 1);
    });
  }
}
```

### معايير الاختبار
- تغطية 80%+ للكود الجديد
- اختبارات وحدة للوحدات المنعزلة
- اختبارات ويدجت لواجهات المستخدم
- اختبارات تكامل للمسارات الحرجة

## 📦 إدارة التبعيات

### إضافة تبعية جديدة
```bash
flutter pub add package_name
# أو للتبعية تطويرية
flutter pub add --dev package_name
```

### تحديث التبعيات
```bash
flutter pub upgrade
flutter pub upgrade --major-versions  # للترقيات الرئيسية
```

### قواعد التبعيات
- تفضل الحزم الرسمية والموثوقة
- تجنب التبعيات غير الضرورية
- ثبت الإصدارات في `pubspec.lock`
- راجع التبعيات دورياً للأمان

## 🔒 الأمان

### متغيرات البيئة
- لا تضع مفاتيح حقيقية في الكود
- استخدم `--dart-define` أو `.env` (غير مرفوع للـ Git)
- راجع `.env.example` للمتغيرات المطلوبة

### مفاتيح API
- مفاتيح Firebase في `firebase_options.dart`
- مفاتيح Google Maps في `AndroidManifest.xml` و `Info.plist`
- مفاتيح الدفع في متغيرات البيئة

## 📱 دعم المنصات

### Android
- Min SDK: 21
- Target SDK: 34
- arquitectures: arm64-v8a, armeabi-v7a, x86_64

### iOS
- Min iOS: 13.0
- Architectures: arm64
- Xcode 15+

### Web (اختياري)
- Flutter Web مع CanvasKit renderer
- PWA support

## 🐛 الإبلاغ عن الأخطاء

### قالب Issue
```markdown
**الوصف:**
وصف واضح ومختصر للخطأ.

**خطوات التكرار:**
1. اذهب إلى '...'
2. اضغط على '....'
3. مرر لأسفل إلى '....'
4. شاهد الخطأ

**السلوك المتوقع:**
وصف واضح لما يجب أن يحدث.

**لقطات الشاشة:**
إن أمكن، أضف لقطات شاشة.

**البيئة:**
- الجهاز: [مثال: iPhone 15, Samsung Galaxy S23]
- نظام التشغيل: [مثال: iOS 17.2, Android 14]
- إصدار التطبيق: [مثال: 1.0.0]
- إصدار Flutter: [flutter --version]

**معلومات إضافية:**
أي سياق إضافي أو إعدادات.
```

## 📝 أسلوب التوثيق

### README
- احتفظ بـ README محدثاً
- أضف أمثلة استخدام
- وثق المتطلبات والخطوات

### تعليقات الكود
- دوال عامة: وثق بـ `///`
- منطق معقد: أضف تعليقات داخلية
- TODO/FIXME: استخدم `// TODO:` و `// FIXME:`

## 🏷️ الإصدار

نتبع [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH` (مثال: `1.2.3`)
- `MAJOR`: تغييرات كاسرة
- `MINOR`: ميزات جديدة متوافقة
- `PATCH`: إصلاحات أخطاء

## 🤝 مدونة السلوك

- كن محترماً وشاملاً
- تقبل النقد البناء
- ركز على الأفضل للمجتمع
- أظهر التعاطف مع المساهمين الآخرين

## 📞 التواصل

- Issues: للإبلاغ عن أخطاء وطلب ميزات
- Discussions: للأسئلة والنقاشات العامة
- Email: dev@talabtek.com للاستفسارات الخاصة

---

شكراً لمساهمتك في جعل طلبك أفضل! 🎉