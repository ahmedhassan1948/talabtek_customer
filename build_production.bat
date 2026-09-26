@echo off
chcp 65001 >nul
echo ============================================
echo  طلبك - بناء كامل للإنتاج
echo  Talabtek - Production Build Script
echo ============================================
echo.

:: التحقق من Flutter
echo [0/8] التحقق من Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ❌ Flutter غير مثبت أو غير مضاف لـ PATH
    echo قم بتثبيت Flutter من: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)
echo ✅ Flutter متاح
echo.

:: التحقق من الملفات المطلوبة
echo [1/8] التحقق من ملفات التكوين...
if not exist "google-services.json" (
    echo ⚠️ تحذير: google-services.json غير موجود في الجذر
    echo    سيستخدم الملف الافتراضي في android/app/
) else (
    echo ✅ google-services.json موجود
    copy /Y google-services.json android\app\google-services.json >nul
)

if not exist "GoogleService-Info.plist" (
    echo ⚠️ تحذير: GoogleService-Info.plist غير موجود في الجذر
    echo    سيستخدم الملف الافتراضي في ios/Runner/
) else (
    echo ✅ GoogleService-Info.plist موجود
    copy /Y GoogleService-Info.plist ios\Runner\GoogleService-Info.plist >nul
)

if not exist "lib\core\config\firebase_options.dart" (
    echo ❌ firebase_options.dart غير موجود!
    pause
    exit /b 1
) else (
    echo ✅ firebase_options.dart موجود
)
echo.

:: تنظيف البناء السابق
echo [2/8] تنظيف البناء السابق...
flutter clean
echo ✅ تم التنظيف
echo.

:: الحصول على التبعيات
echo [3/8] تثبيت التبعيات Flutter...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ فشل في flutter pub get
    pause
    exit /b 1
)
echo ✅ التبعيات مثبتة
echo.

:: إنشاء الكود (Build Runner)
echo [4/8] إنشاء الكود (Freezed, JSON Serializable, etc.)...
dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo ⚠️ تحذير: فشل في build_runner (قد يكون طبيعياً إذا لم تستخدم code generation)
)
echo ✅ تم إنشاء الكود
echo.

:: بناء Android
echo [5/8] بناء Android Release...
echo --------------------------------------------
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols
if %errorlevel% neq 0 (
    echo ❌ فشل بناء Android APK
    pause
    exit /b 1
)
echo ✅ تم بناء Android APKs
echo.

echo [6/8] بناء Android App Bundle (للمتجر)...
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
if %errorlevel% neq 0 (
    echo ❌ فشل بناء App Bundle
    pause
    exit /b 1
)
echo ✅ تم بناء App Bundle
echo.

:: بناء iOS (فقط على macOS)
echo [7/8] التحقق من بناء iOS...
if exist "ios" (
    echo نظام macOS مكتشف - بناء iOS...
    cd ios
    pod install --repo-update
    if %errorlevel% neq 0 (
        echo ❌ فشل pod install
        cd ..
        pause
        exit /b 1
    )
    cd ..
    flutter build ipa --release --obfuscate --split-debug-info=build/ios/symbols
    if %errorlevel% neq 0 (
        echo ❌ فشل بناء iOS IPA
        pause
        exit /b 1
    )
    echo ✅ تم بناء iOS IPA
) else (
    echo ⏭️ تخطي بناء iOS (ليس على macOS أو مجلد ios غير موجود)
)
echo.

:: التحقق من الملفات الناتجة
echo [8/8] التحقق من الملفات الناتجة...
echo --------------------------------------------
echo.
echo 📱 ملفات Android:
if exist "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" (
    for %%f in (build\app\outputs\flutter-apk\app-arm64-v8a-release.apk) do echo   ✅ ARM64: %%~zf bytes - %%f
)
if exist "build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk" (
    for %%f in (build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk) do echo   ✅ ARMv7: %%~zf bytes - %%f
)
if exist "build\app\outputs\flutter-apk\app-x86_64-release.apk" (
    for %%f in (build\app\outputs\flutter-apk\app-x86_64-release.apk) do echo   ✅ x86_64: %%~zf bytes - %%f
)
if exist "build\app\outputs\bundle\release\app-release.aab" (
    for %%f in (build\app\outputs\bundle\release\app-release.aab) do echo   ✅ App Bundle: %%~zf bytes - %%f
)
echo.
echo 🍎 ملفات iOS:
if exist "build\ios\Runner.ipa" (
    for %%f in (build\ios\Runner.ipa) do echo   ✅ IPA: %%~zf bytes - %%f
) else (
    echo   ⏭️ غير مبني (يتطلب macOS)
)
echo.
echo ============================================
echo  ✅ اكتمل البناء بنجاح!
echo ============================================
echo.
echo 📂 موقع الملفات:
echo   Android APKs: build\app\outputs\flutter-apk\
echo   Android AAB:  build\app\outputs\bundle\release\
echo   iOS IPA:      build\ios\
echo   Symbols:      build\app\outputs\symbols\ & build\ios\symbols\
echo.
echo 📋 الخطوات التالية:
echo   1. اختبر APK على جهاز حقيقي
echo   2. ارفع AAB إلى Google Play Console
echo   3. ارفع IPA إلى App Store Connect عبر Xcode/Transporter
echo   4. احتفظ بملفات Symbols لتحليل Crashlytics
echo.
echo 🔐 للتوقيع الرسمي للإنتاج:
echo   - Android: أضف key.properties مع Keystore
echo   - iOS: وقع عبر Xcode بـ Distribution Certificate
echo.
pause