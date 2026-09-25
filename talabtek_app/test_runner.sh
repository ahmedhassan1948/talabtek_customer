#!/bin/bash
# طلبك - تشغيل الاختبارات (macOS/Linux)
# Talabtek - Test Runner

set -e

# ألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  طلبك - تشغيل الاختبارات${NC}"
echo -e "${BLUE}  Talabtek - Test Runner${NC}"
echo -e "${BLUE}============================================${NC}"
echo

echo "اختر نوع الاختبار:"
echo
echo "1) اختبارات الوحدة (Unit Tests)"
echo "2) اختبارات الويدجت (Widget Tests)"
echo "3) اختبارات التكامل (Integration Tests) - يتطلب جهاز/محاكي"
echo "4) جميع الاختبارات مع التغطية"
echo "5) تحليل الكود (flutter analyze)"
echo "6) تنسيق الكود (dart format)"
echo "7) فحص شامل (Analyze + Format + Test)"
echo

read -p "اختر رقم (1-7): " CHOICE

run_unit_tests() {
    echo -e "${YELLOW}[1/1]${NC} تشغيل اختبارات الوحدة..."
    flutter test test/models_test.dart --reporter=expanded
}

run_widget_tests() {
    echo -e "${YELLOW}[1/1]${NC} تشغيل اختبارات الويدجت..."
    flutter test test/widgets_test.dart --reporter=expanded
}

run_integration_tests() {
    echo -e "${YELLOW}[1/1]${NC} تشغيل اختبارات التكامل..."
    echo "تأكد من تشغيل محاكي أو توصيل جهاز حقيقي"
    read -p "Device ID (أو اترك فارغاً للقائمة): " DEVICE_ID
    
    if [ -z "$DEVICE_ID" ]; then
        flutter devices
        read -p "أدخل Device ID: " DEVICE_ID
    fi
    
    flutter test integration_test/app_flow_test.dart -d "$DEVICE_ID"
}

run_all_tests() {
    echo -e "${YELLOW}[1/3]${NC} تشغيل جميع الاختبارات مع التغطية..."
    flutter test --coverage --reporter=expanded
    
    echo -e "${YELLOW}[2/3]${NC} إنشاء تقرير التغطية..."
    if [ -f "coverage/lcov.info" ]; then
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}تقرير HTML متاح في: coverage/html/index.html${NC}"
    else
        echo -e "${RED}لم يتم العثور على ملف التغطية${NC}"
    fi
}

run_analyze() {
    echo -e "${YELLOW}[1/1]${NC} تحليل الكود..."
    flutter analyze
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ لا توجد مشاكل${NC}"
    else
        echo -e "${RED}❌ توجد مشاكل تحتاج إصلاح${NC}"
    fi
}

run_format() {
    echo -e "${YELLOW}[1/1]${NC} تنسيق الكود..."
    dart format --output=none --set-exit-if-changed .
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ الكود منسق بشكل صحيح${NC}"
    else
        echo -e "${RED}❌ يحتاج تنسيق - شغل: dart format .${NC}"
    fi
}

run_full_check() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  فحص شامل${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo
    
    echo -e "${YELLOW}[1/4]${NC} تنسيق الكود..."
    dart format --output=none --set-exit-if-changed .
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ فشل التنسيق${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ تم التنسيق${NC}"
    echo
    
    echo -e "${YELLOW}[2/4]${NC} تحليل الكود..."
    flutter analyze
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ فشل التحليل${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ تم التحليل${NC}"
    echo
    
    echo -e "${YELLOW}[3/4]${NC} اختبارات الوحدة والويدجت..."
    flutter test test/models_test.dart test/widgets_test.dart --reporter=expanded
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ فشلت الاختبارات${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ نجحت الاختبارات${NC}"
    echo
    
    echo -e "${YELLOW}[4/4]${NC} إنشاء التغطية..."
    flutter test --coverage
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ فشل إنشاء التغطية${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ تم إنشاء التغطية${NC}"
    echo
    
    echo -e "${BLUE}============================================${NC}"
    echo -e "${GREEN}  ✅ الفحص الشامل اكتمل بنجاح! 🎉${NC}"
    echo -e "${BLUE}============================================${NC}"
}

case $CHOICE in
    1) run_unit_tests ;;
    2) run_widget_tests ;;
    3) run_integration_tests ;;
    4) run_all_tests ;;
    5) run_analyze ;;
    6) run_format ;;
    7) run_full_check ;;
    *) 
        echo -e "${RED}اختيار غير صحيح${NC}"
        exit 1
        ;;
esac

echo
echo -e "${BLUE}============================================${NC}"