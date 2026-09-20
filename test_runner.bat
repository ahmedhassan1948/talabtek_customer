@echo off
chcp 65001 >nul
echo ============================================
echo  طلبك - تشغيل الاختبارات
echo  Talabtek - Test Runner
echo ============================================
echo.

echo اختر نوع الاختبار:
echo.
echo 1. اختبارات الوحدة (Unit Tests)
echo 2. اختبارات الويدجت (Widget Tests)
echo 3. اختبارات التكامل (Integration Tests) - يتطلب جهاز/محاكي
echo 4. جميع الاختبارات مع التغطية
echo 5. تحليل الكود (flutter analyze)
echo 6. تنسيق الكود (dart format)
echo 7. فحص شامل (Analyze + Format + Test)
echo.

set /p CHOICE="اختر رقم (1-7): "

if "%CHOICE%"=="1" goto unit_tests
if "%CHOICE%"=="2" goto widget_tests
if "%CHOICE%"=="3" goto integration_tests
if "%CHOICE%"=="4" goto all_tests
if "%CHOICE%"=="5" goto analyze
if "%CHOICE%"=="6" goto format
if "%CHOICE%"=="7" goto full_check

echo اختيار غير صحيح
pause
exit /b 1

:unit_tests
echo.
echo [1/1] تشغيل اختبارات الوحدة...
flutter test test/models_test.dart --reporter=expanded
goto end

:widget_tests
echo.
echo [1/1] تشغيل اختبارات الويدجت...
flutter test test/widgets_test.dart --reporter=expanded
goto end

:integration_tests
echo.
echo [1/1] تشغيل اختبارات التكامل...
echo تأكد من تشغيل محاكي أو توصيل جهاز حقيقي
flutter test integration_test/app_flow_test.dart -d %DEVICE_ID%
goto end

:all_tests
echo.
echo [1/3] تشغيل جميع الاختبارات مع التغطية...
flutter test --coverage --reporter=expanded
echo.
echo [2/3] إنشاء تقرير التغطية...
if exist coverage\lcov.info (
    genhtml coverage\lcov.info -o coverage\html
    echo تقرير HTML متاح في: coverage\html\index.html
) else (
    echo لم يتم العثور على ملف التغطية
)
goto end

:analyze
echo.
echo [1/1] تحليل الكود...
flutter analyze
if %errorlevel% equ 0 (
    echo ✅ لا توجد مشاكل
) else (
    echo ❌ توجد مشاكل تحتاج إصلاح
)
goto end

:format
echo.
echo [1/1] تنسيق الكود...
dart format --output=none --set-exit-if-changed .
if %errorlevel% equ 0 (
    echo ✅ الكود منسق بشكل صحيح
) else (
    echo ❌ يحتاج تنسيق - شغل: dart format .
)
goto end

:full_check
echo.
echo ============================================
echo  فحص شامل
echo ============================================
echo.
echo [1/4] تنسيق الكود...
dart format --output=none --set-exit-if-changed .
if %errorlevel% neq 0 (
    echo ❌ فشل التنسيق
    goto end
)
echo ✅ تم التنسيق
echo.

echo [2/4] تحليل الكود...
flutter analyze
if %errorlevel% neq 0 (
    echo ❌ فشل التحليل
    goto end
)
echo ✅ تم التحليل
echo.

echo [3/4] اختبارات الوحدة والويدجت...
flutter test test/models_test.dart test/widgets_test.dart --reporter=expanded
if %errorlevel% neq 0 (
    echo ❌ فشلت الاختبارات
    goto end
)
echo ✅ نجحت الاختبارات
echo.

echo [3/4] إنشاء التغطية...
flutter test --coverage
if %errorlevel% neq 0 (
    echo ❌ فشل إنشاء التغطية
    goto end
)
echo ✅ تم إنشاء التغطية
echo.

echo [4/4] فحص اكتمل بنجاح! 🎉
echo.

:end
echo.
echo ============================================
pause