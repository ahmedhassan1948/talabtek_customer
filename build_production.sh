#!/bin/bash
# طلبك - بناء كامل للإنتاج (macOS/Linux)
# Talabtek - Production Build Script

set -e  # خروج عند أي خطأ

# ألوان للخرج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  طلبك - بناء كامل للإنتاج${NC}"
echo -e "${BLUE}  Talabtek - Production Build Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo

# التحقق من Flutter
echo -e "${YELLOW}[0/8]${NC} التحقق من Flutter..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter غير مثبت أو غير مضاف لـ PATH${NC}"
    echo "قم بتثبيت Flutter من: https://flutter.dev/docs/get-started/install"
    exit 1
fi
flutter --version
echo -e "${GREEN}✅ Flutter متاح${NC}"
echo

# التحقق من الملفات المطلوبة
echo -e "${YELLOW}[1/8]${NC} التحقق من ملفات التكوين..."
if [ ! -f "google-services.json" ]; then
    echo -e "${YELLOW}⚠️ تحذير: google-services.json غير موجود في الجذر${NC}"
    echo "    سيستخدم الملف الافتراضي في android/app/"
else
    echo -e "${GREEN}✅ google-services.json موجود${NC}"
    cp google-services.json android/app/google-services.json
fi

if [ ! -f "GoogleService-Info.plist" ]; then
    echo -e "${YELLOW}⚠️ تحذير: GoogleService-Info.plist غير موجود في الجذر${NC}"
    echo "    سيستخدم الملف الافتراضي في ios/Runner/"
else
    echo -e "${GREEN}✅ GoogleService-Info.plist موجود${NC}"
    cp GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
fi

if [ ! -f "lib/core/config/firebase_options.dart" ]; then
    echo -e "${RED}❌ firebase_options.dart غير موجود!${NC}"
    exit 1
else
    echo -e "${GREEN}✅ firebase_options.dart موجود${NC}"
fi
echo

# تنظيف البناء السابق
echo -e "${YELLOW}[2/8]${NC} تنظيف البناء السابق..."
flutter clean
echo -e "${GREEN}✅ تم التنظيف${NC}"
echo

# الحصول على التبعيات
echo -e "${YELLOW}[3/8]${NC} تثبيت التبعيات Flutter..."
flutter pub get
echo -e "${GREEN}✅ التبعيات مثبتة${NC}"
echo

# إنشاء الكود (Build Runner)
echo -e "${YELLOW}[4/8]${NC} إنشاء الكود (Freezed, JSON Serializable, etc.)..."
dart run build_runner build --delete-conflicting-outputs || echo -e "${YELLOW}⚠️ تحذير: فشل في build_runner (قد يكون طبيعياً)${NC}"
echo -e "${GREEN}✅ تم إنشاء الكود${NC}"
echo

# بناء Android
echo -e "${YELLOW}[5/8]${NC} بناء Android Release..."
echo "--------------------------------------------"
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols
echo -e "${GREEN}✅ تم بناء Android APKs${NC}"
echo

echo -e "${YELLOW}[6/8]${NC} بناء Android App Bundle (للمتجر)..."
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
echo -e "${GREEN}✅ تم بناء App Bundle${NC}"
echo

# بناء iOS (فقط على macOS)
echo -e "${YELLOW}[7/8]${NC} بناء iOS..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "نظام macOS مكتشف - بناء iOS..."
    cd ios
    pod install --repo-update
    cd ..
    flutter build ipa --release --obfuscate --split-debug-info=build/ios/symbols
    echo -e "${GREEN}✅ تم بناء iOS IPA${NC}"
else
    echo -e "${YELLOW}⏭️ تخطي بناء iOS (ليس على macOS)${NC}"
fi
echo

# التحقق من الملفات الناتجة
echo -e "${YELLOW}[8/8]${NC} التحقق من الملفات الناتجة..."
echo "--------------------------------------------"
echo
echo -e "${BLUE}📱 ملفات Android:${NC}"
if [ -f "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" ]; then
    SIZE=$(stat -f%z "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" 2>/dev/null || stat -c%s "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" 2>/dev/null)
    echo -e "   ${GREEN}✅ ARM64:${NC} $(numfmt --to=iec $SIZE 2>/dev/null || echo $SIZE) - build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
fi
if [ -f "build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk" ]; then
    SIZE=$(stat -f%z "build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk" 2>/dev/null || stat -c%s "build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk" 2>/dev/null)
    echo -e "   ${GREEN}✅ ARMv7:${NC} $(numfmt --to=iec $SIZE 2>/dev/null || echo $SIZE) - build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk"
fi
if [ -f "build/app/outputs/flutter-apk/app-x86_64-release.apk" ]; then
    SIZE=$(stat -f%z "build/app/outputs/flutter-apk/app-x86_64-release.apk" 2>/dev/null || stat -c%s "build/app/outputs/flutter-apk/app-x86_64-release.apk" 2>/dev/null)
    echo -e "   ${GREEN}✅ x86_64:${NC} $(numfmt --to=iec $SIZE 2>/dev/null || echo $SIZE) - build/app/outputs/flutter-apk/app-x86_64-release.apk"
fi
if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    SIZE=$(stat -f%z "build/app/outputs/bundle/release/app-release.aab" 2>/dev/null || stat -c%s "build/app/outputs/bundle/release/app-release.aab" 2>/dev/null)
    echo -e "   ${GREEN}✅ App Bundle:${NC} $(numfmt --to=iec $SIZE 2>/dev/null || echo $SIZE) - build/app/outputs/bundle/release/app-release.aab"
fi
echo
echo -e "${BLUE}🍎 ملفات iOS:${NC}"
if [ -f "build/ios/Runner.ipa" ]; then
    SIZE=$(stat -f%z "build/ios/Runner.ipa" 2>/dev/null || stat -c%s "build/ios/Runner.ipa" 2>/dev/null)
    echo -e "   ${GREEN}✅ IPA:${NC} $(numfmt --to=iec $SIZE 2>/dev/null || echo $SIZE) - build/ios/Runner.ipa"
else
    echo -e "   ${YELLOW}⏭️ غير مبني (يتطلب macOS + Xcode)${NC}"
fi
echo
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  ✅ اكتمل البناء بنجاح!${NC}"
echo -e "${BLUE}============================================${NC}"
echo
echo -e "${BLUE}📂 موقع الملفات:${NC}"
echo "   Android APKs: build/app/outputs/flutter-apk/"
echo "   Android AAB:  build/app/outputs/bundle/release/"
echo "   iOS IPA:      build/ios/"
echo "   Symbols:      build/app/outputs/symbols/ & build/ios/symbols/"
echo
echo -e "${BLUE}📋 الخطوات التالية:${NC}"
echo "   1. اختبر APK على جهاز حقيقي"
echo "   2. ارفع AAB إلى Google Play Console"
echo "   3. ارفع IPA إلى App Store Connect عبر Xcode/Transporter"
echo "   4. احتفظ بملفات Symbols لتحليل Crashlytics"
echo
echo -e "${BLUE}🔐 للتوقيع الرسمي للإنتاج:${NC}"
echo "   - Android: أضف key.properties مع Keystore"
echo "   - iOS: وقع عبر Xcode بـ Distribution Certificate"
echo