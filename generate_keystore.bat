@echo off
chcp 65001 >nul
echo ============================================
echo  طلبك - إنشاء Keystore للتوقيع الرسمي
echo  Talabtek - Generate Upload Keystore
echo ============================================
echo.

echo هذا السكريبت ينشئ Keystore للتوقيع الرسمي للإنتاج
echo سيتم حفظه في: android/upload-keystore.jks
echo.

:: التحقق من وجود keytool
where keytool >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ keytool غير موجود في PATH
    echo تأكد من تثبيت JDK وإضافته لـ PATH
    echo عادة ما يكون في: C:\Program Files\Java\jdk-xx\bin
    pause
    exit /b 1
)

echo أدخل المعلومات التالية (يمكن ترك بعضها فارغاً):
echo.

set /p STORE_PASSWORD="كلمة مرور Keystore (min 6 chars): "
if "%STORE_PASSWORD%"=="" (
    echo ❌ كلمة المرور مطلوبة
    pause
    exit /b 1
)

set /p KEY_PASSWORD="كلمة مرور المفتاح (يمكن أن تكون نفس Keystore): "
if "%KEY_PASSWORD%"=="" set KEY_PASSWORD=%STORE_PASSWORD%

set /p KEY_ALIAS="اسم المستعار (alias) [upload]: "
if "%KEY_ALIAS%"=="" set KEY_ALIAS=upload

set /p VALIDITY="صلاحية بالسنوات [25]: "
if "%VALIDITY%"=="" set VALIDITY=25

set /p KEY_SIZE="حجم المفتاح [2048]: "
if "%KEY_SIZE%"=="" set KEY_SIZE=2048

echo.
echo معلومات الهوية (لشهادة التوقيع):
set /p CN="الاسم الشائع (CN) - اسمك/اسم الشركة [Talabtek]: "
if "%CN%"=="" set CN=Talabtek

set /p OU="الوحدة التنظيمية (OU) [Mobile Team]: "
if "%OU%"=="" set OU=Mobile Team

set /p O="المنظمة (O) [Talabtek]: "
if "%O%"=="" set O=Talabtek

set /p L="المدينة (L) [Riyadh]: "
if "%L%"=="" set L=Riyadh

set /p ST="الولاية/المنطقة (ST) [Riyadh]: "
if "%ST%"=="" set ST=Riyadh

set /p C="كود الدولة (C) [SA]: "
if "%C%"=="" set C=SA

echo.
echo ============================================
echo ملخص المعلومات:
echo   Keystore: android/upload-keystore.jks
echo   Store Password: %STORE_PASSWORD%
echo   Key Password: %KEY_PASSWORD%
echo   Alias: %KEY_ALIAS%
echo   Validity: %VALIDITY% years
echo   Key Size: %KEY_SIZE% bits
echo   CN: %CN%
echo   OU: %OU%
echo   O: %O%
echo   L: %L%
echo   ST: %ST%
echo   C: %C%
echo ============================================
echo.

set /p CONFIRM="هل تريد المتابعة؟ (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo تم الإلغاء
    pause
    exit /b 0
)

echo.
echo جاري إنشاء Keystore...
keytool -genkey -v \
    -keystore android/upload-keystore.jks \
    -keyalg RSA \
    -keysize %KEY_SIZE% \
    -validity %VALIDITY% \
    -alias %KEY_ALIAS% \
    -storepass %STORE_PASSWORD% \
    -keypass %KEY_PASSWORD% \
    -dname "CN=%CN%, OU=%OU%, O=%O%, L=%L%, ST=%ST%, C=%C%"

if %errorlevel% neq 0 (
    echo ❌ فشل في إنشاء Keystore
    pause
    exit /b 1
)

echo.
echo ✅ تم إنشاء Keystore بنجاح!
echo.

:: إنشاء ملف key.properties
echo إنشاء android/key.properties...
(
    echo storePassword=%STORE_PASSWORD%
    echo keyPassword=%KEY_PASSWORD%
    echo keyAlias=%KEY_ALIAS%
    echo storeFile=../upload-keystore.jks
) > android/key.properties

echo ✅ تم إنشاء key.properties
echo.

echo ============================================
echo  🎉 اكتمل إنشاء Keystore!
echo ============================================
echo.
echo 📁 الملفات المنشأة:
echo   - android/upload-keystore.jks
echo   - android/key.properties
echo.
echo ⚠️ مهم جداً - احتفظ بنسخة احتياطية آمنة من:
echo   1. android/upload-keystore.jks
echo   2. كلمات المرور (Store & Key Password)
echo   3. هذا الملف لن يتم رفعه لـ Git (مضاف لـ .gitignore)
echo.
echo 📝 لتفعيل التوقيع الرسمي، أضف إلى android/app/build.gradle:
echo.
echo     signingConfigs {
echo         release {
echo             keyAlias keystoreProperties['keyAlias']
echo             keyPassword keystoreProperties['keyPassword']
echo             storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
echo             storePassword keystoreProperties['storePassword']
echo         }
echo     }
echo     buildTypes {
echo         release {
echo             signingConfig signingConfigs.release
echo             ...
echo         }
echo     }
echo.
pause