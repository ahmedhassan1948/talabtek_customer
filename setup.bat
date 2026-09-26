@echo off
echo ============================================
echo  طلبك - إعداد المشروع
echo ============================================
echo.

echo [1/6] نسخ ملفات التكوين...
if exist google-services.json (
    copy google-services.json android\app\google-services.json
    echo ✓ google-services.json تم نسخه
) else (
    echo ✗ google-services.json غير موجود في الجذر
)

if exist GoogleService-Info.plist (
    copy GoogleService-Info.plist ios\Runner\GoogleService-Info.plist
    echo ✓ GoogleService-Info.plist تم نسخه
) else (
    echo ✗ GoogleService-Info.plist غير موجود في الجذر
)

echo.
echo [2/6] تثبيت تبعيات Flutter...
flutter pub get

echo.
echo [3/6] تثبيت Pods iOS...
cd ios && pod install --repo-update && cd ..

echo.
echo [4/6] إنشاء ملف firebase_options.dart...
echo يرجى تحديث lib/core/config/firebase_options.dart بمفاتيحك الحقيقية

echo.
echo [5/6] فحص الكود...
flutter analyze

echo.
echo [6/6] تشغيل الاختبارات...
flutter test

echo.
echo ============================================
echo  تم الإعداد! 🎉
echo ============================================
echo.
echo الخطوات التالية:
echo 1. أضف google-services.json و GoogleService-Info.plist من Firebase Console
echo 2. حدث firebase_options.dart بمفاتيحك
echo 3. أضف Google Maps API Key في AndroidManifest.xml و Info.plist
echo 4. شغل: flutter run
echo.
pause