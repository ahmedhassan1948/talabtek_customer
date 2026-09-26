#!/bin/bash
# طلبك - إنشاء Keystore للتوقيع الرسمي (macOS/Linux)
# Talabtek - Generate Upload Keystore

set -e

# ألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  طلبك - إنشاء Keystore للتوقيع الرسمي${NC}"
echo -e "${BLUE}  Talabtek - Generate Upload Keystore${NC}"
echo -e "${BLUE}============================================${NC}"
echo

# التحقق من keytool
if ! command -v keytool &> /dev/null; then
    echo -e "${RED}❌ keytool غير موجود في PATH${NC}"
    echo "تأكد من تثبيت JDK وإضافته لـ PATH"
    exit 1
fi

echo "هذا السكريبت ينشئ Keystore للتوقيع الرسمي للإنتاج"
echo "سيتم حفظه في: android/upload-keystore.jks"
echo

# قراءة المدخلات
read -s -p "كلمة مرور Keystore (min 6 chars): " STORE_PASSWORD
echo
if [ -z "$STORE_PASSWORD" ]; then
    echo -e "${RED}❌ كلمة المرور مطلوبة${NC}"
    exit 1
fi

read -s -p "كلمة مرور المفتاح (Enter للـ Store Password): " KEY_PASSWORD
echo
if [ -z "$KEY_PASSWORD" ]; then
    KEY_PASSWORD=$STORE_PASSWORD
fi

read -p "اسم المستعار (alias) [upload]: " KEY_ALIAS
KEY_ALIAS=${KEY_ALIAS:-upload}

read -p "صلاحية بالسنوات [25]: " VALIDITY
VALIDITY=${VALIDITY:-25}

read -p "حجم المفتاح [2048]: " KEY_SIZE
KEY_SIZE=${KEY_SIZE:-2048}

echo
echo "معلومات الهوية (لشهادة التوقيع):"
read -p "الاسم الشائع (CN) - اسمك/اسم الشركة [Talabtek]: " CN
CN=${CN:-Talabtek}

read -p "الوحدة التنظيمية (OU) [Mobile Team]: " OU
OU=${OU:-Mobile Team}

read -p "المنظمة (O) [Talabtek]: " O
O=${O:-Talabtek}

read -p "المدينة (L) [Riyadh]: " L
L=${L:-Riyadh}

read -p "الولاية/المنطقة (ST) [Riyadh]: " ST
ST=${ST:-Riyadh}

read -p "كود الدولة (C) [SA]: " C
C=${C:-SA}

echo
echo -e "${BLUE}============================================${NC}"
echo "ملخص المعلومات:"
echo "   Keystore: android/upload-keystore.jks"
echo "   Store Password: $STORE_PASSWORD"
echo "   Key Password: $KEY_PASSWORD"
echo "   Alias: $KEY_ALIAS"
echo "   Validity: $VALIDITY years"
echo "   Key Size: $KEY_SIZE bits"
echo "   CN: $CN"
echo "   OU: $OU"
echo "   O: $O"
echo "   L: $L"
echo "   ST: $ST"
echo "   C: $C"
echo -e "${BLUE}============================================${NC}"
echo

read -p "هل تريد المتابعة؟ (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "تم الإلغاء"
    exit 0
fi

echo
echo "جاري إنشاء Keystore..."
keytool -genkey -v \
    -keystore android/upload-keystore.jks \
    -keyalg RSA \
    -keysize $KEY_SIZE \
    -validity $VALIDITY \
    -alias $KEY_ALIAS \
    -storepass $STORE_PASSWORD \
    -keypass $KEY_PASSWORD \
    -dname "CN=$CN, OU=$OU, O=$O, L=$L, ST=$ST, C=$C"

echo
echo -e "${GREEN}✅ تم إنشاء Keystore بنجاح!${NC}"
echo

# إنشاء ملف key.properties
echo "إنشاء android/key.properties..."
cat > android/key.properties <<EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=../upload-keystore.jks
EOF

echo -e "${GREEN}✅ تم إنشاء key.properties${NC}"
echo

echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  🎉 اكتمل إنشاء Keystore!${NC}"
echo -e "${BLUE}============================================${NC}"
echo
echo -e "${BLUE}📁 الملفات المنشأة:${NC}"
echo "   - android/upload-keystore.jks"
echo "   - android/key.properties"
echo
echo -e "${RED}⚠️ مهم جداً - احتفظ بنسخة احتياطية آمنة من:${NC}"
echo "   1. android/upload-keystore.jks"
echo "   2. كلمات المرور (Store & Key Password)"
echo "   3. هذا الملف لن يتم رفعه لـ Git (مضاف لـ .gitignore)"
echo
echo -e "${BLUE}📝 لتفعيل التوقيع الرسمي، أضف إلى android/app/build.gradle:${NC}"
echo
cat <<'EOF'
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            ...
        }
    }
EOF
echo