# طلبك - تطبيق توصيل الطعام والمنتجات

تطبيق Flutter متكامل لطلب الطعام والمنتجات مع دعم كامل للغة العربية و RTL.

## المميزات الرئيسية

### 🔐 المصادقة
- تسجيل الدخول بـ Google / Apple
- تسجيل الدخول برقم الهاتف مع OTP
- تسجيل الدخول بالبريد الإلكتروني
- وضع الزائر (Guest Mode)
- إدارة الملف الشخصي

### 🏠 الشاشة الرئيسية
- بنرات ترويجية متحركة
- تصنيفات رئيسية (مطاعم، سوبرماركت، صيدليات، مستلزمات طبية، توصيل طرود)
- بحث ذكي مع اقتراحات
- فلترة متقدمة
- عروض خاطفة (Flash Sales)
- المطاعم الأكثر طلباً
- مطاعم قريبة منك

### 🍽️ المطاعم والقوائم
- عرض تفصيلي للمطعم مع الصور والتقييمات
- تخصيص الطلبات (إضافات، استبعاد مكونات، أحجام)
- خيارات متعددة لكل منتج
- معلومات غذائية وحساسية
- تقييمات ومراجعات

### 🛒 سلة التسوق والدفع
- سلة ذكية تدعم مطاعم متعددة
- كوبونات خصم
- ملاحظات للمطعم والسائق
- طرق دفع متعددة:
  - نقداً عند الاستلام
  - بطاقات مدى / فيزا / ماستركارد
  - Apple Pay / Google Pay
  - محفظة إلكترونية داخل التطبيق
- ملخص شفاف للتكلفة

### 📍 تتبع الطلب
- تتبع مباشر على الخريطة (GPS)
- مراحل الطلب: تم القبول → جاري التحضير → استلم السائق → في الطريق
- تواصل مباشر مع السائق (شات / اتصال)
- إشعارات لحظية

### ⭐ التقييم والدعم
- تقييم مزدوج: جودة الطعام + سرعة التوصيل
- شات مباشر مع خدمة العملاء
- مركز مساعدة شامل (FAQ، اتصل بنا، واتساب)
- إبلاغ عن مشاكل

### 👤 الملف الشخصي
- العناوين المحفوظة مع خريطة تفاعلية
- طرق الدفع المحفوظة
- المحفظة الإلكترونية ونقاط الولاء
- سجل الطلبات
- المفضلة
- الإعدادات

## البنية التقنية

### التقنيات المستخدمة
- **Flutter 3.x** مع Dart 3.x
- **Firebase** (Auth, Firestore, Storage, Messaging, Analytics, Crashlytics)
- **Provider** لإدارة الحالة
- **Dio** للشبكة
- **Google Maps** للخرائط والموقع
- **Cached Network Image** للصور
- **Lottie** للرسوم المتحركة
- **Shimmer** لتأثيرات التحميل
- **Flutter ScreenUtil** للاستجابة

### هيكل المشروع
```
lib/
├── core/
│   ├── config/          # إعدادات التطبيق و Firebase
│   ├── constants/       # الثوابت والرسائل
│   ├── theme/           # الثيم والألوان
│   └── utils/           # الراوتر والأدوات
├── features/
│   ├── auth/            # شاشات المصادقة
│   ├── home/            # الشاشة الرئيسية
│   ├── restaurant/      # المطاعم والقوائم
│   ├── cart/            # سلة التسوق والدفع
│   ├── order/           # تتبع الطلبات
│   ├── profile/         # الملف الشخصي
│   ├── notifications/   # الإشعارات
│   └── support/         # مركز المساعدة
├── shared/
│   ├── models/          # نماذج البيانات
│   ├── providers/       # Providers للحالة
│   ├── services/        # خدمات API والتخزين
│   └── widgets/         # ويدجتس مشتركة
└── main.dart
```

## الإعداد والتشغيل

### المتطلبات
- Flutter SDK 3.2+
- Dart 3.0+
- Android Studio / VS Code
- Firebase Project

### 1. استنساخ المشروع
```bash
git clone <repository-url>
cd talabtek_customer
```

### 2. تثبيت التبعيات
```bash
flutter pub get
```

### 3. إعداد Firebase
1. أنشئ مشروع Firebase جديد
2. أضف تطبيق Android (package: com.talabtek.customer)
3. أضف تطبيق iOS (bundle ID: com.talabtek.customer)
4. فعّل الخدمات:
   - Authentication (Phone, Email, Google, Apple, Anonymous)
   - Firestore Database
   - Storage
   - Cloud Messaging
   - Analytics
   - Crashlytics
5. حمل `google-services.json` وضعه في `android/app/`
6. حمل `GoogleService-Info.plist` وضعه في `ios/Runner/`
7. حدّث `lib/core/config/firebase_options.dart` بمفاتيحك

### 4. إعداد Google Maps
1. فعّل Maps SDK for Android و iOS في Google Cloud Console
2. أضف API Key في:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/AppDelegate.swift`

### 5. تشغيل التطبيق
```bash
flutter run
```

## إعدادات البناء

### Android
```gradle
// android/app/build.gradle
minSdkVersion 21
targetSdkVersion 34
```

### iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج لموقعك لتحديد عنوان التوصيل</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>نحتاج لموقعك لتحديد عنوان التوصيل</string>
<key>NSCameraUsageDescription</key>
<string>نحتاج للكاميرا لمسح البطاقات</string>
```

## الترجمة

يدعم التطبيق اللغتين:
- العربية (الافتراضية) - `ar_SA`
- الإنجليزية - `en_US`

أضف ملفات الترجمة في `assets/translations/`:
- `ar_SA.arb`
- `en_US.arb`

## التكوين

### متغيرات البيئة
أنشئ ملف `.env` في الجذر:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
GOOGLE_MAPS_API_KEY=your_maps_key
ADMIN_API_URL=https://talabtek.com/admin
```

### Firebase Collections Structure
```
users/{userId}
  - name, email, phone, photoUrl
  - addresses/{addressId}
  - paymentMethods/{methodId}
  - wallet
  - loyalty
  - notifications/{notificationId}

restaurants/{restaurantId}
  - name, description, images
  - location (GeoPoint)
  - openingHours
  - products/{productId}
  - categories

orders/{orderId}
  - userId, restaurantId
  - items[]
  - status, timestamps
  - deliveryAddress
  - paymentMethod
  - driver (subcollection)

categories/{categoryId}
  - name, icon, imageUrl, order
```

## النشر

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS IPA
```bash
flutter build ipa --release
```

## الاختبار

```bash
# تشغيل الاختبارات
flutter test

# تحليل الكود
flutter analyze

# فحص الأداء
flutter run --profile
```

## المساهمة

1. Fork المشروع
2. أنشئ فرع للميزة (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push للفرع (`git push origin feature/amazing-feature`)
5. افتح Pull Request

## الترخيص

هذا المشروع مرخص تحت رخصة MIT - راجع ملف `LICENSE` للتفاصيل.

## الدعم

للاستفسارات والدعم التقني:
- البريد الإلكتروني: dev@talabtek.com
- تويتر: @talabtek_dev